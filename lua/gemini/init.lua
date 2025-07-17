local M = {}

local state = {
	bufnr = nil,
	winnr = nil,
}

local function close_gemini_window()
	if state.winnr and vim.api.nvim_win_is_valid(state.winnr) then
		vim.api.nvim_win_close(state.winnr, true)
	end
	state.winnr = nil
end

local function open_gemini_window()
	if state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
		vim.cmd("vsplit")
		state.winnr = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(state.winnr, state.bufnr)
	else
		vim.cmd("vsplit")
		vim.cmd("enew")
		vim.cmd("setlocal buftype=nofile bufhidden=hide noswapfile")
		state.winnr = vim.api.nvim_get_current_win()
		state.bufnr = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_name(state.bufnr, "gemini_cli")
		vim.fn.termopen("gemini", {
			env = { ["EDITOR"] = "nvim" },
			on_exit = function()
				local win_to_close = state.winnr
				if win_to_close and vim.api.nvim_win_is_valid(win_to_close) then
					if vim.api.nvim_win_get_buf(win_to_close) == state.bufnr then
						vim.api.nvim_win_close(win_to_close, true)
					end
				end
				state.bufnr = nil
				state.winnr = nil
			end,
		})
	end
end

function M.toggle_gemini_cli()
	if state.winnr and vim.api.nvim_win_is_valid(state.winnr) then
		close_gemini_window()
	else
		open_gemini_window()
	end
end

function M.setup()
	if vim.fn.executable("gemini") == 1 then
		vim.api.nvim_set_keymap(
			"n",
			"<leader>og",
			'<cmd>lua require("gemini").toggle_gemini_cli()<CR>',
			{ noremap = true, silent = true }
		)
	else
		local answer = vim.fn.input("Gemini CLI not found. Install it now? (y/n): ")
		if answer:lower() == "y" then
			local cmd = "npm install -g @google/gemini-cli"
			vim.fn.termopen(cmd, {
				on_exit = function()
					vim.notify("Gemini CLI installation finished. Please restart Neovim to use the plugin.")
				end,
			})
		else
			vim.notify("Gemini CLI not found. The gemini.nvim plugin will not be loaded.", vim.log.levels.WARN)
		end
	end
end

return M