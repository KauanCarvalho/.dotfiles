-- Easy format json.
vim.cmd('com! FormatJSON :%!jq \'.\'')
vim.cmd('com! MinifyJSON :%!jq -c \'.\'')

local map = require("utils").map

-- Tab Shortcuts.
map('n', 'tf', ':tabfirst<CR>')
map('n', 'tn', ':tabnext<CR>')
map('n', 'tp', ':tabprev<CR>')
map('n', 'tl', ':tablast<CR>')
map('n', 'tt', ':tabnew<CR>')
map('n', 'tx', ':tabclose<CR>')

-- Easy splits.
map('n', 'vv', '<C-w>v')
map('n', 'ss', '<C-w>s')
map('n', '<leader>-', ':wincmd _<cr>:wincmd |<CR>')
map('n', '<leader>=', ':wincmd =<cr>')
map('n', '<leader><leader>', '<C-^>')

-- Move current split to new tab.
map('n', 'tc', ':tab split<CR>')

-- Manage Vim config more easily.
map('n', '<leader>ve', ':vsplit $MYVIMRC<cr>')

-- Easy save or close files.
map('n', '<leader>w', ':w<cr>')
map('n', '<leader>q', ':q<cr>')

-- Easy path files.
vim.cmd("com! RelativePath let @+=expand('%:f')")
vim.cmd("com! AbsolutePath let @+=expand('%:p')")
