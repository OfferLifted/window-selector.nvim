-- window-selector.lua
local M = {}

local function swap_buffers(win1, win2)
	if not (vim.api.nvim_win_is_valid(win1) and vim.api.nvim_win_is_valid(win2)) then
		return
	end

	local buf1 = vim.api.nvim_win_get_buf(win1)
	local buf2 = vim.api.nvim_win_get_buf(win2)

	vim.api.nvim_win_set_buf(win1, buf2)
	vim.api.nvim_win_set_buf(win2, buf1)
end

function M.select_window()
	local current_win = vim.api.nvim_get_current_win()
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
		-- vim.api.nvim_echo({ { "Invalid selection", "ErrorMsg" } }, true, {})
	end
end

function M.swap_window()
	local current_win = vim.api.nvim_get_current_win()
	local win_list = vim.api.nvim_tabpage_list_wins(0)
	local win_numbers = {}
	local statuslines = {}

	local count = 1
	for _, win in ipairs(win_list) do
		if win ~= current_win then
			local win_num = tostring(count)
			win_numbers[win_num] = win
			statuslines[win] = vim.wo[win].statusline
			vim.wo[win].statusline = "%#CursorLineNr#%=" .. win_num .. "%="
			count = count + 1
		end
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
	local target_win = win_numbers[key]
	if target_win then
		swap_buffers(current_win, target_win)
		restore_statuslines()
		vim.api.nvim_set_current_win(target_win)
		vim.api.nvim_set_current_win(current_win)
	else
		restore_statuslines()
		-- vim.api.nvim_echo({ { "Invalid selection", "ErrorMsg" } }, true, {})
	end
end

function M.setup(opts)
	opts = opts or {}
	local select_keymap = opts.select_keymap or "<leader>="
	local swap_keymap = opts.swap_keymap or "<leader>+"

	if select_keymap and select_keymap ~= "" then
		vim.api.nvim_set_keymap(
			"n",
			select_keymap,
			'<cmd>lua require("window-selector").select_window()<CR>',
			{ noremap = true, silent = true, desc = "Select Window" }
		)
	end

	if swap_keymap and swap_keymap ~= "" then
		vim.api.nvim_set_keymap(
			"n",
			swap_keymap,
			'<cmd>lua require("window-selector").swap_window()<CR>',
			{ noremap = true, silent = true, desc = "Swap Window" }
		)
	end
end

return M
