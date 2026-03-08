local M = {}
-- if you get Session/line number was not unique in database. then it is related to ipython
-- Function to send code from #%% to the next #%% or end of file

-- Flexible cell marker pattern: # followed by only spaces and % (at least 2 %)
-- Matches: #%%, # %%, # %%%,  #  %  %, etc.
-- Does NOT match: #abc%%, #.%%, etc.
local function is_cell_marker(line)
  -- Remove leading # and check if rest contains only spaces and % with at least 2 %
  if not string.match(line, '^#') then
    return false
  end
  local after_hash = string.sub(line, 2)
  -- Check that it only contains spaces and %
  if string.match(after_hash, '[^%s%%]') then
    return false
  end
  -- Count % signs - need at least 2
  local _, count = string.gsub(after_hash, '%%', '')
  return count >= 2
end

-- Send code directly to IPython using %cpaste
local function send_to_ipython(text)
  local ok, err = pcall(function()
    vim.fn['slime#send']('%cpaste -q\n' .. text .. '\n--\n')
  end)
  if not ok then
    vim.notify('Error sending content: ' .. err, vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Send entire buffer as one block
function M.send_whole()
  local bufnr = vim.api.nvim_get_current_buf()
  local total = vim.api.nvim_buf_line_count(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, total, false)
  local text = table.concat(lines, '\n')
  send_to_ipython(text)
end

-- Send all cells in document one by one with delay between each
function M.send_all_cells(delay_ms)
  delay_ms = delay_ms or 1000 -- default 1 second between cells

  local bufnr = vim.api.nvim_get_current_buf()
  local total_lines = vim.api.nvim_buf_line_count(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, total_lines, false)

  -- Collect all cells
  local cells = {}
  local current_cell = {}

  for _, line in ipairs(lines) do
    if is_cell_marker(line) then
      if #current_cell > 0 then
        table.insert(cells, table.concat(current_cell, '\n'))
      end
      current_cell = {}
    else
      table.insert(current_cell, line)
    end
  end

  -- Last cell
  if #current_cell > 0 then
    table.insert(cells, table.concat(current_cell, '\n'))
  end

  if #cells == 0 then
    vim.notify('No cells found', vim.log.levels.WARN)
    return
  end

  vim.notify('Sending ' .. #cells .. ' cells...', vim.log.levels.INFO)

  -- Send cells with delay
  local idx = 1
  local function send_next()
    if idx > #cells then
      vim.notify('All ' .. #cells .. ' cells sent', vim.log.levels.INFO)
      return
    end
    send_to_ipython(cells[idx])
    idx = idx + 1
    if idx <= #cells then
      vim.defer_fn(send_next, delay_ms)
    else
      vim.defer_fn(function()
        vim.notify('All ' .. #cells .. ' cells sent', vim.log.levels.INFO)
      end, 100)
    end
  end
  send_next()
end

function M.send_cell()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor[1]

  -- Find the start of the cell
  local start_line = current_line
  while start_line > 1 do
    local line_content = vim.api.nvim_buf_get_lines(bufnr, start_line - 2, start_line - 1, false)[1]
    if is_cell_marker(line_content) then
      break
    end
    start_line = start_line - 1
  end

  -- Find the end of the cell
  local end_line = current_line
  local total_lines = vim.api.nvim_buf_line_count(bufnr)
  while end_line < total_lines do
    local line_content = vim.api.nvim_buf_get_lines(bufnr, end_line, end_line + 1, false)[1]
    if is_cell_marker(line_content) then
      break
    end
    end_line = end_line + 1
  end

  -- Extract the cell content
  local cell_content = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)

  -- Remove cell marker line if it's at the start
  if #cell_content > 0 and is_cell_marker(cell_content[1]) then
    table.remove(cell_content, 1)
  end

  local cell_text = table.concat(cell_content, '\n')
  send_to_ipython(cell_text)
end

-- Function to send the current line
function M.send_line()
  local line = vim.api.nvim_get_current_line()
  if line and line ~= '' then
    send_to_ipython(line)
  end
end

-- Function to send selected lines in visual mode
function M.send_visual()
  -- Get visual selection
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = start_pos[2]
  local end_line = end_pos[2]

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
  local text = table.concat(lines, '\n')
  send_to_ipython(text)
end

return M
