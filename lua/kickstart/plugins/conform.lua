return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_format" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 1000,
          lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback',
        }
      end,
      -- NOTE: every formatter below must exist in `conform.formatters` AND be
      -- installed (see the Mason list in lspconfig.lua). `stop_after_first`
      -- means "first one that is installed wins" -- without it conform runs
      -- *all* of them in sequence and they fight over the buffer.
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier', 'biome', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', 'biome', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        toml = { 'taplo' },
        proto = { 'buf' },
        go = { 'gofmt' },
        sql = { 'sqlfluff' },
        -- One Python formatter, not three: black and autopep8 undo each other.
        python = { 'black' },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
