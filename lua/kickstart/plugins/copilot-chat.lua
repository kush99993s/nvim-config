-- CopilotChat: macOS only (see copilot.lua).
local is_mac = vim.fn.has 'mac' == 1

return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    cond = is_mac,
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
