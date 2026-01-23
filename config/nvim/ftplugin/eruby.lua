local opts = { buffer = true, silent = true }

vim.keymap.set("i", "<leader>=", "<%=  %><Esc>2hi", opts)
vim.keymap.set("i", "<leader>%", "<%  %><Esc>2hi", opts)
