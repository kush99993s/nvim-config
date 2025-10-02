local M = {}
-- if you get Session/line number was not unique in database. then it is related to ipython
-- Function to send code from #%% to the next #%% or end of file

function M.send_whole()
  local bufnr = vim.api.nvim_get_current_buf()
  local total = vim.api.nvim_buf_line_count(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, total, false)

  -- Trim trailing empty lines to avoid sending a lone terminator/blank block
  while #lines > 0 and lines[#lines] == '' do
    table.remove(lines)
  end

  -- Join with single newlines and ensure exactly one newline at the end
  local text = table.concat(lines, '\n') .. '\n'

  local ok, err = pcall(function()
    vim.fn['slime#send'](text)
  end)
  if not ok then
    vim.notify('Error sending buffer content: ' .. err, vim.log.levels.ERROR)
  end
end

function M.send_cell()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor[1]

  -- Find the start of the cell
  local start_line = current_line
  while start_line > 1 do
    local line_content = vim.api.nvim_buf_get_lines(bufnr, start_line - 2, start_line - 1, false)[1]
    if string.match(line_content, '^# %%') then
      break
    end
    start_line = start_line - 1
  end

  -- Find the end of the cell
  local end_line = current_line
  local total_lines = vim.api.nvim_buf_line_count(bufnr)
  while end_line < total_lines do
    local line_content = vim.api.nvim_buf_get_lines(bufnr, end_line, end_line + 1, false)[1]
    if string.match(line_content, '^# %%') then
      break
    end
    end_line = end_line + 1
  end

  -- Extract the cell content
  local cell_content = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)

  -- Join the cell content into a single string
  local cell_text = table.concat(cell_content, '\n')

  -- Debugging prints
  print('Start line: ' .. start_line)
  print('End line: ' .. end_line)
  print('Cell content: ' .. cell_text)

  -- Send the cell content to the terminal with error handling
  local status, err = pcall(function()
    vim.fn['slime#send'](cell_text)
  end)

  if not status then
    print('Error sending cell content: ' .. err)
  end
end

-- Function to send the current line
function M.send_line()
  vim.cmd 'normal! V'
  vim.cmd 'SlimeSend'
end

-- Function to send selected lines in visual mode
function M.send_visual()
  vim.cmd 'SlimeSend'
end

return M
