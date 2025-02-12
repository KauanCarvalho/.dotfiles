local utils = require("utils")

local map = utils.map

-- Tab Shortcuts.
map("n", "tf", ":tabfirst<CR>")
map("n", "tn", ":tabnext<CR>")
map("n", "tp", ":tabprev<CR>")
map("n", "tl", ":tablast<CR>")
map("n", "tt", ":tabnew<CR>")
map("n", "tx", ":tabclose<CR>")

-- LSP.
map("n", "K", ":lua vim.lsp.buf.hover()<CR>")
map("n", "[d", ":lua vim.diagnostic.goto_prev()<CR>")
map("n", "]d", ":lua vim.diagnostic.goto_next()<CR>")
map("n", "gl", ":lua vim.diagnostic.open_float()<CR>")
map("n", "gs", ":lua vim.lsp.buf.signature_help()<CR>")
map("n", "gr", ":lua vim.lsp.buf.references()<CR>")
map("n", "go", ":lua vim.lsp.buf.type_definition()<CR>")
map("n", "gi", ":lua vim.lsp.buf.implementation()<CR>")
map("n", "gD", ":lua vim.lsp.buf.declaration()<CR>")
map("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
map("n", "<leader>lc", ":lua vim.lsp.buf.code_action()<CR>")
map("n", "<leader>la", ":lua vim.lsp.buf.format({async = true})<CR>")
map("n", "<leader>lr", ":lua vim.lsp.buf.rename()<CR>")

local apply_import = function()
  vim.lsp.buf.code_action(
    {
      filter = function(a)
        return string.find(a.title, "import")
      end,
      apply = true
    }
  )
end

vim.api.nvim_create_user_command("ApplyImport", apply_import, {})

map("n", "<C-Space>", ":ApplyImport<CR>")

-- Move current split to new tab.
map("n", "tc", ":tab split<CR>")

-- Manage Vim config more easily.
map("n", "<leader>ve", ":vsplit $MYVIMRC<cr>")

-- Easy splits.
map("n", "vv", "<C-w>v")
map("n", "ss", "<C-w>s")
map("n", "<leader>-", ":wincmd _<cr>:wincmd |<CR>")
map("n", "<leader>=", ":wincmd =<cr>")
map("n", "<leader><leader>", "<C-^>")

-- Easy save or close files.
map("n", "<leader>w", ":w<cr>")
map("n", "<leader>q", ":q<cr>")

-- Easy path files.
vim.cmd("com! RelativePath let @+=expand('%:f')")
vim.cmd("com! AbsolutePath let @+=expand('%:p')")

-- Easy format json.
vim.cmd("com! FormatJSON :%!jq '.'")
vim.cmd("com! MinifyJSON :%!jq -c")

-- Easy ctags.
vim.cmd("com! Ctags :!ctags -R -u .")

-- Colorizer.
map("n", "<leader>ct", ":ColorizerToggle<CR>")
