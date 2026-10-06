-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: tab navigation lives on the built-in `gt` / `gT`. The old
-- <leader>tn / <leader>tp pair collided with vim-test (<leader>tn was being
-- silently overwritten by :TestNearest), so it is gone.

-- For Python REPL
vim.g.slime_target = 'neovim'
vim.g.slime_python_ipython = 1

local slime = require 'custom.plugins.slime'

vim.keymap.set('n', '<leader>ic', slime.send_cell, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>il', slime.send_line, { noremap = true, silent = true })
vim.keymap.set('v', '<leader>iv', slime.send_visual, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ih', slime.send_whole, { noremap = true, silent = true })
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
-- [[ dbconnector ]]
--
-- NOTE: <leader>dbs used to be a prefix of <leader>dbsy, so DBSave always
-- stalled for 'timeoutlen' before firing. Sync/Resync moved to shift keys.
--
-- NOTE: the results window and the history float register their own
-- buffer-local keys (f/F/r/s/n/p/u/[/]/q and <CR>, /, <BS>, q, <Esc>), so
-- filtering, CSV export and paging are deliberately not bound here.
local function dbmap(lhs, rhs, desc, opts)
  opts = vim.tbl_extend('force', { desc = 'DB: ' .. desc, silent = true }, opts or {})
  vim.keymap.set(opts.mode or 'n', '<leader>db' .. lhs, rhs, opts)
end

-- Global: connection + metadata, useful from any buffer.
dbmap('c', ':DBConnect<CR>', 'Connect')
dbmap('l', ':DBList<CR>', 'List databases')
dbmap('a', ':DBSetActive ', 'Set active database', { silent = false }) -- takes an argument
dbmap('A', ':DBShowActive<CR>', 'Show active database')
dbmap('t', ':DBBrowseTables<CR>', 'Browse tables')
dbmap('h', ':DBSelectRun<CR>', 'Query history')
dbmap('S', ':DBSync<CR>', 'Sync metadata')
dbmap('R', ':DBResync<CR>', 'Full resync')
dbmap('f', ':DBRefresh<CR>', 'Refresh cache')
dbmap('k', ':DBCacheStats<CR>', 'Cache stats')
dbmap('n', ':DBNewFile<CR>', 'New query file')
dbmap('g', ':DBLogs<CR>', 'Show logs')
dbmap('u', ':DBUnlock<CR>', 'Unlock stale cache locks')
dbmap('P', ':DBRepairBackend<CR>', 'Repair backend')
dbmap('v', ':DBVersion<CR>', 'Version')

-- SQL buffers only: everything that acts on the query under the cursor.
vim.api.nvim_create_autocmd('FileType', {
  desc = 'dbconnector query keymaps',
  group = vim.api.nvim_create_augroup('kickstart-dbconnector', { clear = true }),
  pattern = { 'sql', 'pgsql', 'mysql', 'plsql' },
  callback = function(event)
    local function map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or 'n', '<leader>db' .. lhs, rhs, {
        buffer = event.buf,
        silent = true,
        desc = 'DB: ' .. desc,
      })
    end

    map('r', ':DBRun<CR>', 'Run whole buffer')
    map('e', ':DBRunCurrent<CR>', 'Run query at cursor')
    map('r', ':DBRunSelected<CR>', 'Run selection', 'v')
    map('s', ':DBSave<CR>', 'Save query')
    map('x', ':DBExpandWildcard<CR>', 'Expand * to columns')
    map('C', ':DBShowColumns<CR>', 'Show table columns')
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    -- vim.highlight was renamed to vim.hl in Neovim 0.11
    local hl = vim.hl or vim.highlight
    hl.on_yank()
  end,
})

vim.opt.spelllang = 'en_us'
vim.opt.spell = true
vim.opt.spellsuggest = 'best,9'
-- For Obsidian
vim.opt.conceallevel = 2

function OpenTelescopeInDirectory()
  local dir = vim.fn.input('Directory: ', '', 'dir')
  require('telescope.builtin').find_files { cwd = dir }
end

vim.api.nvim_set_keymap('n', '<leader>sa', ':lua OpenTelescopeInDirectory()<CR>', { noremap = true, silent = true })

-- NOTE: scrolloff is set once, in options.lua.
-- vim: ts=2 sts=2 sw=2 et
