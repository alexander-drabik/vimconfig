require 'logic'

-- Execute file
local function run()
	local filetype = vim.bo.filetype
	if filetype == 'html' then
		vim.cmd(':!firefox %')
	elseif filetype == 'cpp' then
		vim.cmd(':!make run')
	elseif filetype == 'python' then
		vim.cmd(':!python %')
	elseif filetype == "rust" then
		vim.cmd(':!cargo run')
	end
end

function ShowDocumentation()
	if vim.fn.CocAction('hasProvider', 'hover') then
		vim.fn.CocActionAsync('doHover')
	else
		vim.fn.feedkeys('K', 'n')
	end
end

-- Coc Bindings
vim.api.nvim_set_keymap('n', 'K', ':lua ShowDocumentation()<CR>', { silent = true })
vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', { silent = true })
vim.api.nvim_set_keymap('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', { silent = true })
vim.api.nvim_set_keymap('n', 'rn', '<Plug>(coc-rename)', { silent = true })
vim.api.nvim_set_keymap('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
vim.api.nvim_set_keymap('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>d', '<Plug>(coc-codeaction)', {})
vim.api.nvim_set_keymap('n', '<leader>k', '<Plug>(coc-codeaction-selected)', {})
vim.api.nvim_set_keymap('n', '<leader>j', '<Plug>(coc-codeaction-line)', {})
vim.api.nvim_set_keymap('n', '<leader>h', '<Plug>(coc-codeaction-cursor)', {})

-- Neoscroll Bindings
local t    = {}
t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '350', [['sine']] } }
t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '350', [['sine']] } }
t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '500', [['circular']] } }
t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '500', [['circular']] } }
t['<C-y>'] = { 'scroll', { '-0.10', 'false', '100', nil } }
t['<C-e>'] = { 'scroll', { '0.10', 'false', '100', nil } }
t['zt']    = { 'zt', { '300' } }
t['zz']    = { 'zz', { '300' } }
t['zb']    = { 'zb', { '300' } }
require('neoscroll.config').set_mappings(t)

-- Telescope Bindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fd', builtin.git_status, {})

-- Compiler Bindings
vim.api.nvim_set_keymap('n', '<F10>', "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F9>',
	"<cmd>CompilerRedo<cr>",
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cc', "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cq', "<cmd>CompilerStop<cr>", { noremap = true, silent = true })

-- 'Open' command, used to open files in the same directory as the current file
local filepath = vim.fn.expand([[%:p:h]]) .. "/"
vim.api.nvim_create_user_command('Open', function(opts)
	vim.cmd.e(filepath .. opts.fargs[1])
end, {
	nargs = 1,
	complete = function(ArgLead, _, _)
		local result = {}
		for dir in io.popen([[ls -pa ]] .. filepath .. [[ | grep -v /]]):lines() do
			if string.find(dir, ArgLead) then
				table.insert(result, dir)
			end
		end
		return result
	end,
})
