local packer = require"packer"
packer.init {display = {open_fn = function() return require("packer.util").float {border = "rounded"} end}}

packer.startup(function(use)
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'

  use 'EdenEast/nightfox.nvim'
  use {'nvim-lualine/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}}
  use {'akinsho/bufferline.nvim', tag = 'v2.*', requires = 'kyazdani42/nvim-web-devicons'}

  use 'bronson/vim-visual-star-search'

  use {'neovim/nvim-lspconfig'}
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      {'hrsh7th/cmp-nvim-lsp'}, {'hrsh7th/cmp-buffer'}, {'hrsh7th/cmp-path'}, {'hrsh7th/cmp-cmdline'},
      {'hrsh7th/cmp-vsnip'}, {'hrsh7th/vim-vsnip'}
    }
  }

  use {'nvim-treesitter/nvim-treesitter', run = function() require('nvim-treesitter.install').update({ with_sync = true }) end}

  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/plenary.nvim'}, {'kyazdani42/nvim-web-devicons'}}}

  use {'mhartington/formatter.nvim'}
  use {'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons'}
end)

-- nightfox
vim.cmd("colorscheme nightfox")
require"nightfox".setup({
  options = {
    transparent = true,    -- Disable setting background
    terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
  }
})

-- lualine
require"lualine".setup {options = {theme = 'nightfox'}, extensions = {'nvim-tree'}}

-- bufferline
require"bufferline".setup {
  options = {offsets = {{filetype = "NvimTree", text = "", text_align = "left"}}}
}
vim.cmd("cnoreabbrev <silent> bn :BufferLineCycleNext<cr>")
vim.cmd("cnoreabbrev <silent> bp :BufferLineCyclePrev<cr>")
vim.api.nvim_set_keymap('n', ']b', ":BufferLineCycleNext<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[b', ":BufferLineCyclePrev<cr>", {noremap = true, silent = true})

-- nvim-cmp
local cmp = require"cmp"
cmp.setup({
  snippet = {expand = function(args) vim.fn['vsnip#anonymous'](args.body) end},
  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
    ['<C-j>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
    ['<C-h>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
    ['<C-e>'] = cmp.mapping({i = cmp.mapping.abort(), c = cmp.mapping.close()}),
    ['<C-y>'] = cmp.mapping.confirm({select = true})
  }),
  sources = cmp.config.sources({{name = 'nvim_lsp'}, {name = 'vsnip'}, {name = 'buffer'}, {name = 'path'}})
})
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {{name = 'buffer'}}
})
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
})
vim.api.nvim_set_keymap('c', '<C-y>', '', {callback = function() cmp.confirm({ select = true }) end})

-- lspconfig
vim.cmd [[
  sign define DiagnosticSignError text= texthl=DiagnosticError
  sign define DiagnosticSignWarn text= texthl=DiagnosticWarn
  sign define DiagnosticSignInfo text= texthl=DiagnosticInfo
  sign define DiagnosticSignHint text= texthl=DiagnosticHint
]]
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = {noremap = true, silent = true}
  buf_set_keymap('n', 'gD', "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
  buf_set_keymap('n', 'gd', "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", opts)
  buf_set_keymap('n', 'gi', "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", opts)
  buf_set_keymap('n', 'gt', "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
  buf_set_keymap('n', 'K', "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
  buf_set_keymap('n', '<C-k>', "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
  buf_set_keymap('i', '<C-k>', "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
  buf_set_keymap('n', 'gr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", opts)
  buf_set_keymap('n', '<space>rn', "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  buf_set_keymap('n', '<space>ca', "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  buf_set_keymap('n', '[e', "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
  buf_set_keymap('n', ']e', "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
  buf_set_keymap('n', '<space>e', "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
  buf_set_keymap('n', '<space>ea', "<cmd>lua require('telescope.builtin').diagnostics({bufnr = 0})<cr>", opts)
  buf_set_keymap('n', '<space>ee', "<cmd>lua require('telescope.builtin').diagnostics()<cr> ", opts)
end
local servers = {'pylsp', 'gopls'}
for _, lsp in ipairs(servers) do
  local capabilities = require"cmp_nvim_lsp".update_capabilities(vim.lsp.protocol.make_client_capabilities())
  require"lspconfig"[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {debounce_text_changes = 150},
    root_dir = vim.loop.cwd,
    single_file_support = true
  }
end

-- telescope
local telescope = require"telescope"
telescope.setup {
  defaults = {
    layout_strategy = "vertical",
    layout_config = {
      horizontal = {
        preview_width = 0.5
      }
    }
  },
  extensions = {
    fzf = {fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case"}
  }
}
telescope.load_extension('fzf')
vim.api.nvim_set_keymap('n', '<C-p>', "<cmd>lua require('telescope.builtin').find_files()<cr>", {noremap = true})
vim.api.nvim_set_keymap('n', '<C-f>', "<cmd>lua require('telescope.builtin').live_grep{debounce = 100}<cr>", {noremap = true})

-- formatter
require"formatter".setup({
  logging = false,
  filetype = {
    python = {
      -- autopep8
      function() return {exe = "autopep8", args = {"--aggressive", "--max-line-length=120", "-"}, stdin = true} end
    },
    go = {
      -- gopls
      function()
        return {
          exe = "gofmt",
          args = {},
          stdin = true,
        }
      end
    }
  }
})
vim.api.nvim_set_keymap('n', '<space>fo', ':Format<cr>', {noremap = true, silent = true})
vim.cmd("cnoreabbrev <silent> fo :Format<cr>")

-- nvim-tree
require"nvim-tree".setup{
  view = {
    relativenumber = true,
    adaptive_size = true,
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      }
    }
  },
  renderer = {
    highlight_opened_files = "all",
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌"
        },
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        }
      }
    }
  }
}
vim.api.nvim_set_keymap('n', '<C-n>', ":NvimTreeToggle<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<space>n', ":NvimTreeFindFile<cr>", {noremap = true, silent = true})

-- treesitter
require"nvim-treesitter.configs".setup{
  ensure_installed = { "go", "lua", "python" }
}

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd("autocmd BufReadPost,FileReadPost * normal zR")
