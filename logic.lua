-- Opt settings
function Opt(t)
	for k, v in pairs(t) do
		vim.opt[k] = v
	end
end

-- Setting keymaps
function Map(mode, lhs, exec, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend('force', options, opts)
	end
	vim.keymap.set(mode, lhs, exec, options)
end
