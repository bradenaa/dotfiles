-- See `:help option-list`

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Icons in the statusline, which-key, Telescope and diagnostic signs. Ghostty
-- bundles the Nerd Font symbols; other terminals need a Nerd Font selected.
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false -- shown in the statusline instead

-- Sync with the OS clipboard. Scheduled because it can slow down startup.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true
vim.o.undofile = true

-- Case-insensitive search unless \C or a capital letter is used.
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split' -- live preview of :substitute
vim.o.cursorline = true
vim.o.scrolloff = 10

-- Ask to save instead of failing on :q with unsaved changes.
vim.o.confirm = true

-- Default border for all floating windows (hover, diagnostics, etc.).
vim.o.winborder = 'rounded'
