
local M = {}

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
    local buf_name = "gemini_cli"
    local bufnr = vim.fn.bufnr(buf_name)
    local winnr = vim.fn.bufwinnr(bufnr)

    if winnr ~= -1 then
        -- Window is visible, close it
        vim.api.nvim_win_close(winnr, true)
    else
        -- Window is not visible, open it
        vim.cmd("vsplit")
        if bufnr ~= -1 then
            -- Buffer exists, just show it
            vim.cmd("buffer " .. bufnr)
        else
            -- Buffer doesn't exist, create it and open terminal
            vim.cmd("enew")
            vim.api.nvim_buf_set_name(0, buf_name)
            vim.cmd("setlocal buftype=nofile bufhidden=hide noswapfile")
            vim.fn.termopen("gemini", {env = {["EDITOR"] = "nvim"}})
        end
    end
end

function M.setup()
  check_and_install_gemini()
  vim.api.nvim_set_keymap('n', '<leader>og', '<cmd>lua require("gemini").toggle_gemini_cli()<CR>', { noremap = true, silent = true })
end

return M
