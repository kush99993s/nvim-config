-- Codex: macOS only (see copilot.lua).
local is_mac = vim.fn.has 'mac' == 1

return {
  'nwiizo/codex.nvim',
  cond = is_mac,
  event = 'VeryLazy', -- load before selecting text to show Ask/Edit hints
  cmd = {
    'Codex',
    'CodexOpen',
    'CodexClose',
    'CodexFocus',
    'CodexResume',
    'CodexContinue',
    'CodexFork',
    'CodexReview',
    'CodexImage',
    'CodexPrompt',
    'CodexAsk',
    'CodexAskVisual',
    'CodexFollowUp',
    'CodexEdit',
    'CodexSend',
    'CodexSendVisual',
    'CodexAddVisual',
    'CodexAdd',
    'CodexTreeAdd',
    'CodexDiff',
    'CodexInterrupt',
    'CodexStatus',
    'CodexStop',
    'CodexHealth',
  },
  opts = {},
}
