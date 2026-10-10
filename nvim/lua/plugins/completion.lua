vim.pack.add {
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' },
  'https://github.com/folke/lazydev.nvim',
}

-- Lua LSP completions/types for the Neovim runtime and installed plugins.
require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

---@module 'blink.cmp'
---@type blink.cmp.Config
require('blink.cmp').setup {
  -- 'default': <C-y> accept, <C-space> menu/docs, <C-n>/<C-p> select,
  -- <C-e> hide, <C-k> signature help, <Tab>/<S-Tab> snippet jumps.
  -- See `:help blink-cmp-config-keymap`.
  keymap = { preset = 'default' },

  appearance = { nerd_font_variant = 'mono' },

  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev' },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },

  -- Snippets use Neovim's built-in vim.snippet engine (snippets.preset = 'default').

  -- Lua matcher avoids downloading blink's prebuilt Rust binary.
  fuzzy = { implementation = 'lua' },

  signature = { enabled = true },
}
