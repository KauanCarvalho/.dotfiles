return {
  "github/copilot.vim",
  config = function()
    vim.api.nvim_set_keymap("i", "<C-h>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    vim.g.copilot_no_tab_map = true

    vim.g.copilot_filetypes = {
      ["elixir"] = true,
      ["go"] = true,
      ["javascript"] = true,
      ["markdown"] = false,
      ["ruby"] = true,
      ["yaml"] = true,
      [""] = true,
    }
  end,
}
