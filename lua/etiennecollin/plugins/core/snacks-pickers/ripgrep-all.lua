local M = {}

local uv = vim.uv or vim.loop

local MATCH_SEP = "󰄊󱥳󱥰"

---@param opts snacks.picker.grep.Config
---@param filter snacks.picker.Filter
local function get_cmd(opts, filter)
  local cmd = "rga"
  local args = {
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--replace",
    ("%s${0}%s"):format(MATCH_SEP, MATCH_SEP),
    "--column",
    "--smart-case",
    "--max-columns=500",
    "--max-columns-preview",
    "--glob=!.bare",
    "--glob=!.git",
    "-0",
  }

  args = vim.deepcopy(args)

  -- exclude
  for _, e in ipairs(opts.exclude or {}) do
    vim.list_extend(args, { "-g", "!" .. e })
  end

  -- hidden
  if opts.hidden then
    args[#args + 1] = "--hidden"
  else
    args[#args + 1] = "--no-hidden"
  end

  -- ignored
  if opts.ignored then
    args[#args + 1] = "--no-ignore"
  end

  -- follow
  if opts.follow then
    args[#args + 1] = "-L"
  end

  local types = type(opts.ft) == "table" and opts.ft or { opts.ft }
  ---@cast types string[]
  for _, t in ipairs(types) do
    args[#args + 1] = "-t"
    args[#args + 1] = t
  end

  if opts.regex == false then
    args[#args + 1] = "--fixed-strings"
  end

  local glob = type(opts.glob) == "table" and opts.glob or { opts.glob }
  ---@cast glob string[]
  for _, g in ipairs(glob) do
    args[#args + 1] = "-g"
    args[#args + 1] = g
  end

  -- extra args
  vim.list_extend(args, opts.args or {})

  -- search pattern
  local pattern, pargs = Snacks.picker.util.parse(filter.search)
  vim.list_extend(args, pargs)

  args[#args + 1] = "--"
  args[#args + 1] = pattern

  -- Add directories to search
  local paths = {} ---@type string[]

  if opts.buffers then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" and vim.bo[buf].buflisted and uv.fs_stat(name) then
        paths[#paths + 1] = name
      end
    end
  end
  vim.list_extend(paths, opts.dirs or {})
  if opts.rtp then
    vim.list_extend(paths, Snacks.picker.util.rtp())
  end

  -- dirs
  if #paths > 0 then
    paths = vim.tbl_map(svim.fs.normalize, paths) ---@type string[]
    vim.list_extend(args, paths)
  end

  return cmd, args
end

---Create resolve function for match position highlighting
---@param item snacks.picker.finder.Item The item to resolve
---@param text string The text to search for matches
---@param col number Starting column
---@param line_num number Line number for position
---@return function
local function create_resolve_fn(item, text, col, line_num)
  return function()
    local positions = {} ---@type number[]
    local offset = 0
    local in_match = false
    local from = col

    while from < #text do
      local idx = text:find(MATCH_SEP, from, true)
      if not idx then
        break
      end
      if in_match then
        for i = from, idx - 1 do
          positions[#positions + 1] = i - offset
        end
        item.end_pos = item.end_pos or { line_num, idx - offset - 1 }
      end
      in_match = not in_match
      offset = offset + #MATCH_SEP
      from = idx + #MATCH_SEP
    end

    item.positions = #positions > 0 and positions or nil
    item.line = text:gsub(MATCH_SEP, "")
  end
end

---Match PDF output: line:col:Page page:text
---@param rest string
---@param item snacks.picker.finder.Item
---@return snacks.picker.finder.Item?
local function match_pdf(rest, item)
  local line, col, page, text = rest:match("^(%d+):(%d+):%s*Page%s+(%d+):%s*(.*)$")
  if not (line and col and page and text) then
    return nil
  end

  local line_num = tonumber(line)
  local col_num = tonumber(col)

  if not (line_num and col_num) then
    return nil
  end

  item.page = tonumber(page)
  item.pos = { line_num, col_num - 1 }
  item.resolve = create_resolve_fn(item, text, col_num, line_num)

  return item
end

---Match non-PDF output: line:col:text
---@param rest string
---@param item snacks.picker.finder.Item
---@return snacks.picker.finder.Item?
local function match_regular(rest, item)
  local line, col, text = rest:match("^(%d+):(%d+):(.*)$")
  if not (line and col and text) then
    return nil
  end

  local line_num = tonumber(line)
  local col_num = tonumber(col)

  if not (line_num and col_num) then
    return nil
  end

  item.pos = { line_num, col_num - 1 }
  item.resolve = create_resolve_fn(item, text, col_num, line_num)

  return item
end

---@param opts snacks.picker.grep.Config
---@type snacks.picker.finder
function M.finder(opts, ctx)
  -- Return early if no search pattern (unless explicitly disabled)
  if opts.need_search ~= false and ctx.filter.search == "" then
    return function() end
  end
  local absolute = (opts.dirs and #opts.dirs > 0) or opts.buffers or opts.rtp
  local cwd = not absolute and svim.fs.normalize(opts and opts.cwd or uv.cwd() or ".") or nil
  local cmd, args = get_cmd(opts, ctx.filter)

  if opts.debug.grep then
    Snacks.notify.info("rga: " .. cmd .. " " .. table.concat(args, " "))
  end

  return require("snacks.picker.source.proc").proc(
    ctx:opts({
      notify = false, -- never notify on grep errors, since it's impossible to know if the error is due to the search pattern
      cmd = cmd,
      args = args,
      ---@param item snacks.picker.finder.Item
      transform = function(item)
        item.cwd = cwd
        -- Split on NUL byte (which comes from rg's -0 flag)
        local file_sep = item.text:find("\0")
        if not file_sep then
          if not item.text:match("WARNING") then
            Snacks.notify.error("invalid grep output:\n" .. item.text)
          end
          return false
        end

        local file = item.text:sub(1, file_sep - 1)
        local rest = item.text:sub(file_sep + 1)

        -- Set basic item info
        item.file = file
        item.text = file .. ":" .. rest:gsub(MATCH_SEP, "")
        item.ext = string.lower(vim.fn.fnamemodify(file, ":e"))

        -- Try PDF matcher first
        local result = match_pdf(rest, item)
        if result then
          return result
        end

        -- Try regular file matcher
        result = match_regular(rest, item)
        if result then
          return result
        end

        -- If no matcher succeeded, log error and skip
        if not item.text:match("WARNING") then
          Snacks.notify.error("invalid rga output:\n" .. item.text)
        end

        -- Invalid line, skip it
        return false
      end,
    }),
    ctx
  )
end

---@param item snacks.picker.finder.Item
function M.formatter(item, picker)
  ---@type snacks.picker.Highlight[]
  local ret = {}

  if item.label then
    ret[#ret + 1] = { item.label, "SnacksPickerLabel" }
    ret[#ret + 1] = { " ", virtual = true }
  end

  if item.parent then
    vim.list_extend(ret, M.tree(item, picker))
  end

  if item.status then
    vim.list_extend(ret, M.file_git_status(item, picker))
  end

  if item.severity then
    vim.list_extend(ret, M.severity(item, picker))
  end

  vim.list_extend(ret, M.filename(item, picker))

  if item.comment then
    ret[#ret + 1] = { item.comment, "SnacksPickerComment" }
    ret[#ret + 1] = { " " }
  end

  if item.page then
    Snacks.picker.highlight.format(item, item.page, ret)
    ret[#ret + 1] = { " " }
  elseif item.line then
    if item.positions then
      local offset = Snacks.picker.highlight.offset(ret)
      Snacks.picker.highlight.matches(ret, item.positions, offset)
    end
    Snacks.picker.highlight.format(item, item.line, ret)
    ret[#ret + 1] = { " " }
  end
  return ret
end

return M
