return {
  'norcalli/nvim-colorizer.lua',
  cmd = { 'ColorizerToggle' },
  ft = {
    'html',
    'css',
    'sass',
    'vim',
    'typescript',
    'typescriptreact',
    'javascript',
    'javascriptreact',
    'lua',
    'vue',
    'eruby',
    'elixir',
    'go'
  },
  event = 'BufEnter',
  opts = { '*' },
  lazy = true
}
