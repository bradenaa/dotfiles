vim.pack.add {
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-rhubarb', -- GitHub support for :GBrowse
  'https://github.com/lewis6991/gitsigns.nvim',
}

-- :GBrowse prefers a :Browse command; without one it falls back to calling
-- netrw#BrowseX with two arguments, which nvim 0.12's netrw rejects (E118).
vim.api.nvim_create_user_command('Browse', function(opts)
  vim.ui.open(opts.args)
end, { nargs = 1, desc = 'Open a URL in the browser' })

-- [[ fugitive ]]
-- In the status window: - stage/unstage, = inline diff, cc commit, ca amend,
-- dv vertical diff, X discard, czz/czp stash/pop, g? help.
local gmap = function(keys, cmd, desc, mode)
  vim.keymap.set(mode or 'n', keys, cmd, { desc = desc })
end

gmap('<leader>gs', '<cmd>Git<CR>', 'Git [s]tatus')
gmap('<leader>gc', '<cmd>Git commit<CR>', 'Git [c]ommit')
gmap('<leader>gp', '<cmd>Git push<CR>', 'Git [p]ush')
gmap('<leader>gP', '<cmd>Git pull<CR>', 'Git [P]ull')
gmap('<leader>gw', '<cmd>Gwrite<CR>', 'Git stage file ([w]rite)')
gmap('<leader>gr', '<cmd>Gread<CR>', 'Git [r]evert file (read)')

-- History
gmap('<leader>gb', '<cmd>Git blame<CR>', 'Git [b]lame (file)')
gmap('<leader>gd', '<cmd>Gdiffsplit<CR>', 'Git [d]iff split')
gmap('<leader>gl', '<cmd>Git log --oneline<CR>', 'Git [l]og')
-- Each commit that touched this file goes into quickfix; step with ]q / [q.
gmap('<leader>gh', '<cmd>0Gclog<CR>', 'Git file [h]istory')
gmap('<leader>gB', function()
  require('telescope.builtin').git_branches()
end, 'Git [B]ranches')
gmap('<leader>go', ':GBrowse<CR>', 'Git [o]pen on GitHub', { 'n', 'x' })

-- Merge conflicts: open the 3-way view, then in the middle pane take the
-- left (//2, ours) or right (//3, theirs) side of the hunk under the cursor.
gmap('<leader>gm', '<cmd>Gvdiffsplit!<CR>', 'Git [m]erge conflict view')
gmap('<leader>gf', '<cmd>diffget //2<CR>', 'Git take ours (le[f]t)')
gmap('<leader>gj', '<cmd>diffget //3<CR>', 'Git take theirs (right)')

-- [[ gitsigns ]]

require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation (falls back to the built-in ]c/[c in diff mode)
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Actions
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [s]tage hunk' })
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [r]eset hunk' })
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
    -- stage_hunk toggles, so running it on a staged hunk unstages it.
    map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
    map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    map('n', '<leader>hD', function()
      gitsigns.diffthis '@'
    end, { desc = 'git [D]iff against last commit' })

    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
    map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
  end,
}
