local api = vim.api
local linematch_limit = 40
local char_diff_limit = 1000

local M = {}

---@alias (private) Span [integer, integer]
---@alias (private) Hunk [integer, integer, integer, integer]

---@class (private) PreviewLine
---@field line string
---@field lnum integer
---@field spans? Span[]

---@param lines string[]
---@return string
local function concat_lines(lines)
  return #lines == 0 and "" or table.concat(lines, "\n") .. "\n"
end

---@param buf integer
---@param ns integer
---@param row integer
---@param line string
---@param col_offset integer
---@param spans? Span[]
local function highlight_line(buf, ns, row, line, col_offset, spans)
  if spans then
    for _, span in ipairs(spans) do
      api.nvim_buf_set_extmark(buf, ns, row, col_offset + span[1], {
        end_col = col_offset + span[2],
        hl_group = "Substitute",
      })
    end
  elseif line ~= "" then
    -- Nil spans list means whole line changed
    api.nvim_buf_set_extmark(buf, ns, row, col_offset, {
      end_col = col_offset + #line,
      hl_group = "Substitute",
    })
  end
end

--- Finds the changed region by trimming common UTF-8 prefix and suffix from both strings.
---
---@param before string
---@param after string
---@return integer prefix First byte of the changed region, one-based.
---@return integer before_suffix Last byte of the changed region in before, one-based.
---@return integer after_suffix Last byte of the changed region in after, one-based.
local function find_changed_bounds(before, after)
  local prefix = 1
  while prefix <= #before and prefix <= #after do
    local before_end = prefix + vim.str_utf_end(before, prefix)
    local after_end = prefix + vim.str_utf_end(after, prefix)
    local before_char = before:sub(prefix, before_end)
    local after_char = after:sub(prefix, after_end)

    if before_char ~= after_char then
      break
    end
    prefix = before_end + 1
  end

  local before_suffix, after_suffix = #before, #after
  while before_suffix >= prefix and after_suffix >= prefix do
    local before_start = before_suffix + vim.str_utf_start(before, before_suffix)
    local after_start = after_suffix + vim.str_utf_start(after, after_suffix)
    local before_char = before:sub(before_start, before_suffix)
    local after_char = after:sub(after_start, after_suffix)

    if before_char ~= after_char then
      break
    end
    before_suffix, after_suffix = before_start - 1, after_start - 1
  end

  return prefix, before_suffix, after_suffix
end

