return {
  -- Local dev checkout (lazy.nvim skips git update for `dir` plugins).
  -- To install from GitHub instead, remove the `dir` line and run :Lazy sync.
  'kush99993s/dbconnector',
  dir = vim.fn.expand('~/Documents/git/personal/dbconnector'),
  dependencies = {},
  build = './build.sh',
  config = function()
    require('dbconnector').setup {
      -- Configuration options (optional)
      -- Default paths:
      -- backend_path: ~/.config/dbconnector/dbconnector
      -- sqlite_path: ~/.config/dbconnector/dbconnector.db
      -- queries_dir: ~/.config/dbconnector/sqlifile
    }
  end,
}
