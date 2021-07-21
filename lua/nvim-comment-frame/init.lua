local config = require('nvim-comment-frame.config')
local Comment = require('nvim-comment-frame.comment')
local Util = require('nvim-comment-frame.util')

local v = vim
local api = vim.api
local fn = vim.fn
local ts = vim.treesitter

local CommentFrame = {}

-- Prints an error message
local function err(message)
	api.nvim_err_write("[nvim-comment-frame]:" .. message)
end

-- Returns the cursor line number
local function get_curr_cursor()
	local win = api.nvim_get_current_win()
	local cursor = api.nvim_win_get_cursor(win)

	return cursor
end

-- Returns the language for current line using treesitter
local function get_curr_lang()
	local parser = ts.get_parser(api.nvim_get_current_buf())
	local line = get_curr_cursor()[1]

	return parser:language_for_range({
		line, 0, line, 0
	}):lang()
end

-- Returns the language configuration for current treesitter language
local function get_lang_config(lang)
	return config['languages'][lang]
end

-- Merge content of two table and returns a new table
local function merge_tables(t1, t2)
    for k, v in pairs(t2) do
        if (type(v) == "table") and (type(t1[k] or false) == "table") then
            merge_tables(t1[k], t2[k])
        else
            t1[k] = v
        end
    end

    return t1
end

-- Detects the language and writes comment to the buffer
function CommentFrame.auto_comment()
	-- get the language of the current buffer from treesitter
	local curr_lang = get_curr_lang()

	-- @TODO when treesitter has no parser for the filetype it fails at
	-- treesitter level before this function
	-- need to find out why and how to show a meaningful error message
	if curr_lang == nil then
		err('Treesitter cannot figure out the language')
	end

	-- get the comment frame configuration for current language
	local lang_config = get_lang_config(curr_lang)

	if lang_config == nil then
		err("Could not find a configuration for language '" .. curr_lang .. "'")
	end

	-- get content from the user
	local text = fn.input('What is the comment? ')

	if Util.String.is_empty(text) then
		return
	end

	-- generate the comment
	local comment = Comment
		:new(lang_config)
		:get_comment(text)

	-- retrieve current line number
	local line = get_curr_cursor()[1]

	-- add the lines to the buffer
	api.nvim_buf_set_lines(
		api.nvim_get_current_buf(),
		line,
		line,
		false,
		comment
	)
end

-- Merge the default configuration with the user configuration
local function setup (opt)
	config = merge_tables(config, opt or {})

	CommentFrame.auto_comment()
end


return {
	setup = setup
}
