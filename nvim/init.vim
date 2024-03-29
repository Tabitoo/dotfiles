set number
syntax on
set smartcase
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set ignorecase
set scrolloff=7
let mapleader = " "




"Plugins"
call plug#begin('~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'williamboman/nvim-lsp-installer'
Plug 'tribela/vim-transparent'
Plug 'williamboman/mason.nvim'
Plug 'preservim/nerdtree'

" TELESCOPE " 
Plug 'nvim-lua/plenary.nvim' 
Plug 'nvim-telescope/telescope.nvim', {'tag' : '0.1.0'}

" TREESITE"

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


" For luasnip users."
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'



"THEMES" 
Plug 'dracula/vim'

call plug#end()

if (has("termguicolors"))
 set termguicolors
endif
syntax enable
colorscheme dracula

" telescope configurations "
"nnoremap <leader>ff <cmd>Telescope find_files<cr>"

nnoremap <leader>fb <cmd> Telescope buffers<cr>
nnoremap <leader>fh <cmd> Telescope help_tags<cr>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>



"NERDTREE NNOREMAPS"
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-m> :NERDTreeToggle<CR>

lua <<EOF
	

	-- Setup nvim-cmp.
	local cmp = require'cmp'
    


	cmp.setup({
		snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
		},
		window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		}),
		sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }, -- For vsnip users.
		{ name = 'luasnip' } -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
		}, {
		{ name = 'buffer' },
		})
	})

	-- Set configuration for specific filetype.
	cmp.setup.filetype('gitcommit', {
		sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
		}, {
		{ name = 'buffer' },
		})
	})

	-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline('/', {
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

	require("nvim-lsp-installer").setup {}  

	-- Setup lspconfig.
	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
	require('lspconfig')["pyright"].setup {
		capabilities = capabilities,
		on_attach = function()
		   vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
		   vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
		end,
	}

	require('lspconfig')["tsserver"].setup {
		capabilities = capabilities,
		-- Run the function when a buffer is attac, this is worth for many configurations
		on_attach = function() 
		   vim.keymap.set("n","K", vim.lsp.buf.hover, {buffer=0})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
			vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
			vim.keymap.set("n", " dl", "<cmd>Telescope diagnostics<cr>", {buffer=0})
		end,
	}

    require('lspconfig')["intelephense"].setup {
		capabilities = capabilities,
		-- Run the function when a buffer is attac, this is worth for many configurations
		on_attach = function() 
		   vim.keymap.set("n","K", vim.lsp.buf.hover, {buffer=0})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
			vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
			vim.keymap.set("n", " dl", "<cmd>Telescope diagnostics<cr>", {buffer=0})
		end,
	}

   require('lspconfig')["html"].setup {
		capabilities = capabilities,
		-- Run the function when a buffer is attac, this is worth for many configurations
		on_attach = function() 
		   vim.keymap.set("n","K", vim.lsp.buf.hover, {buffer=0})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
			vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
			--vim.keymap.set("n", " dl", "<cmd>Telescope diagnostics<cr>", {buffer=0})
		end,
	}
	
	require('lspconfig')["cssls"].setup {
		capabilities = capabilities,
		-- Run the function when a buffer is attac, this is worth for many configurations
		on_attach = function() 
		   vim.keymap.set("n","K", vim.lsp.buf.hover, {buffer=0})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
			vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
			--vim.keymap.set("n", " dl", "<cmd>Telescope diagnostics<cr>", {buffer=0})
		end,
	}

	require('lspconfig')["tailwindcss"].setup {
		capabilities = capabilities,
		-- Run the function when a buffer is attac, this is worth for many configurations
		on_attach = function() 
		   vim.keymap.set("n","K", vim.lsp.buf.hover, {buffer=0})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
			vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
			--vim.keymap.set("n", " dl", "<cmd>Telescope diagnostics<cr>", {buffer=0})
		end,
	}

	
   
	require("mason").setup()

	


EOF
