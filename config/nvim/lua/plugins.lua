local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    print('Cloning packer.nvim...')
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  -- Manage packer itself
  use 'wbthomason/packer.nvim'

  -- Nord theme
  use 'arcticicestudio/nord-vim'

  -- Github Copilot
  use 'github/copilot.vim'

  -- nvim-tree & nvim-web-devicons
  use 'nvim-tree/nvim-web-devicons'

  -- lualine: statusline
  use 'nvim-lualine/lualine.nvim'

  -- treesitter: syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }

  -- gitsigns.nvim: git decorations
  use 'lewis6991/gitsigns.nvim'

  -- diffview.nvim
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

  -- markdown-preview
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

return packer_bootstrap
