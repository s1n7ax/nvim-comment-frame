local config = require('nvim-comment-frame.config')
local Comment = require('nvim-comment-frame.comment')
local Indent = require('nvim-treesitter.indent')
local Util = require('nvim-comment-frame.util')
local Treesitter = Util.Treesitter
local Logger = Util.Logger
local Nvim = Util.Nvim
local Lua = Util.Lua
local fn = vim.fn
local api = vim.api

-- Returns the language configuration for current treesitter language
local function get_lang_config(lang, line)
	local lc = config['languages'][lang]

	-- set language fallback configuration
	lc.start_str = lc.start_str or config.start_str
	lc.end_str = lc.end_str or config.end_str
	lc.fill_char = lc.fill_char or config.fill_char
	lc.box_width = lc.box_width or config.box_width
	lc.line_wrap_len = lc.line_wrap_len or config.line_wrap_len
	lc.indent_str = ''

	-- indentation configuration
	local should_indent = lc.auto_indent

	if should_indent == nil then
		should_indent = config.auto_indent
	end

	local expandtab = vim.o.expandtab
	local shiftwidth = fn.shiftwidth()
	local spaces_pattern = '%%%is'

	if should_indent then
		if expandtab then
			lc.indent_str = spaces_pattern
				:format(shiftwidth)
				:format(' ')
		else
			local indent_size = Indent.get_indent(line)

			if indent_size > 0 then
				local tabs = indent_size / shiftwidth
				lc.indent_str = spaces_pattern
					:format(tabs)
					:format(' ')
					:gsub(' ', '\t')
			end
		end
	end


	return lc
end

-- Detects the language and writes comment to the buffer
local function add_comment()
	-- retrieve current line number
	local line = Nvim.get_curr_cursor()[1]

	-- get the language of the current buffer from treesitter
	local curr_lang = Treesitter.get_curr_lang()

	-- @TODO when treesitter has no parser for the filetype it fails at
	-- treesitter level before this function
	-- need to find out why and how to show a meaningful error message
	if curr_lang == nil then
		Logger.error('Treesitter cannot figure out the language')
	end

	-- get the comment frame configuration for current language
	local lang_config = get_lang_config(curr_lang, line)

	if lang_config == nil then
		Logger.error("Could not find a configuration for language '" .. curr_lang .. "'")
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
	config = Lua.merge_tables(config, opt or {})

	if not config.disable_default_keymap then
		local keymap = config.keymap or '<leader>cf'
		api.nvim_set_keymap(
			'n',
			keymap,
			":lua require('nvim-comment-frame').add_comment()<CR>",
			{ silent = true }
		)
	end
end


return {
	setup = setup,
	add_comment = add_comment,
}
