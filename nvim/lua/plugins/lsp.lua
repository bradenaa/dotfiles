-- Language servers are installed by Nix (see home/common.nix), not from nvim.
--
-- nvim-lspconfig only supplies default server configs (its lsp/*.lua files).
-- Our own overrides live in ../../lsp/<name>.lua and are merged on top.
-- blink.cmp adds its completion capabilities via vim.lsp.config('*').
vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/j-hui/fidget.nvim',
}

require('fidget').setup {}

vim.lsp.enable {
  'clangd',
  'emmet_language_server',
  'gopls',
  'html',
  'lua_ls',
  'marksman',
  'pyright',
  'rust_analyzer',
  'terraformls',
  'ts_ls',
}

vim.diagnostic.config {
  severity_sort = true,
  float = { source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = { source = 'if_many', spacing = 2 },
}

-- Built-in defaults already cover grn (rename), gra (code action),
-- grx (codelens) and <C-s> (signature help). See `:help lsp-defaults`.
-- The maps below swap the quickfix-based defaults for Telescope pickers.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local builtin = require 'telescope.builtin'
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grr', builtin.lsp_references, '[G]oto [R]eferences')
    map('gri', builtin.lsp_implementations, '[G]oto [I]mplementation')
    map('grd', builtin.lsp_definitions, '[G]oto [D]efinition')
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('grt', builtin.lsp_type_definitions, '[G]oto [T]ype Definition')
    map('gO', builtin.lsp_document_symbols, 'Open Document Symbols')
    map('gW', builtin.lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    -- Highlight references to the symbol under the cursor after a pause.
    if client:supports_method('textDocument/documentHighlight', event.buf) then
      local group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = group,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        buffer = event.buf,
        group = group,
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = group, buffer = event2.buf }
        end,
      })
    end

    if client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})