--- Get the changed character spans between two strings.
--- Returns nil if either side of the trimmed region exceeds `char_diff_limit` codepoints.
---
---@param before string
---@param after string
---@return Span[]?
local function get_changed_spans(before, after)
  if before == after then
    return {}
  end

  -- Only consider the changed region, ignoring common prefix and suffix. This reduces diff work and
  -- avoids having to store codepoint boundaries for the entire string.
  local prefix, before_suffix, after_suffix = find_changed_bounds(before, after)
  local before_chars = {} --- @type string[]
  local curr_byte = prefix

  while curr_byte <= before_suffix do
    if #before_chars >= char_diff_limit then
      return nil
    end

    local char_end = curr_byte + vim.str_utf_end(before, curr_byte)
    before_chars[#before_chars + 1] = before:sub(curr_byte, char_end)
    curr_byte = char_end + 1
  end

  local after_chars = {} --- @type string[]
  -- Zero based byte offsets for the start and end of each changed character.
  -- Every character spans the interval [after_boundaries[i], after_boundaries[i + 1]).
  local after_boundaries = { 0 }
  curr_byte = prefix

  while curr_byte <= after_suffix do
    if #after_chars >= char_diff_limit then
      return nil
    end

    local char_end = curr_byte + vim.str_utf_end(after, curr_byte)
    after_chars[#after_chars + 1] = after:sub(curr_byte, char_end)
    after_boundaries[#after_boundaries + 1] = char_end - prefix + 1
    curr_byte = char_end + 1
  end

  -- vim.text.diff() only works on lines, so we put each character on its own line to find the
  -- changed spans.
  local hunks = vim.text.diff(concat_lines(before_chars), concat_lines(after_chars), {
    result_type = "indices",
  }) --[[ @as Hunk[] ]]

  local spans = {} --- @type Span[]
  for _, hunk in ipairs(hunks) do
    local start_after, count_after = hunk[3], hunk[4]

    if count_after > 0 then
      spans[#spans + 1] = {
        prefix - 1 + after_boundaries[start_after],
        prefix - 1 + after_boundaries[start_after + count_after],
      }
    end
  end

  return spans
end

---@param buf integer
---@param ns integer
---@param lines PreviewLine[]
local function render_preview(buf, ns, lines)
  local width = 1
  for _, line in ipairs(lines) do
    width = math.max(width, #tostring(line.lnum))
  end

  local text = {} --- @type string[]
  for index, line in ipairs(lines) do
    local lnum = tostring(line.lnum)
    local prefix = ("|%s%s| "):format(string.rep(" ", width - #lnum), lnum)
    text[index] = prefix .. line.line
  end

  api.nvim_buf_set_lines(buf, 0, -1, false, text)

  for index, line in ipairs(lines) do
    highlight_line(buf, ns, index - 1, line.line, width + 3, line.spans)
  end
end

--- Creates an `'inccommand'` incremental preview handler for a user command.
---
--- The returned handler calls {callback}, highlights changed text with |hl-Substitute|, and, when
--- 'inccommand' is set to "split", shows resulting lines in the preview window. Nvim automatically
--- restores buffer changes made by the handler after displaying the preview.
--- See |:command-preview|.
---
--- Only intended for synchronous callbacks that make undoable changes within the command range of
--- the current buffer. The callback runs whenever the command line changes. Side effects such as
--- writing files, starting jobs, or changing other editor state are not reverted.
---
--- Example:
---
--- ```lua
--- local function upper(opts)
---   local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
---   for i, line in ipairs(lines) do
---     lines[i] = line:upper()
---   end
---   vim.api.nvim_buf_set_lines(0, opts.line1 - 1, opts.line2, false, lines)
--- end
---
--- vim.api.nvim_create_user_command('Upper', upper, {
---   range = true,
---   preview = vim.preview.diff(upper),
--- })
--- ```
---
---@since 15
---@param callback fun(opts: vim.api.keyset.create_user_command.command_args)
---@return fun(opts: vim.api.keyset.create_user_command.command_args, ns: integer, buf?: integer): integer
function M.diff(callback)
  vim.validate("callback", callback, "callable")

  return function(opts, ns, preview_buf)
    local buf = api.nvim_get_current_buf()
    local start_line = opts.line1 - 1
    local line_count = api.nvim_buf_line_count(buf)
    local old_lines = api.nvim_buf_get_lines(buf, start_line, opts.line2, false)

    callback(opts)

    if not api.nvim_buf_is_valid(buf) then
      return 0
    end

    -- Offset the end line to account for any inserted or deleted lines.
    local end_line = opts.line2 + api.nvim_buf_line_count(buf) - line_count
    local new_lines = api.nvim_buf_get_lines(buf, start_line, end_line, false)
    local hunks = vim.text.diff(concat_lines(old_lines), concat_lines(new_lines), {
      result_type = "indices",
      linematch = linematch_limit,
    }) --[[ @as Hunk[] ]]

    if #hunks == 0 then
      return 0
    end

    local preview_lines = preview_buf and {} or nil --- @type PreviewLine[]?

    for _, hunk in ipairs(hunks) do
      local start_a, count_a, start_b, count_b = unpack(hunk)
      local highlight_spans = count_a == count_b and count_a + count_b <= linematch_limit

      for offset = 0, count_b - 1 do
        local index = start_b + offset
        local spans --- @type Span[]?
        if highlight_spans then
          -- Changed lines with the same number of lines before and after, highlight changed spans.
          spans = get_changed_spans(old_lines[start_a + offset], new_lines[index])
        end
        -- Highlight whole lines when line counts differ or when there are too many lines to match.
        highlight_line(buf, ns, start_line + index - 1, new_lines[index], 0, spans)

        if preview_lines then
          preview_lines[#preview_lines + 1] = {
            line = new_lines[index],
            lnum = start_line + index,
            spans = spans,
          }
        end
      end
    end

    if preview_buf and preview_lines and #preview_lines > 0 then
      render_preview(preview_buf, ns, preview_lines)
      return 2
    end

    return 1
  end
end

return M
