local M = {}

--- Displays a warning notification in Neovim.
---
--- @param message string The warning message to display.
--- @return nil
local function warn(message)
  vim.notify(message, vim.log.levels.WARN, {
    title = "Number preview",
  })
end

--- Splits a string into groups of a specified size, starting from the right.
--- Joins the groups together with spaces.
---
--- @param s string The string to split into groups.
--- @param size integer The maximum number of characters per group.
--- @return string The grouped string separated by spaces.
local function group_digits(s, size)
  local groups = {}
  local last = #s

  while last > 0 do
    local first = math.max(1, last - size + 1)
    table.insert(groups, 1, s:sub(first, last))
    last = first - 1
  end

  return table.concat(groups, " ")
end

--- Converts a hexadecimal character into its numeric value (0–15).
--- Returns `nil` if the character is not a valid hexadecimal digit.
---
--- @param char string A single hexadecimal character.
--- @return integer|nil The numeric value of the character, or nil if invalid.
local function digit_value(char)
  local byte = char:byte()

  if byte >= 48 and byte <= 57 then
    return byte - 48
  elseif byte >= 65 and byte <= 70 then
    return byte - 65 + 10
  elseif byte >= 97 and byte <= 102 then
    return byte - 97 + 10
  end

  return nil
end

--- Parses an integer string into a little-endian array of binary bits.
--- Supports decimal, hexadecimal, and binary integer representations.
--- Avoids converting the entire value into a Lua number.
---
--- @param token string The integer string to parse.
--- @return integer[]|nil The binary bits in little-endian order, or nil if invalid.
local function parse_bits(token)
  local base, digits

  -- Check whether number is binary, hex or decimal
  if token:match("^0[xX]%x+$") then
    base, digits = 16, token:sub(3)
  elseif token:match("^0[bB][01]+$") then
    base, digits = 2, token:sub(3)
  elseif token:match("^%d+$") then
    base, digits = 10, token
  else
    return nil
  end

  local bits = { 0 }

  for i = 1, #digits do
    local digit = digit_value(digits:sub(i, i))

    -- Make sure digit is valid
    if not digit or digit >= base then
      return nil
    end

    -- Convert a digit from a given base into its binary representation
    -- bits = bits * base + digit
    local carry = digit

    for j = 1, #bits do
      local value = bits[j] * base + carry
      bits[j] = value % 2
      carry = math.floor(value / 2)
    end

    while carry > 0 do
      bits[#bits + 1] = carry % 2
      carry = math.floor(carry / 2)
    end
  end

  return bits
end

--- Converts a table of binary bits into a binary string.
--- Bits are stored in little-endian order and reversed during conversion.
---
--- @param bits integer[] Binary bits in little-endian order.
--- @return string The binary representation.
local function bits_to_binary(bits)
  local result = {}

  for i = #bits, 1, -1 do
    result[#result + 1] = tostring(bits[i])
  end

  return table.concat(result)
end

--- Converts a table of binary bits into a hexadecimal string.
--- Processes bits in groups of four and removes leading zeroes.
---
--- @param bits integer[] Binary bits in little-endian order.
--- @return string The uppercase hexadecimal representation.
local function bits_to_hex(bits)
  local digits = "0123456789ABCDEF"
  local result = {}

  -- Convert groups of four bits to hexadecimal digits.
  for i = 1, #bits, 4 do
    local value = 0

    for j = 0, 3 do
      local bit = bits[i + j]
      if bit then
        value = value + bit * (2 ^ j)
      end
    end

    result[#result + 1] = digits:sub(value + 1, value + 1)
  end

  -- Remove leading zeroes (the array is little-endian).
  while #result > 1 and result[#result] == "0" do
    result[#result] = nil
  end

  local reversed = {}

  for i = #result, 1, -1 do
    reversed[#reversed + 1] = result[i]
  end

  return table.concat(reversed)
end

--- Converts a table of binary bits into a decimal string.
--- Uses manual decimal arithmetic to avoid Lua number precision limits.
---
--- @param bits integer[] Binary bits in little-endian order.
--- @return string The decimal representation.
local function bits_to_decimal(bits)
  -- Decimal digits stored in little-endian order.
  local digits = { 0 }

  -- Repeatedly multiply the decimal result by two and add each bit.
  for i = #bits, 1, -1 do
    local carry = bits[i]

    for j = 1, #digits do
      local value = digits[j] * 2 + carry
      digits[j] = value % 10
      carry = math.floor(value / 10)
    end

    while carry > 0 do
      digits[#digits + 1] = carry % 10
      carry = math.floor(carry / 10)
    end
  end

  local result = {}

  for i = #digits, 1, -1 do
    result[#result + 1] = tostring(digits[i])
  end

  return table.concat(result)
end

--- Displays the decimal, hexadecimal, and binary representations of the
--- integer literal under the cursor in a Neovim floating preview window.
---
--- Identifies and extracts the token under the cursor, validates that it is
--- a supported integer literal, and converts it into binary bits. The bits
--- are then used to generate decimal, hexadecimal, and binary representations.
--- Supports unary negative values and rejects floating-point numbers.
---
--- Displays a warning if no valid number is found or the token is unsupported.
---
--- @return nil
function M.show()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  if not line:sub(col, col):match("[%w_]") then
    warn("No number under cursor")
    return
  end

  -- Find the token under the cursor.
  local start_col, end_col = col, col

  while start_col > 1 and line:sub(start_col - 1, start_col - 1):match("[%w_]") do
    start_col = start_col - 1
  end

  while end_col <= #line and line:sub(end_col, end_col):match("[%w_]") do
    end_col = end_col + 1
  end

  local token = line:sub(start_col, end_col - 1)

  -- Reject decimal floating-point values.
  local before_dot = line:sub(start_col - 1, start_col - 1) == "."
  local after_dot = line:sub(end_col, end_col) == "." and line:sub(end_col + 1, end_col + 1):match("%d")

  if before_dot or after_dot then
    warn("Only integer literals are supported")
    return
  end

  -- Support unary negative values, e.g. -255 or -0xFF.
  local negative = line:sub(start_col - 1, start_col - 1) == "-"
    and (start_col <= 2 or not line:sub(start_col - 2, start_col - 2):match("[%w_%.]"))

  local bits = parse_bits(token)

  if not bits then
    warn(("'%s' is not a supported integer"):format(token))
    return
  end

  local is_zero = #bits == 1 and bits[1] == 0
  local sign = negative and not is_zero and "-" or ""

  local lines = {
    ("Decimal: %s%s"):format(sign, group_digits(bits_to_decimal(bits), 3)),
    ("Hex:     %s0x%s"):format(sign, group_digits(bits_to_hex(bits), 4)),
    ("Binary:  %s0b%s"):format(sign, bits_to_binary(bits)),
  }

  vim.lsp.util.open_floating_preview(lines, "text", {
    border = "rounded",
    focusable = false,
    close_events = {
      "CursorMoved",
      "CursorMovedI",
      "BufHidden",
      "InsertEnter",
    },
  })
end

return M
