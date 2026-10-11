-- Renders markdown in the buffer (headings, code blocks, tables, callouts).
-- Also renders LSP hover docs. Uses mini.icons and the treesitter parsers.
vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
  overrides = {
    buftype = {
      -- LSP hover floats are read, not edited: keep the markup hidden on the
      -- cursor line too, so moving through them (K K) doesn't show ``` and **.
      nofile = {
        anti_conceal = { enabled = false },
        win_options = { concealcursor = { rendered = 'nc' } },
      },
    },
  },
}
