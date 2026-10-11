-- General editing and UI plugins.

vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/NMAC427/guess-indent.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/alexghergh/nvim-tmux-navigation',
}

require('guess-indent').setup {}

-- Highlight TODO, NOTE, etc. in comments.
require('todo-comments').setup { signs = false }

-- [[ mini.nvim ]]

-- Around/inside textobjects, e.g. va) yinq ci'
require('mini.ai').setup { n_lines = 500 }

-- Surroundings, e.g. saiw) sd' sr)'
require('mini.surround').setup()

-- File/filetype icons. Also stands in for nvim-web-devicons, which Telescope
-- looks for.
if vim.g.have_nerd_font then
  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()
end

local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end

-- [[ tmux navigation ]]

local tmux_nav = require 'nvim-tmux-navigation'
tmux_nav.setup { disable_when_zoomed = true }

vim.keymap.set('n', '<C-h>', tmux_nav.NvimTmuxNavigateLeft)
vim.keymap.set('n', '<C-j>', tmux_nav.NvimTmuxNavigateDown)
vim.keymap.set('n', '<C-k>', tmux_nav.NvimTmuxNavigateUp)
vim.keymap.set('n', '<C-l>', tmux_nav.NvimTmuxNavigateRight)
vim.keymap.set('n', '<C-\\>', tmux_nav.NvimTmuxNavigateLastActive)
-- <C-Space> is the tmux prefix, so NvimTmuxNavigateNext is left unmapped.

-- [[ which-key ]]

require('which-key').setup {
  delay = 0,
  -- Key names use Nerd Font glyphs by default; set icons.keys if that's off.
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>g', group = '[G]it' },
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  },
}
