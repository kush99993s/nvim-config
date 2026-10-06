return {
  'vim-test/vim-test',
  dependencies = {
    'preservim/vimux',
  },
  -- NOTE: these used to be bare `vim.keymap.set(...)` calls inside the spec
  -- table, which ran at startup (before the plugin loaded) and silently
  -- overwrote the <leader>tn tab mapping. `keys` defers both the mapping and
  -- the plugin load until first use.
  keys = {
    { '<leader>tn', '<cmd>TestNearest<cr>', desc = '[T]est [N]earest' },
    { '<leader>tf', '<cmd>TestFile<cr>', desc = '[T]est [F]ile' },
    { '<leader>ts', '<cmd>TestSuite<cr>', desc = '[T]est [S]uite' },
    { '<leader>tl', '<cmd>TestLast<cr>', desc = '[T]est [L]ast' },
    { '<leader>tv', '<cmd>TestVisit<cr>', desc = '[T]est [V]isit' },
  },
  init = function()
    vim.g['test#strategy'] = 'vimux'
  end,
}
-- vim: ts=2 sts=2 sw=2 et
