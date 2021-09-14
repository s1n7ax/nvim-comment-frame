local config = require('nvim-comment-frame.config')
local Comment = require('nvim-comment-frame.comment')
local Util = require('nvim-comment-frame.util')
local Treesitter = Util.Treesitter
local Logger = Util.Logger
local Nvim = Util.Nvim
local Lua = Util.Lua

local v = vim
local fn = v.fn
local api = v.api
local ts = v.treesitter

-- Returns the language configuration for current treesitter language
local function get_lang_config(lang_stack)
    local lc = nil

    for _, l in ipairs(lang_stack) do
        lc = config['languages'][l]

        if lc then break end
    end

    if not lc then return nil end

    -- set language fallback configuration
    lc.start_str = lc.start_str or config.start_str
    lc.end_str = lc.end_str or config.end_str
    lc.fill_char = lc.fill_char or config.fill_char
    lc.frame_width = lc.frame_width or config.frame_width
    lc.line_wrap_len = lc.line_wrap_len or config.line_wrap_len
    lc.add_comment_above = lc.add_comment_above or config.add_comment_above

    lc.indent_str = ((lc.auto_indent == nil and config.auto_indent) or
                        (lc.auto_indent)) and Nvim.get_indent_string() or
                        ''

    return lc
end

--[[
-- Returns the comment object based on the line in the current buffer
--]]
local function get_comment()
    -- get the language of the current buffer from treesitter
    local lang_stack = Treesitter.get_curr_lang_stack_for_position()

    -- @TODO when treesitter has no parser for the filetype it fails at
    -- treesitter level before this function
    -- need to find out why and how to show a meaningful error message
    if lang_stack == nil then
        Logger.error('Treesitter cannot figure out the language')
    end

    -- get the comment frame configuration for current language
    local lconf = get_lang_config(lang_stack)

    if lconf == nil then
        Logger.error(
            'configuration not found for languages: ' .. tostring(lang_stack))
    end

    -- generate the comment
    return Comment:new(lconf)
end

local function add_comment_common(text, comment, opts)
    if Util.String.is_empty(text) then return end

    local bufnr = api.nvim_get_current_buf()
    local line_num = Nvim.get_curr_line_num()

    Nvim.set_lines(
        comment:get_comment(text), bufnr, line_num,
        opts.add_comment_above or config.add_comment_above)
end

--[[
-- Adds a comment frame to the buffer
-- This takes SINGLE line user input and insers a comment to the buffer
--]]
local function add_comment(opts)
    opts = opts or {}
    local comment = opts.comment or get_comment()
    add_comment_common(Nvim.get_user_input(), comment, opts)
end

--[[
-- Adds a comment frame to the buffer
-- This takes MULTILINE user input and insers a comment to the buffer
--]]
local function add_multiline_comment(opts)
    opts = opts or {}
    local comment = opts.comment or get_comment()
    add_comment_common(Nvim.get_multiline_user_input(), comment, opts)
end

--[[
-- Setup the plugin configuration
--]]
local function setup(opt)
    config = Lua.merge_tables(config, opt or {})

    if not config.disable_default_keymap then
        local keymap = config.keymap or '<leader>cf'
        local multiline_keymap = config.multiline_keymap or '<leader>cm'

        -- Single line input keybind
        api.nvim_set_keymap(
            'n', keymap,
            ':lua require(\'nvim-comment-frame\').add_comment()<CR>',
            { silent = true })

        -- Multiline input keybind
        api.nvim_set_keymap(
            'n', multiline_keymap,
            ':lua require(\'nvim-comment-frame\').add_multiline_comment()<CR>',
            { silent = true })
    end
end

return {
    setup = setup,
    add_comment = add_comment,
    add_multiline_comment = add_multiline_comment,
}
