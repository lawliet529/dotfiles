-- Set line numbers
vim.opt.number = true
-- Set linebreak
vim.opt.linebreak = true
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
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

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
