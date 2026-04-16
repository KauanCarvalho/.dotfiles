return {
  'kepano/flexoki-neovim',
  name = 'flexoki',
  priority = 1000,
  config = function()
    require('flexoki').setup({
      variant = 'dark',
      float_window_style = 'border',
      highlight_groups = {
        -- Subtler cursorline / column.
        CursorLine   = { bg = '#1c1b1a' },
        CursorLineNr = { fg = '#cecdc3', bg = '#1c1b1a', bold = true },
        ColorColumn  = { bg = '#1c1b1a' },

        -- Window separators — thin, unobtrusive.
        WinSeparator = { fg = '#282726', bg = '#100f0f' },

        -- Indent guides (indent-blankline).
        IblIndent = { fg = '#1c1b1a' },
        IblScope  = { fg = '#343331' },

        -- Telescope: dark prompt, colored titles.
        TelescopeNormal       = { fg = '#cecdc3', bg = '#100f0f' },
        TelescopeBorder       = { fg = '#282726', bg = '#100f0f' },
        TelescopePromptNormal = { fg = '#cecdc3', bg = '#1c1b1a' },
        TelescopePromptBorder = { fg = '#1c1b1a', bg = '#1c1b1a' },
        TelescopePromptTitle  = { fg = '#100f0f', bg = '#879a39', bold = true },
        TelescopePreviewTitle = { fg = '#100f0f', bg = '#4385be', bold = true },
        TelescopeResultsTitle = { fg = '#1c1b1a', bg = '#1c1b1a' },
        TelescopeSelection    = { bg = '#1c1b1a', bold = true },
        TelescopeMatching     = { fg = '#d0a215', bold = true },

        -- NvimTree: same bg as editor, cleaner look.
        NvimTreeNormal           = { fg = '#cecdc3', bg = '#100f0f' },
        NvimTreeNormalNC         = { fg = '#878580', bg = '#100f0f' },
        NvimTreeEndOfBuffer      = { fg = '#100f0f', bg = '#100f0f' },
        NvimTreeWinSeparator     = { fg = '#282726', bg = '#100f0f' },
        NvimTreeCursorLine       = { bg = '#1c1b1a' },
        NvimTreeFolderName       = { fg = '#4385be' },
        NvimTreeOpenedFolderName = { fg = '#4385be', bold = true },
        NvimTreeRootFolder       = { fg = '#879a39', bold = true },
        NvimTreeSpecialFile      = { fg = '#ce5d97' },
        NvimTreeGitDirty         = { fg = '#d0a215' },
        NvimTreeGitStaged        = { fg = '#879a39' },
        NvimTreeGitDeleted       = { fg = '#d14d41' },

        -- Gitsigns: flexoki accent palette.
        GitSignsAdd      = { fg = '#879a39' },
        GitSignsChange   = { fg = '#4385be' },
        GitSignsDelete   = { fg = '#d14d41' },
        GitSignsAddNr    = { fg = '#879a39' },
        GitSignsChangeNr = { fg = '#4385be' },
        GitSignsDeleteNr = { fg = '#d14d41' },

        -- Diagnostics virtual text: subtle bg so it doesn't clash.
        DiagnosticVirtualTextError = { fg = '#d14d41', bg = '#1c1b1a', italic = true },
        DiagnosticVirtualTextWarn  = { fg = '#d0a215', bg = '#1c1b1a', italic = true },
        DiagnosticVirtualTextInfo  = { fg = '#4385be', bg = '#1c1b1a', italic = true },
        DiagnosticVirtualTextHint  = { fg = '#3aa99f', bg = '#1c1b1a', italic = true },

        -- Floating windows.
        NormalFloat = { bg = '#1c1b1a' },
        FloatBorder = { fg = '#403e3c', bg = '#1c1b1a' },

        -- Search: orange pop.
        Search    = { fg = '#100f0f', bg = '#da702c', bold = true },
        IncSearch = { fg = '#100f0f', bg = '#d0a215', bold = true },
        CurSearch = { fg = '#100f0f', bg = '#d14d41', bold = true },

        -- MatchParen: visible but not jarring.
        MatchParen = { fg = '#ce5d97', bold = true, underline = true },

        -- Statusline: match flexoki bg tones.
        StatusLine   = { fg = '#cecdc3', bg = '#282726' },
        StatusLineNC = { fg = '#878580', bg = '#1c1b1a' },
      }
    })

    vim.cmd('colorscheme flexoki-dark')
  end
}
