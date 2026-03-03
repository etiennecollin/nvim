local M = {}

local get_headings = function(bufnr)
  local ts = vim.treesitter

  local lang = ts.language.get_lang(vim.bo[bufnr].filetype)
  if not lang then
    return {}
  end

  local parser = assert(ts.get_parser(bufnr, lang, { error = false }))

  local header_query = [[
      (setext_heading
        heading_content: (_) @h1
        (setext_h1_underline))
      (setext_heading
        heading_content: (_) @h2
        (setext_h2_underline))
      (atx_heading
        (atx_h1_marker)
        heading_content: (_) @h1)
      (atx_heading
        (atx_h2_marker)
        heading_content: (_) @h2)
      (atx_heading
        (atx_h3_marker)
        heading_content: (_) @h3)
      (atx_heading
        (atx_h4_marker)
        heading_content: (_) @h4)
      (atx_heading
        (atx_h5_marker)
        heading_content: (_) @h5)
      (atx_heading
        (atx_h6_marker)
        heading_content: (_) @h6)
    ]]

  local query = ts.query.parse(lang, header_query)
  local root = parser:parse()[1]:root()

  local headings = {}
  for id, node, _, _ in query:iter_captures(root, bufnr) do
    local text = ts.get_node_text(node, bufnr)
    local row, col = node:start()
    table.insert(headings, {
      file = vim.api.nvim_buf_get_name(bufnr),
      pos = { row + 1, col },
      text = text,
      name = text,
      depth = id,
    })
  end

  -- Mark parents and last sibling for snacks tree formatting.
  local parents = {}
  for _, heading in ipairs(headings) do
    local depth = heading.depth
    parents[depth] = heading

    for i = depth - 1, 1, -1 do
      if parents[i] then
        heading.parent = parents[i]
        break
      end
    end

    for i = depth + 1, 6 do
      if parents[i] then
        parents[i].last = true
        parents[i] = nil
      end
    end
  end

  for i = 1, 6 do
    if parents[i] then
      parents[i].last = true
    end
  end

  return headings
end

local function format_headings(item, picker)
  local result = {}
  vim.list_extend(result, Snacks.picker.format.tree(item, picker))
  Snacks.picker.highlight.format(item, item.text, result)
  return result
end

function M.picker()
  Snacks.picker({
    layout = { reverse = false },
    items = get_headings(0),
    format = format_headings,
  })
end

return M
