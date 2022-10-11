local parsers = require('nvim-treesitter.parsers')

---@diagnostic disable-next-line: undefined-global
local v = vim
local api = v.api
local fn = v.fn

local String = {}

-- Returns an array of strings split by given pattern
function String.split(str, pattern)
    local lines = {}

    for s in str:gmatch(pattern) do table.insert(lines, s) end

    return lines
end

function String.trim(str) return str:gsub('^%s+', ''):gsub('%s+$', '') end

function String.wrap_lines(str, wrap_len)
    str = String.trim(str)

    -- if the string is empty, end the function
    if str:len() <= 0 then return nil end

    local function find_break_point()
        local newline_index, _ = str:find('[\r\n]+', 1)

        -- if there is a newline before the wrap_len, the line should break
        -- regardless
        if (newline_index ~= nil and newline_index <= wrap_len) then
            return (newline_index - 1)
        end

        -- if string length is equal or less than the wrap_len, then no need do
        -- wrap
        if (str:len() <= wrap_len) then return str:len() end

        -- if non of the above criteria are a match, then we need to find the
        -- last word
        local last_space_index = 1

        while true do
            local index = last_space_index

            if last_space_index ~= 1 then index = index + 1 end

            local space_index, _ = str:find('%s', index)

            -- if current space index and newline index are beyond the wrap
            -- length, break
            if (space_index == nil or (space_index - 1) > wrap_len) then
                break
            end

            -- set the start at to index of space to start "find" from this index
            last_space_index = space_index
        end

        -- if there are no spaces in the current text, then do a hard break line
        -- at wrap_len
        if last_space_index == 1 then return wrap_len end

        return (last_space_index - 1)
    end

    local break_point = find_break_point()

    local lines = { str:sub(1, break_point) }

    for _, line in ipairs(
        String.wrap_lines(str:sub(break_point + 1), wrap_len) or
        {}) do table.insert(lines, line) end

    return lines
end

function String.is_empty(str)
    if str:len() < 1 then return true end

    return false
end

function String.get_last_line(str)
---@diagnostic disable-next-line: undefined-global
    local lines = vim.split(str, '[\r\n]')
    return lines[#lines]
end

local Logger = {}

-- Prints an error message
function Logger.error(message)
    -- api.nvim_err_write("[nvim-comment-frame]:" .. message)
    error('[nvim-comment-frame]: ' .. message)
end

local Nvim = {}

-- Returns the cursor
function Nvim.get_curr_cursor()
    local win = api.nvim_get_current_win()
    local cursor = api.nvim_win_get_cursor(win)

    return cursor
end

-- Returns the line number the cursor is on
function Nvim.get_curr_line_num() return Nvim.get_curr_cursor()[1] end

-- Prompt to get user input from the user
function Nvim.get_user_input()
    local text = fn.input('Comment: ')

    -- nvim input takes \n literally so this replaces all of them with actual
    -- new line character and return the value
    return text:gsub('\\n', '\n')
end

-- Prompt to get multi-line user input
function Nvim.get_multiline_user_input()
    local iteration = 0
    local text = ''
    local inputs = ''

    while true do
        -- Change the prompt from the second line
        local prompt = ''

        if iteration == 0 then
            prompt = 'Comment (empty line to end): '
        else
            prompt = '\n'
        end

        text = fn.input(prompt)

        if String.is_empty(text) then break end

        inputs = inputs .. text .. '\n'

        iteration = iteration + 1
    end

    -- remove the last new line character and return the string
    return inputs:gsub('[\r\n]$', '')
end

--[[
-- Inserts the given "lines" to "line_num"
-- @param lines { table<string> } lines to add
-- @param bufnr { number } buffer number the lines should be added
-- @param line_num { number } line number where "lines" should be inserted
-- @param insert_above { boolean } whether to add "lines" before the current
-- line
-- @returns { null }
--]]
function Nvim.set_lines(lines, bufnr, line_num, insert_above)
    bufnr = bufnr or api.nvim_get_current_buf()

    if insert_above then line_num = line_num - 1 end

    -- add the lines to the buffer
    api.nvim_buf_set_lines(bufnr, line_num, line_num, false, lines)
end

--[[
-- Returns the indentation string (spaces or tabs) of a given line
-- This detects the current tab or space preference from 'expandtab' option and
-- change the indentation char accordingly
-- @param line_num { number } line number whose indentation is required
--]]
function Nvim.get_indent_string()
    local line = api.nvim_get_current_line()

    local indentation = line:match('^%s+') or ''
    return indentation or ''
end

local Lua = {}

-- Merge content of two table and returns a new table
function Lua.merge_tables(t1, t2)
    for key, val in pairs(t2) do
        if (type(val) == 'table') and (type(t1[key] or false) == 'table') then
            Lua.merge_tables(t1[key], t2[key])
        else
            t1[key] = val
        end
    end

    return t1
end

local Treesitter = {}

-- Returns the language for current line using treesitter
function Treesitter.get_curr_lang()
    local parser = parsers.get_parser(api.nvim_get_current_buf())
    local line = Nvim.get_curr_cursor()[1]

    return parser:language_for_range({ line, 0, line, 0 }):lang()
end

function Treesitter.get_lang_stack_for_position(cursor, buffer)
    local range = { cursor[1], cursor[2], cursor[1], cursor[2] }
    local root_parser = parsers.get_parser(buffer)

    if not root_parser then
        return
    end

    local lang_trees_tmp = {}
    local lang_trees = {}
    local lang_tree_scope = {}

    root_parser:for_each_child(function(tree, _)
        table.insert(lang_trees_tmp, tree)
    end, true)

    for i = #lang_trees_tmp, 1, -1 do
        local lang_tree = lang_trees_tmp[i]
        table.insert(lang_trees, lang_tree)
    end

    for _, lang_tree in ipairs(lang_trees) do
        if lang_tree:contains(range) then
            table.insert(lang_tree_scope, lang_tree:lang())
        end
    end

    return lang_tree_scope
end

function Treesitter.get_curr_lang_stack_for_position()
    local cursor = api.nvim_win_get_cursor(0)
    local buf = api.nvim_get_current_buf()
    return Treesitter.get_lang_stack_for_position(cursor, buf)
end

return {
    String = String,
    Logger = Logger,
    Nvim = Nvim,
    Lua = Lua,
    Treesitter = Treesitter,
}
