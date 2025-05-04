local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
  use 'windwp/nvim-autopairs'
  use 'rust-lang/rust.vim'
  use 'neovim/nvim-lspconfig'
  use 'ray-x/lsp_signature.nvim'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/vim-vsnip'
  use 'zefei/vim-colortuner'
  use 'morhetz/gruvbox'
  use 'nvim-treesitter/nvim-treesitter'
  use 'theHamsta/nvim-semantic-tokens'
  use 'tikhomirov/vim-glsl'
  use 'sainnhe/gruvbox-material'
  use 'ajmwagar/vim-deus'
  use 'lifepillar/vim-gruvbox8'
  use ({
      'j-hui/fidget.nvim',
      config = function()
          require('fidget').setup()
      end
  })

  if packer_bootstrap then
    require('packer').sync()
  end
end)
