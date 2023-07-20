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

vim.opt.termguicolors = true

if require('plugins') then return end

-- Set colorscheme
require('onedark').load()

-- Set statusline
require('lualine').setup()
vim.opt.showmode = false -- Hide mode

-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup()

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
