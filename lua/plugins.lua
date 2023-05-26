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
        use 'wbthomason/packer.nvim'
        
        use 'arcticicestudio/nord-vim'

        use 'nvim-lualine/lualine.nvim'

        use 'svermeulen/vimpeccable'

        use 'neovim/nvim-lspconfig'

        use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}

        use {'nvim-tree/nvim-tree.lua'}

        use 'windwp/nvim-autopairs'

        use 'nvim-lua/plenary.nvim'

        use {'nvim-telescope/telescope.nvim', {tag = '0.1.1'}}

        use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
        
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'
        use 'hrsh7th/nvim-cmp'

        use 'dcampos/nvim-snippy'
        use 'dcampos/cmp-snippy'

        use 'folke/trouble.nvim'

        use {'ggandor/leap.nvim', requires = 'tpope/vim-repeat'}
        
        if packer_bootstrap then 
            require('packer').sync()
        end
    end
)
