local Indent = require('nvim-treesitter.indent')

local v = vim
local api = v.api
local ts = v.treesitter
local fn = v.fn
local o = v.o

local String = {}

-- Returns an array of strings splitted by given pattern
function String.split(str, pattern)
    local lines = {}

    for s in str:gmatch(pattern) do table.insert(lines, s) end

    return lines
end

function String.trim(str) return str:gsub('^%s+', ''):gsub('%s+$', '') end

function String.wrap_lines(str, wrap_len)
    str = String.trim(str)

    -- if the rtring is empty, end the function
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
            -- length, brea
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

-- Promp to get multiline user input
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
-- This detects the current tab or space preferance from 'expandtab' option and
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
    local parser = ts.get_parser(api.nvim_get_current_buf())
    local line = Nvim.get_curr_cursor()[1]

    return parser:language_for_range({ line, 0, line, 0 }):lang()
end

function Treesitter.get_lang_stack_for_position(cursor, buffer)
    local parser = ts.get_parser(buffer)
    local root = parser:trees()[1]:root()
    -- cursor starts at 1
    local line_no = cursor[1] - 1
    local lang_stack = {}

    -- add lang to final starck that will be returned
    local add_lang = function(lang) table.insert(lang_stack, lang) end

    -- get iterator from a given list
    local get_list_iter = function(list)
        if not v.tbl_islist(list) then list = v.tbl_values(list) end

        local index = 1
        return {
            next = function()
                local temp_index = index
                index = index + 1
                return list[temp_index]
            end,
        }
    end

    -- if the root of the tree is out of range of the cursor, exit
    if not (root:start() <= line_no and root:end_() >= line_no) then
        return nil
    end

    add_lang(parser:lang())

    -- recursivly search
    local function deep_lang_search(iter)
        local tree = iter.next()

        if not tree then return end

        for _, region in ipairs(tree:included_regions()) do
            region = region[1]

            if (region:start() <= line_no and region:end_() >= line_no) then
                add_lang(tree:lang())
            end
        end

        if v.tbl_count(tree:children()) > 0 then
            local child_iter = get_list_iter(tree:childret())

            deep_lang_search(child_iter)
        end

        deep_lang_search(iter)
    end

    local children = parser:children()
    local child_iter = get_list_iter(children)

    deep_lang_search(child_iter)

    -- invert the list
    local inverted_lang_stack = {}
    for i = v.tbl_count(lang_stack), 1, -1 do
        table.insert(inverted_lang_stack, lang_stack[i])
    end

    return inverted_lang_stack
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
