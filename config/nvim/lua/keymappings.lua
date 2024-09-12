local utils = require("utils")

local map = utils.map

-- Tab Shortcuts.
map("n", "tf", ":tabfirst<CR>")
map("n", "tn", ":tabnext<CR>")
map("n", "tp", ":tabprev<CR>")
map("n", "tl", ":tablast<CR>")
map("n", "tt", ":tabnew<CR>")
map("n", "tx", ":tabclose<CR>")

-- Move current split to new tab.
map("n", "tc", ":tab split<CR>")

-- Manage Vim config more easily.
map("n", "<leader>ve", ":vsplit $MYVIMRC<cr>")

-- Easy splits.
map("n", "vv", "<C-w>v")
map("n", "ss", "<C-w>s")
map("n", "<M-w>", "<C-w>w")
map("n", "<M-p>", "<C-w>p")

-- Easy save or close files.
map("n", "<leader>w", ":w<cr>")
map("n", "<leader>q", ":q<cr>")

-- Easy path files.
vim.cmd("com! RelativePath let @+=expand('%:f')")

-- Easy format json.
vim.cmd("com! FormatJSON :%!jq '.'")
vim.cmd("com! MinifyJSON :%!jq -c")

-- Easy ctags.
vim.cmd("com! Ctags :!ctags -R -u .")
