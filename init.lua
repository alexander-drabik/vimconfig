package.path = package.path .. ';/home/alex/.config/nvim/?.lua'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	'marko-cerovac/material.nvim',
	{ "catppuccin/nvim",           name = "catppuccin", priority = 1000 },
	'habamax/vim-godot',
	{ 'neoclide/coc.nvim',         branch = 'release' },
	{ 'evanleck/vim-svelte',       branch = 'main' },
	{ 'akinsho/git-conflict.nvim', version = "*",       config = true },
	'nvim-treesitter/nvim-treesitter',
	'marko-cerovac/material.nvim',
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
	},
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = { -- load the plugin only when using it's keybinding:
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
		},
	},
	'karb94/neoscroll.nvim',
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	'ahmedkhalf/project.nvim',
	{
		"Zeioth/compiler.nvim",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
		dependencies = { "stevearc/overseer.nvim" },
		opts = {},
	},
	{
		"stevearc/overseer.nvim",
		commit = "68a2d344cea4a2e11acfb5690dc8ecd1a1ec0ce0",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
		opts = {
			task_list = {
				direction = "bottom",
				min_height = 25,
				max_height = 25,
				default_detail = 1
			},
		},
	},
	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.vimtex_view_method = 'zathura'
			-- vim.g.vimtex_compiler_latexmk_engines = 'lualatex'
		end
	},
})


-- Smooth scrolling
require('neoscroll').setup({
	mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
		'<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
	hide_cursor = false,      -- Hide cursor while scrolling
	stop_eof = false,         -- Stop at <EOF> when scrolling downwards
	respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
	cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	easing_function = nil,    -- Default easing function
	pre_hook = nil,           -- Function to run before the scrolling animation starts
	post_hook = nil,          -- Function to run after the scrolling animation ends
	performance_mode = false, -- Disable "Performance Mode" on all buffers.
})

-- Project.nvim
require("project_nvim").setup {
	manual_mode = false,
	detection_methods = { "lsp", "pattern" },
	patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
	ignore_lsp = {},
	exclude_dirs = {},
	show_hidden = false,
	silent_chdir = true,
	scope_chdir = 'global',
	datapath = vim.fn.stdpath("data"),
}

require 'logic'

-- Opt settings
Opt {
	number        = true,
	smartindent   = true,
	smarttab      = true,
	tabstop       = 4,
	softtabstop   = 4,
	shiftwidth    = 4,
	mouse         = "a",
	termguicolors = true,
}
vim.opt.number = true

-- Set theme
require("catppuccin").setup({
	flavour = "macchiato", -- latte, frappe, macchiato, mocha
	background = {      -- :h background
		dark = "macchiato",
	},
	transparent_background = false, -- disables setting the background color.
	show_end_of_buffer = false,  -- shows the '~' characters after the end of buffers
	term_colors = false,         -- sets terminal colors (e.g. `g:terminal_color_0`)
	dim_inactive = {
		enabled = false,         -- dims the background color of inactive window
		shade = "dark",
		percentage = 0.15,       -- percentage of the shade to apply to the inactive window
	},
	no_italic = false,           -- Force no italic
	no_bold = false,             -- Force no bold
	no_underline = false,        -- Force no underline
	styles = {                   -- Handles the styles of general hi groups (see `:h highlight-args`):
		comments = { "italic" }, -- Change the style of comments
		conditionals = { "italic" },
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
		-- miscs = {}, -- Uncomment to turn off hard-coded styles
	},
	color_overrides = {},
	custom_highlights = {},
	default_integrations = true,
	integrations = {
		cmp = true,
		gitsigns = true,
		nvimtree = true,
		treesitter = true,
		notify = false,
		mini = {
			enabled = true,
			indentscope_color = "",
		},
		-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
	},
})
vim.cmd 'colorscheme catppuccin'

-- Set Keymaps
require 'keymaps'

-- TreeSitter config
require 'treesitter'

require('lualine').setup {
	options = { theme = "codedark" },
}
