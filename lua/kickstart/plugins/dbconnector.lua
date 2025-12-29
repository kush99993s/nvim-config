return {
  'kush99993s/dbconnector',
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
