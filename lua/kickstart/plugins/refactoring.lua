return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    -- Check if async module is available before requiring refactoring
    local ok, async = pcall(require, "async")
    if not ok then
      -- Try plenary.async instead
      local plenary_ok, plenary_async = pcall(require, "plenary.async")
      if plenary_ok then
        -- Create a global async alias for refactoring.nvim
        _G.async = plenary_async
      else
        vim.notify("Could not load async module for refactoring.nvim", vim.log.levels.WARN)
        return
      end
    end
    require('refactoring').setup()
  end,
  event = "VeryLazy",
}
