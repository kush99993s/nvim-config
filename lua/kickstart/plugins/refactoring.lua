return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'lewis6991/async.nvim', -- Correct async dependency
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('refactoring').setup()
  end,
}
