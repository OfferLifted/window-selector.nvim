# window-selector.nvim

A Neovim plugin that for window management allows you to quickly select and swap windows using keybindings.  
It displays numbers on windows for easy selection and integrates with other plugins like `inactive-dimmer.nvim`.

## Features

- **Quick Window Selection**: Press a designated keybinding to display numbers on all windows and select the desired one by pressing its number.
- **Window Swapping**: Swap the active window with another selected window.
- **Customizable Keybindings**: Configure your preferred keybindings for selecting and swapping windows.

## Installation

Use your favorite plugin manager to install `window-selector.nvim`.

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
	"OfferLifted/window-selector.nvim",
	event = "VimEnter",

	opts = {
		select_keymap = "<leader>=", -- Keybinding to select a window
		swap_keymap = "<leader>+", -- Keybinding to swap windows
	},
}

```
