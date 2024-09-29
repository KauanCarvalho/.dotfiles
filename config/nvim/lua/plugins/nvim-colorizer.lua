return {
  "norcalli/nvim-colorizer.lua",
  cmd = { "ColorizerToggle" },
  ft = {
    "html",
    "css",
    "sass",
    "vim",
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
    "lua",
    "vue",
    "eruby",
    "elixir",
  },
  event = "BufEnter",
  opts = { "*" },
  lazy = true
}
