local M = {}

local state = {
  bufnr = nil,
}

local function check_and_install_gemini()
  if vim.fn.executable('gemini') == 0 then
    local answer = vim.fn.input('Gemini CLI not found. Install it now? (y/n): ')
    if answer:lower() == 'y' then
      local cmd = "npm install -g @google/gemini-cli"
      vim.fn.termopen(cmd, {
        on_exit = function()
          vim.notify("Gemini CLI installation finished. Please restart Neovim.")
        end
      })
    end
  end
end

function M.toggle_gemini_cli()
    -- Check if the buffer exists and is loaded
    if state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
        local winnr = vim.fn.bufwinnr(state.bufnr)
        if winnr ~= -1 then
            -- Window is visible, close it
            vim.api.nvim_win_close(winnr, true)
        else
            -- Buffer exists but is hidden, show it in a new split
            vim.cmd("vsplit")
            vim.cmd("buffer " .. state.bufnr)
        end
    else
        -- No buffer, so create one
        vim.cmd("vsplit")
        vim.cmd("enew")
        vim.cmd("setlocal buftype=nofile bufhidden=hide noswapfile")
        state.bufnr = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_name(state.bufnr, "gemini_cli") -- for display
        vim.fn.termopen("gemini", {
            env = {["EDITOR"] = "nvim"},
            on_exit = function()
                -- When the user exits the terminal, clear the buffer number
                state.bufnr = nil
            end
        })
    end
end

function M.setup()
  check_and_install_gemini()
  vim.api.nvim_set_keymap('n', '<leader>G', '<cmd>lua require("gemini").toggle_gemini_cli()<CR>', { noremap = true, silent = true })
end

return M