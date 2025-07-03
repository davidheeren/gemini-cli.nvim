# gemini.nvim

A Neovim plugin to seamlessly integrate the Gemini CLI.

## Features

- Toggle the Gemini CLI in a vertical split window.
- Automatically checks if the `gemini` CLI is installed on startup.
- Prompts to install the `gemini` CLI if it's missing.
- Sets the `EDITOR` environment variable to `nvim` for the Gemini CLI session, so you can use Neovim to edit files from within Gemini.

## Requirements

- Neovim >= 0.7.0
- [Node.js and npm](https://nodejs.org/) (for the Gemini CLI)

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "jonroosevelt/gemini.nvim",
  config = function()
    require("gemini").setup()
  end,
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "jonroosevelt/gemini.nvim",
  config = function()
    require("gemini").setup()
  end,
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'jonroosevelt/gemini.nvim'
```

And then in your `init.lua`:

```lua
require('gemini').setup()
```

## Usage

Use the keymap `<leader>og` to open and close the Gemini CLI window.

When you first run the plugin, it will check if you have the `gemini` CLI installed. If not, it will prompt you to install it.
