-- Set line numbers
vim.opt.number = true
-- Set linebreak
vim.opt.linebreak = true
-- Set nowrap
vim.opt.wrap = false
-- Highlight current line
vim.opt.cursorline = true
-- Use spaces instead of tabs
vim.opt.expandtab = true
-- Set tab width to 2 spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

if require('plugins') then return end

-- Set colorscheme
vim.opt.termguicolors = true
vim.g.nord_cursor_line_number_background = 1
vim.g.nord_uniform_diff_background = 1
vim.cmd('colorscheme nord')

-- Set statusline
require('lualine').setup()
vim.opt.showmode = false -- Hide mode

-- nvim-treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "vim" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- vimtex
vim.g.vimtex_view_method = 'zathura'

-- gitsigns
require('gitsigns').setup()
