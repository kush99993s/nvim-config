return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        --typescript = { 'biomejs', 'eslint_d' },
        css = { 'stylelint' },
        html = { 'htmlhint' },
        --javascript = { 'biomejs', 'eslint_d' },
        python = { 'flake8' },
        sql = { 'sqlfluff' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.

      --      local eslint = lint.linters.eslint_d
      --
      --      eslint.args = {
      --        '--no-warn-ignored', -- <-- this is the key argument
      --        '--format',
      --        'json',
      --        '--stdin',
      --        '--stdin-filename',
      --        function()
      --          return vim.api.nvim_buf_get_name(0)
      --        end,
      --      }

      -- Only run linters whose executable actually exists. Without this a
      -- missing tool (sqlfluff, stylelint, ...) throws
      -- "Error running <linter>: ENOENT" on every BufEnter -- including netrw
      -- and other scratch buffers, which is where it is most confusing.
      local function lint_if_available()
        if vim.bo.buftype ~= '' then
          return -- netrw, terminals, quickfix, help, ...
        end

        local names = lint.linters_by_ft[vim.bo.filetype] or {}
        local runnable = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          local cmd = type(linter) == 'table' and linter.cmd or nil
          return type(cmd) == 'string' and vim.fn.executable(cmd) == 1
        end, names)

        if #runnable > 0 then
          lint.try_lint(runnable)
        end
      end

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = lint_if_available,
      })

      vim.keymap.set('n', '<leader>ll', function()
        lint.try_lint()
      end, { desc = 'Trigger linting for current file' })
    end,
  },
}
