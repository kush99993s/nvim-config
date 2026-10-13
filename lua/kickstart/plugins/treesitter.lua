return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    -- Neovim 0.12 requires the rewrite on `main`. The frozen `master` branch
    -- still treats a query capture as one node, so markdown injections crash
    -- in `vim.treesitter.get_range` (`attempt to call method 'range'`).
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- Parsers to install up front. Other supported languages are installed
      -- on first open (the old `auto_install` behavior).
      local parsers = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'python',
        'go',
        'javascript',
        'json',
        'typescript',
        'yaml',
        'sql',
      }
      require('nvim-treesitter').install(parsers)

      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        if not vim.treesitter.language.add(language) then
          return
        end

        vim.treesitter.start(buf, language)

        -- Treesitter indent is experimental and only applies when a query exists.
        if vim.treesitter.query.get(language, 'indents') then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      local available_parsers = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          local installed_parsers = require('nvim-treesitter').get_installed 'parsers'
          if vim.tbl_contains(installed_parsers, language) then
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            require('nvim-treesitter').install(language):await(function()
              treesitter_try_attach(buf, language)
            end)
          else
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
