# nvim-comment-frame

Basically when you give it some text it creates a comment frame like below.

```javascript
//------------------------------------------------------------------//
//                        nvim-comment-frame                        //
//------------------------------------------------------------------//
```

## Features

### Detects the language using Treesitter

`nvim-comment-frame` detects the current language using `treesitter` and changes
the comment character based on the language.

**Bash**

```bash
#--------------------------------------------------------------------#
#                            Hello World                             #
#--------------------------------------------------------------------#
```

**Lua**

```lua
----------------------------------------------------------------------
--                           Hello World                            --
----------------------------------------------------------------------
```

### Wrap lines

**CSS**

```css
/*------------------------------------------------------------------*/
/*         Cascading Style Sheets is a style sheet language         */
/*        used for describing the presentation of a document        */
/*        written in a markup language such as HTML. CSS is         */
/*         a cornerstone technology of the World Wide Web,          */
/*                  alongside HTML and JavaScript.                  */
/*------------------------------------------------------------------*/
```

## Install

**Packer**

```lua
use { 
	's1n7ax/nvim-terminal',
	config = function()
		require('nvim-comment-frame').setup()
	end
}
```

## Configuring

### General configuration

Except `disable_default_keymap` and `keymap`, all the other properties can be
overridden for individual language.

Following are the general configurations with default values.

```lua
require('nvim-comment-frame').setup({
	disable_default_keymap = false,
	keymap = '<leader>fc'
	box_width = 60,
	word_wrap_len = 40,

	languages = {
	}
})
```

### Language level configuration

```lua
require('nvim-comment-frame').setup({
	languages = {
		lua = {
			start_str = '--[[',
			end_str = ']]--',
			fill_char = '*',
		},
	}
})
```
