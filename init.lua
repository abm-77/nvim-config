-- Retrieve Plugins
require('plugins')

-- Common helper functions
local utils = require('utils')

-- Append Runtime Paths
vim.opt.runtimepath:append('~/.config/nvim/ts_parsers')
vim.opt.runtimepath:append('~/.config/nvim/plugged')

-- Magit Setup
require("neogit").setup{}

-- Treesitter Setup
require 'nvim-treesitter.configs'.setup{
  ensure_installed = { "c", "lua", "cpp", "rust", "glsl", "odin", "zig", "go"},
  sync_install = false,
  indent = {
    enable = false 
  },
  parser_install_dir = '~/.config/nvim/ts_parsers',
}

-- Oil Setup
local oil = require('oil')
oil.setup{}

-- Comment Setup
require('Comment').setup{}

-- Formatter Setup
require('formatter').setup {
    filetype = {
        c = { require("formatter.filetypes.c").clangformat },
        cpp = { require("formatter.filetypes.cpp").clangformat },
        rust = { require("formatter.filetypes.rust").rustfmt },
        go = { require("formatter.filetypes.go").gofmt },
        zig = { require("formatter.filetypes.zig").zigfmt },
    }
}

-- BarBar Setup
require('barbar').setup {}

-- Lualine Setup
require('lualine').setup{
    options = {
        icons_enabled = true,
        theme = 'nord',
    },
    sections = {
        lualine_a = {
            {
                'filename',
                path = 1,
            }
        }
    }
}

-- NvimTree Setup
require('nvim-tree').setup{}

-- Trouble Setup
require('trouble').setup{
    icons = true,
    indent_lines = false,
    signs = {
        error = "error",
        warning = "warning",
        hint = "hint",
        information = "info"
    },
    use_diagnostic_signs = false
}

-- Autocompletion Settings
vim.o.completeopt='menu,menuone,noselect'

-- AutoPairs
require('nvim-autopairs').setup{}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
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
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
              cmp.select_next_item()
          else
              fallback()
          end
      end),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
})

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

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
local lspconfig = require('lspconfig')
lspconfig.rust_analyzer.setup{}
lspconfig.clangd.setup{}

vim.filetype.add({
  pattern = {
    ['*.vert'] = 'glsl',
    ['*.frag'] = 'glsl',
  }
})
lspconfig.glslls.setup{
  filetypes = { "glsl", "vert", "frag"},
}
lspconfig.gopls.setup{}
lspconfig.lua_ls.setup{}
lspconfig.ols.setup{}
lspconfig.zls.setup{}

-- Set up lspconfig for completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
lspconfig['clangd'].setup {
    capabilities = capabilities
}
lspconfig['rust_analyzer'].setup {
    capabilities = capabilities
}
lspconfig['gopls'].setup {
    capabilities = capabilities
}
lspconfig['lua_ls'].setup {
    capabilities = capabilities
}
lspconfig['zls'].setup {
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
require('rose-pine').setup({
    variant = "auto", -- auto, main, moon, or dawn
    dark_variant = "main", -- main, moon, or dawn
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    styles = {
        bold = true,
        italic = true,
        transparency = false,
    },

    groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        headings = {
            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
        },
        -- Alternatively, set all headings at once.
        -- headings = "subtle",
    },

    highlight_groups = {
        -- Comment = { fg = "foam" },
        -- VertSplit = { fg = "muted", bg = "muted" },
    },

    before_highlight = function(group, highlight, palette)
        -- Disable all undercurls
        -- if highlight.undercurl then
        --     highlight.undercurl = false
        -- end
        --
        -- Change palette colour
        -- if highlight.fg == palette.pine then
        --     highlight.fg = palette.foam
        -- end
    end,
})

vim.o.termguicolors = true
vim.cmd('colorscheme rose-pine')

-- Basic Editor Options
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop =2
vim.o.shiftwidth = 2
vim.o.shiftround = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg ='white', bold=true })
vim.o.autoindent = true
vim.o.cindent = true

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldenable = false
vim.o.filetype = true

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
--vimp.nnoremap('<tab>', '>>')
vimp.nnoremap('<backspace>', '<<')
--vimp.vnoremap('<tab>', '>>')
vimp.vnoremap('<backspace>', '<<')

-- Beginning and End of Line
vimp.noremap('H', '0')
vimp.noremap('L', '$')

-- func: Save file
vimp.nnoremap('<leader>w', ':w<cr>')

-- func: Go into file explorer
vimp.nnoremap('<leader>e',
    function ()
        oil.toggle_float()
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

-- func: open config file
vimp.nnoremap('<leader>ss',
    function ()
        vim.cmd("vsplit ~/.config/nvim/init.lua")
    end
)

vim.diagnostic.config({
  virtual_text = false
})

vim.o.updatetime = 250
vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

-- Bracket/Parentheses Indentation
vimp.inoremap('{<CR>', '{<CR>}<C-o>O')
vimp.inoremap('(<CR>', '(<CR>)<C-o>O')


-- Tab Controls
vimp.noremap('<leader>,', '<Cmd>BufferPrevious<CR>')
vimp.noremap('<leader>.', '<Cmd>BufferNext<CR>')
vimp.noremap('<leader>>', '<Cmd>BufferMovePrevious<CR>')
vimp.noremap('<leader><', '<Cmd>BufferMoveNext<CR>')
vimp.noremap('<leader>1', '<Cmd>BufferGoto 1<CR>')
vimp.noremap('<leader>2', '<Cmd>BufferGoto 2<CR>')
vimp.noremap('<leader>3', '<Cmd>BufferGoto 3<CR>')
vimp.noremap('<leader>4', '<Cmd>BufferGoto 4<CR>')
vimp.noremap('<leader>5', '<Cmd>BufferGoto 5<CR>')
vimp.noremap('<leader>6', '<Cmd>BufferGoto 6<CR>')
vimp.noremap('<leader>7', '<Cmd>BufferGoto 7<CR>')
vimp.noremap('<leader>8', '<Cmd>BufferGoto 8<CR>')
vimp.noremap('<leader>9', '<Cmd>BufferGoto 9<CR>')
vimp.noremap('<leader>0', '<Cmd>BufferLast<CR>')
vimp.noremap('<leader>cc','<Cmd>BufferClose<CR>')

-- Windows Controls
vimp.nnoremap('<leader>l', '<C-w>l')
vimp.nnoremap('<leader>h', '<C-w>h')
vimp.nnoremap('<leader>k', '<C-w>k')
vimp.nnoremap('<leader>j', '<C-w>j')

-- Augroup: On Save
local augroup_onsave = vim.api.nvim_create_augroup('augroup_onsave', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWritePost'}, {
    pattern = '*',
    group = augroup_onsave,
    command = 'Format',
})

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

-- NvimTree Keys
vim.keymap.set('n', '<leader>t', '<cmd>NvimTreeToggle<cr>', { silent = true, noremap = true } )

-- Trouble Keys
vim.keymap.set('n', '<leader>xx', '<cmd>TroubleToggle<cr>', { silent = true, noremap = true } )

-- Misc Keys
vim.keymap.set('n', '<leader>c', ':nohlsearch<cr>')

