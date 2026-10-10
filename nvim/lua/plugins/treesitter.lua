-- nvim-treesitter `main` branch: it only installs parsers and queries.
-- Highlighting and indentation are enabled per buffer in the FileType
-- autocmd below. Parser compilation needs the `tree-sitter` CLI (from Nix).
vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
}

local ts = require 'nvim-treesitter'

-- Installed in the background; a no-op for parsers already present.
ts.install {
  'bash',
  'c',
  'diff',
  'go',
  'gomod',
  'gosum',
  'gowork',
  'hcl',
  'html',
  'javascript',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'rust',
  'terraform',
  'typescript',
  'vim',
  'vimdoc',
}

local function start(buf, lang)
  if not pcall(vim.treesitter.start, buf, lang) then
    return false
  end
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  return true
end

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Start treesitter, installing the parser first if needed',
  group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang or start(ev.buf, lang) then
      return
    end
    if vim.list_contains(ts.get_available(), lang) then
      ts.install(lang):await(function(err)
        vim.schedule(function()
          if not err and vim.api.nvim_buf_is_valid(ev.buf) then
            start(ev.buf, lang)
          end
        end)
      end)
    end
  end,
})
