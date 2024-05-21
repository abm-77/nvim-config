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

return require('packer').startup(
    function(use)
        -- Config
        use 'wbthomason/packer.nvim'
        use 'nvim-lua/plenary.nvim'
        use 'svermeulen/vimpeccable'

        -- Appearance
        use 'arcticicestudio/nord-vim'
        use 'nvim-lualine/lualine.nvim'
        use 'rose-pine/neovim'

        -- IDE Capabilitites
        use 'neovim/nvim-lspconfig'
        use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
        use {'nvim-telescope/telescope.nvim', {tag = '0.1.1'}}
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'
        use 'hrsh7th/nvim-cmp'
        use 'dcampos/nvim-snippy'
        use 'dcampos/cmp-snippy'
        use { 'NeogitOrg/neogit', requires = 'nvim-lua/plenary.nvim' }
        use 'windwp/nvim-autopairs'
        use 'folke/trouble.nvim'
        --use 'romgrk/barbar.nvim'
        use 'mhartington/formatter.nvim'
        use 'numToStr/Comment.nvim'
        use 'ziglang/zig.vim'
        use 'tetralux/odin.vim'

        -- File System
        use 'nvim-tree/nvim-tree.lua'
        use 'nvim-tree/nvim-web-devicons'
        use 'stevearc/oil.nvim'

        if packer_bootstrap then
            require('packer').sync()
        end
    end
)
