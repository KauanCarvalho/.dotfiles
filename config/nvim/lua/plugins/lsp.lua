return {
  {
    'hrsh7th/nvim-cmp',
    event = 'VeryLazy',
    dependencies = {
      { 'L3MON4D3/LuaSnip' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      end

      local cmp_config = {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-b>'] = cmp.mapping.scroll_docs(-3),
          ['<C-f>'] = cmp.mapping.scroll_docs(3),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<CR>'] = function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then
              cmp.confirm({ select = false })
            else
              fallback()
            end
          end,
          ['<C-p>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            else
              cmp.complete()
            end
          end),
          ['<C-n>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end),
          ['<Esc>'] = function(fallback)
            if cmp.get_selected_entry() then
              cmp.abort()
            else
              fallback()
            end
          end
        },
        formatting = {
          fields = { 'abbr', 'menu', 'kind' },
          format = function(entry, item)
            local short_name = {
              nvim_lsp = 'LSP',
              nvim_lua = 'nvim'
            }

            local menu_name = short_name[entry.source.name] or entry.source.name

            item.menu = string.format('[%s]', menu_name)
            return item
          end,
        },
        window = {
          documentation = {
            max_height = 15,
            max_width = 60,
          }
        },
        sources = {
          { name = 'copilot',                keyword_length = 0 },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
        experimental = {
          ghost_text = true
        }
      }

      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )

      cmp.setup(cmp_config)
    end
  },
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
    },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
      }
      local group = vim.api.nvim_create_augroup('DetectWhichLspRubyToStart', { clear = true })

      local default_opt = { autostart = true, capabilities = capabilities }

      local lsp_server_setup = function(server, opt)
        lspconfig[server].setup(vim.tbl_deep_extend('force', default_opt, opt or {}))
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'ruby',
        once = true,
        group = group,
        callback = function()
          vim.schedule(function()
            local root_path = vim.fs.dirname(vim.fs.find({ 'Gemfile' }, { upward = true })[1])
            local grep_command = "grep -E -i \"gem.*standard[\\\"'].*\""
            local grep_result = vim.fn.system(table.concat({ grep_command, ' ', root_path or '', '/Gemfile' }))

            if grep_result == nil or grep_result == '' then
              lsp_server_setup('solargraph')
              vim.cmd('LspStart solargraph')
            else
              lsp_server_setup('solargraph', { handlers = { ['textDocument/publishDiagnostics'] = function() end } })
              lsp_server_setup('standardrb')

              vim.cmd('LspStart solargraph')
              vim.cmd('LspStart standardrb')
            end

            lsp_server_setup('ruby_lsp')
            vim.cmd('LspStart ruby_lsp')
          end)
        end
      })

      require('mason').setup({ autostart = false })
      require('mason-lspconfig').setup({
        ensure_installed = {},
        handlers = {
          lsp_server_setup,
          standardrb = function() end,
          solargraph = function() end,
          lua_ls = function()
            lspconfig.lua_ls.setup({
              settings = {
                Lua = {
                  runtime = {
                    version = 'LuaJIT'
                  },
                  diagnostics = {
                    globals = { 'vim' },
                  },
                  workspace = {
                    library = {
                      vim.env.VIMRUNTIME,
                    }
                  }
                }
              }
            })
          end,
        },
      })
    end
  },
}
