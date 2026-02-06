local M = {}

local uv = vim.uv or vim.loop

---@param opts snacks.picker.grep.Config
---@param filter snacks.picker.Filter
local function get_cmd(opts, filter)
  local cmd = "ast-grep"
  local args = { "run", "--color=never", "--json=stream" }

  args = vim.deepcopy(args)
  if vim.fn.has("win32") == 1 then
    cmd = "sg"
  end

  if opts.hidden then
    args[#args + 1] = "--no-ignore=hidden"
  end

  if opts.ignored then
    args[#args + 1] = "--no-ignore=vcs"
  end

  local pattern, pargs = Snacks.picker.util.parse(filter.search)
  args[#args + 1] = string.format("--pattern=%s", pattern)
  vim.list_extend(args, pargs)

  return cmd, args
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
    Snacks.notify.info("ast-grep: " .. cmd .. " " .. table.concat(args, " "))
  end

  return require("snacks.picker.source.proc").proc(
    ctx:opts({
      notify = false, -- never notify on grep errors, since it's impossible to know if the error is due to the search pattern
      cmd = cmd,
      args = args,
      ---@param item snacks.picker.finder.Item
      transform = function(item)
        local entry = vim.json.decode(item.text)
        if vim.tbl_isempty(entry) then
          return false
        end

        local start = entry.range.start
        item.cwd = cwd
        item.file = entry.file
        item.line = entry.text
        item.pos = { tonumber(start.line) + 1, tonumber(start.column) }
      end,
    }),
    ctx
  )
end

return M
