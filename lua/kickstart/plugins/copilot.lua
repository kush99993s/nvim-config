-- GitHub Copilot: macOS only.
-- `cond` keeps the plugin installed but never loads it on other platforms,
-- so lazy-lock.json stays identical across machines.
local is_mac = vim.fn.has 'mac' == 1

return {
  'github/copilot.vim',
  cond = is_mac,
}
