-- window-selector.lua
local M = {}

function M.select_window()
	local win_list = vim.api.nvim_tabpage_list_wins(0)
	local win_numbers = {}
	local statuslines = {}

	for i, win in ipairs(win_list) do
		local win_num = tostring(i)
		win_numbers[win_num] = win
		statuslines[win] = vim.wo[win].statusline
		vim.wo[win].statusline = "%#CursorLineNr#%=" .. win_num .. "%="
	end

	vim.cmd("redraw")

	local function restore_statuslines()
		for win, status in pairs(statuslines) do
			if vim.api.nvim_win_is_valid(win) then
				vim.wo[win].statusline = status
			end
		end
		vim.cmd("redrawstatus")
	end

	local char = vim.fn.getchar()
	if char == 0 or char == 27 then -- timeout or ESC
		restore_statuslines()
		return
	end

	local key = vim.fn.nr2char(char)
	if win_numbers[key] then
		restore_statuslines()
		vim.api.nvim_set_current_win(win_numbers[key])
	else
		restore_statuslines()
		return

		-- vim.api.nvim_echo({ { "Invalid selection", "ErrorMsg" } }, true, {})
	end
end

function M.setup(opts)
	opts = opts or {}
	local keymap = opts.keymap or "<leader>="

	if keymap and keymap ~= "" then
		vim.api.nvim_set_keymap(
			"n",
			keymap,
			'<cmd>lua require("window-selector").select_window()<CR>',
			{ noremap = true, silent = true, desc = "Select Window" }
		)
	end
end

return M
