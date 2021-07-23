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

### Auto indent

* `auto_indent` is set to `true` by default. When this option is on, plugin will
use `treesitter` to get the indentation of the current line and indent the comment
* You can turn off this globally or just for a language by `auto_indent = false`

```
detachstack(Client *c)
{
	Client **tc, *t;

	for (tc = &c->mon->stack; *tc && *tc != c; tc = &(*tc)->snext);
	*tc = c->snext;
	------------------------------------------------------------
	--                      Hello World                       --
	------------------------------------------------------------

	if (c == c->mon->sel) {
		for (t = c->mon->stack; t && !ISVISIBLE(t); t = t->snext);
		c->mon->sel = t;
	}
}
```

## Install

**Packer**

```lua
use { 
	's1n7ax/nvim-comment-frame',
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
