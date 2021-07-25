# nvim-comment-frame

Basically when you give it some text it creates a comment frame like below.

```
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                   nvim-comment-frame                   ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```

## Features

- Language detection
- Wrap lines
- Auto indent

### Language detection

- Detects the current language using `treesitter` and changes
the comment string based on the language.

**JavaScript**

```javascript
//--------------------------------------------------------//
//       JavaScript, often abbreviated as JS, is a        //
//       programming language that conforms to the        //
//                ECMAScript specification                //
//--------------------------------------------------------//
var fs = require('fs');
var path = require('path');

var BUFFER = bufferFile('../public/data.png');

function bufferFile(relPath) {
    return fs.readFileSync(path.join(__dirname, relPath));
}
```

**Bash**

```bash
#----------------------------------------------------------#
#    Bash is a Unix shell and command language written     #
#                       by Brian Fox                       #
#----------------------------------------------------------#
for i in $(seq 1 10);
do
    echo $i
done
```

**Lua**

```lua
--********************************************************--
--    Lua is a lightweight, high-level, multi-paradigm    --
--      programming language designed primarily for       --
--              embedded use in applications              --
--********************************************************--
function String.trim(str)
    return str:gsub('^%s+', ''):gsub('%s+$', '')
end
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
body, h1 {
    font-family: arial,sans-serif;
    font-size: 14px;
}
```

### Auto indent

- `auto_indent` is set to `true` by default. When this option is on, plugin will
use `treesitter` to get the indentation of the current line and indent the comment
- Based on the `expandtab` option, plugin will use `tab` or `space` for
  indentation
- You can turn off this globally or just for a language by `auto_indent = false`

```
detachstack(Client *c)
{
    Client **tc, *t;

    for (tc = &c->mon->stack; *tc && *tc != c; tc = &(*tc)->snext);
    *tc = c->snext;
    //--------------------------------------------------------//
    //      C is a general-purpose, procedural computer       //
    //       programming language supporting structured       //
    //        programming, lexical variable scope, and        //
    //          recursion, with a static type system          //
    //--------------------------------------------------------//

    if (c == c->mon->sel) {
        for (t = c->mon->stack; t && !ISVISIBLE(t); t = t->snext);
        c->mon->sel = t;
    }
}
```

## Keymaps

- `<leader>cf` - Single line comment
- `<leader>cm` - Multiline comment

## Install

**Packer**

- Add the plugin to the configuration

```lua
use { 
    's1n7ax/nvim-comment-frame',
    requires = {
        { 'nvim-treesitter' }
    },
    config = function()
        require('nvim-comment-frame').setup()
    end
}
```

- Install the plugin

```vim
:PackerInstall
```

- Compile the packages

```
:PackerCompile
```

## Configurations

### General configurations

Except `disable_default_keymap` and `keymap`, all the other properties can be
overridden for individual language.

Following are the general configurations with default values.

```lua
require('nvim-comment-frame').setup({

    -- if true, <leader>cf keymap will be disabled
    disable_default_keymap = false,

    -- adds custom keymap
    keymap = '<leader>cc',
    multiline_keymap = '<leader>C',

    -- start the comment with this string
    start_str = '//',

    -- end the comment line with this string
    end_str = '//',

    -- fill the comment frame border with this character
    fill_char = '-',

    -- width of the comment frame
    frame_width = 70,

    -- wrap the line after 'n' characters
    line_wrap_len = 50,

    -- automatically indent the comment frame based on the line
    auto_indent = true,

    -- add comment above the current line
    add_comment_above = true,

    -- configurations for individual language goes here
    languages = {
    }
})
```

### Language specific configurations

```lua
require('nvim-comment-frame').setup({
    languages = {
        -- configuration for Lua programming language
        -- @NOTE global configuration will be overridden by language level
        configuration if provided
        lua = {
            -- start the comment with this string
            start_str = '--[[',

            -- end the comment line with this string
            end_str = ']]--',

            -- fill the comment frame border with this character
            fill_char = '*',

            -- width of the comment frame
            frame_width = 100,

            -- wrap the line after 'n' characters
            line_wrap_len = 70,

            -- automatically indent the comment frame based on the line
            auto_indent = false,

            -- add comment above the current line
            add_comment_above = false,
        },
    }
})
```
