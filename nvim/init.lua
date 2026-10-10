-- Byte-compile and cache Lua modules for faster startup.
vim.loader.enable()

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'

-- Build hooks must be registered before any vim.pack.add() call.
require 'config.pack'

-- Plugins. Order matters: each file calls vim.pack.add() and then configures
-- the plugin immediately, so dependencies must come first.
require 'plugins.colorscheme'
require 'plugins.editor'
require 'plugins.git'
require 'plugins.telescope'
require 'plugins.treesitter'
require 'plugins.completion'
require 'plugins.lsp'
require 'plugins.format'
