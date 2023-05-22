-- Retrieve Plugins
require('plugins')

-- Common helper functions
utils = require('utils')

-- Append Runtime Paths
vim.opt.runtimepath:append('~/.config/nvim/ts_parsers')
vim.opt.runtimepath:append('~/.config/nvim/plugged')

-- Magit Setup
require("neogit").setup{}

-- Treesitter Setup
require 'nvim-treesitter.configs'.setup{
    indent = {
        enable = true,
    },
    parser_install_dir = '~/.config/nvim/ts_parsers',
}

-- Lualine Setup
require('lualine').setup{}

-- Autocompletion Settings
vim.o.completeopt='menu,menuone,noselect'

local cmp = require('cmp')
cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
          require('snippy').expand_snippet(args.body) -- For `snippy` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
})

-- LSP Setup
require('lspconfig').rust_analyzer.setup{}
require('lspconfig').clangd.setup{}
require('lspconfig').gopls.setup{}

-- Set up lspconfig for completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['clangd'].setup {
    capabilities = capabilities
}
require('lspconfig')['rust_analyzer'].setup {
    capabilities = capabilities
}
require('lspconfig')['gopls'].setup {
    capabilities = capabilities
}

-- Snippets Settings
require('snippy').setup({
    mappings = {
        is = {
            ['<CR>'] = 'expand_or_advance',
        },
        nx = {
            ['<leader>x'] = 'cut_text',
        },
    },
})

-- Vimpeccable
local vimp = require('vimp')

-- Colorscheme Setup
vim.o.termguicolors = true
vim.cmd('colorscheme nord')

-- Basic Editor Options
vim.o.tabstop = 4     
vim.o.softtabstop = 4
vim.o.shiftwidth = 4  
vim.o.expandtab = true
vim.o.number = true

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldenable = false

-- Keymaps
vim.g.mapleader = " "

-- Unbind Arrow Keys
vimp.inoremap('<right>', '<nop>')
vimp.inoremap('<left>', '<nop>')
vimp.inoremap('<down>', '<nop>')
vimp.inoremap('<up>', '<nop>')

-- Quick Escape
vimp.inoremap('jk', '<esc>')

-- Tabbing
vimp.nnoremap('<tab>', '>>')
vimp.nnoremap('<backspace>', '<<')
vimp.vnoremap('<tab>', '>>')
vimp.vnoremap('<backspace>', '<<')

-- Beginning and End of Line
vimp.noremap('H', '0')
vimp.noremap('L', '$')

-- func: Go into file explorer
vimp.nnoremap('<leader>e',
    function ()
        vim.cmd('Ex')
    end
)

-- func: vsplit and open file open dialog
vimp.nnoremap('\\',
    function()
        vim.cmd('vsplit')
        vim.cmd('wincmd l')
        vim.cmd('Telescope find_files')
    end
)

-- func: create new tab and open file open dialogue
vimp.nnoremap('<leader>o',
    function()
        vim.cmd('tabnew')
        vim.cmd('Telescope find_files')
    end
)

-- func: run code in output buffer then delete when done
vim.cmd("au BufLeave output.scratch bd")
vimp.nnoremap('<leader>r',
    function()
        fn = vim.fn.expand("%")
        ft = vim.bo.filetype
        

        vim.cmd("vsplit output.scratch")
        vim.cmd("buffer output.scratch")

        vim.bo.buftype = "nofile"
        vim.bo.bufhidden = "hide"
        vim.cmd("setlocal noswapfile")

        if ft == "c" then
            vim.cmd("r !make")
            vim.cmd("r !./bin/application")

        elseif ft == "cpp" then
            vim.cmd("r !make")
            vim.cmd("r !./bin/application")

        elseif ft == "rust" then
            vim.cmd("r !cargo run")
        elseif ft == "go" then
            vim.cmd(string.format("r !go run %s", fn))
        end

        vim.bo.ro = true
    end
)

-- func: open config file
vimp.nnoremap('<leader>ss', 
    function ()
        vim.cmd("vsplit ~/.config/nvim/init.lua")
    end
)

-- func: create scratch buffer
vimp.nnoremap('<leader>sb', 
    function()
        utils.create_scratch_buffer_tab()
    end
)

-- Switching Windows
vimp.nnoremap('<leader>l', '<C-w>l')
vimp.nnoremap('<leader>h', '<C-w>h')
vimp.nnoremap('<leader>k', '<C-w>k')
vimp.nnoremap('<leader>j', '<C-w>j')

-- Telescope Keys
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, {})
vim.keymap.set('n', '<leader>fs', builtin.treesitter, {})
