local set = vim.opt

-- General.
set.termguicolors  = true
set.number         = true
set.numberwidth    = 4
set.relativenumber = false
set.backspace      = "indent,eol,start"
set.history        = 1000
set.showcmd        = true
set.showmode       = true
set.gcr            = "a:blinkon0"
set.visualbell     = true
set.autoread       = true
set.mouse:append("a")
set.colorcolumn    = "81"
set.hidden         = true
set.lazyredraw     = true
set.splitbelow     = true
set.splitright     = true
set.diffopt:append("vertical")

-- Syntax highlighting.
vim.cmd("syntax off")

-- Swap and backup files.
set.swapfile       = false
set.backup         = false
set.writebackup    = false

-- Undo.
set.undodir        = vim.fn.expand("~/.config/nvim/backups")
set.undofile       = true

-- Indentation.
set.autoindent     = true
set.smarttab       = true
set.expandtab      = true
set.shiftwidth     = 2

vim.cmd("filetype plugin indent on")

-- Display tabs and trailing spaces visually.
set.wrap           = false
set.linebreak      = true
set.list           = true
set.listchars:append({
  tab = ">~",
  trail = "."
})

-- Folds.
set.foldmethod     = "indent"
set.foldnestmax    = 3
set.foldcolumn     = "0"
set.foldlevel      = 99
set.foldlevelstart = 99
set.foldenable     = true

-- Completion.
set.wildmode       = "list:longest"
set.wildmenu       = true
set.wildignore = {
  "*.o",
  "*.obj",
  "*~",
  "*.config/nvim/backups*",
  "*sass-cache*",
  "*DS_Store*",
  "node_modules/**",
  "vendor/rails/**",
  "vendor/cache/**",
  "*.gem",
  "log/**",
  "tmp/**",
  "*.png",
  "*.jpg",
  "*.gif"
}

-- Scrolling.
set.scrolloff      = 999
set.sidescrolloff  = 15
set.sidescroll     = 1

-- Cursor Position.
set.cursorline     = true
set.cursorcolumn   = false

-- Search.
set.incsearch      = true
set.hlsearch       = true
set.ignorecase     = true
set.smartcase      = true
set.inccommand     = "split"

-- Disables netrw.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader key.
vim.g.mapleader    = " "

-- Plugin Manager for Neovim.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  change_detection = {
    notify = false
  }
})

require("keymappings")

-- Nvim tree autoload.
local function open_nvim_tree(event)
  local directory = vim.fn.isdirectory(vim.api.nvim_buf_get_name(0)) == 1

  if not directory then
    return
  end

  vim.schedule(function()
    vim.cmd("NvimTreeFindFileToggle")
  end)
end

vim.api.nvim_create_autocmd("User", { pattern = "NvimTreeLoaded", callback = open_nvim_tree })
