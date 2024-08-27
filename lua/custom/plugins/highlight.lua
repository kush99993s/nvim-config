-- ~/.config/nvim/lua/my_highlighter/highlight.lua

local M = {}

function M.highlight_python_hash()
  -- Define the highlight group with white color
  vim.cmd 'highlight PythonHash guifg=#FFFFFF'

  -- Apply the highlight to the `#` character only in Python files
  vim.cmd [[
    autocmd FileType python syntax match PythonHash /#/
  ]]
end

-- Create an autocommand group to apply the highlighting only when a Python file is opened
vim.cmd [[
  augroup PythonHashHighlight
    autocmd!
    autocmd FileType python lua require('my_highlighter.highlight').highlight_python_hash()
  augroup END
]]

return M
