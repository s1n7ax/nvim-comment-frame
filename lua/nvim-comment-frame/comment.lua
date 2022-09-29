local Assert = require("nvim-comment-frame.assertion")
local Util = require("nvim-comment-frame.util")

local Comment = {}

function Comment:new(opt)
	opt = opt or {}

	self:validate_config(opt)

	self.start_str = opt.start_str
	self.end_str = opt.end_str
	self.fill_char = opt.fill_char
	self.frame_width = opt.frame_width
	self.line_wrap_len = opt.line_wrap_len
	self.indent_str = opt.indent_str

	return self
end

-- validates all the properties
function Comment:validate_config(opt)
	-- if the end_str is not passed, start_str will be used
	opt.end_str = opt.end_str or opt.start_str

	Assert.String.is_str(opt.start_str, "start_str should be a string")
	Assert.String.is_str(opt.end_str, "end_str should be a string")
	Assert.String.is_str(opt.fill_char, "fill_char should be a single character string")
	Assert.String.is_str(opt.indent_str, "indent_str should be a string")

	Assert.String.is_not_empty(opt.start_str, "start_str shouldn't be empty")
	Assert.String.is_not_empty(opt.end_str, "end_str shouldn't be empty")

	Assert.String.is_char(opt.fill_char, "fill_char should be a single character")

	Assert.Number.is_number(opt.frame_width, "frame_width should be a number")
	Assert.Number.is_number(opt.line_wrap_len, "line_wrap_len should be a number")

	local padding = opt.frame_width - (opt.start_str:len() + opt.end_str:len())

	Assert.is_true(opt.line_wrap_len <= padding, "line_wrap_len should be less than or equal to " .. padding)
end

-- Returns the lines of comment frame
function Comment:get_comment(text)
	Assert.String.is_not_empty(text, "comment text shouldn't be empty")

	local lines = {}

	table.insert(lines, self:get_border_line())

	for _, line in ipairs(Util.String.wrap_lines(text, self.line_wrap_len)) do
		table.insert(lines, self:get_text_line(line))
	end

	table.insert(lines, self:get_border_line())

	return lines
end

-- Returns comment line for a given text
function Comment:get_text_line(text)
	local padding = self.frame_width - (self.start_str:len() + self.end_str:len() + text:len())

	local left_padding = math.floor(padding / 2)
	local right_padding = padding - left_padding

	return self.indent_str
		.. self.start_str
		.. string.rep(" ", left_padding)
		.. text
		.. string.rep(" ", right_padding)
		.. self.end_str
end

-- Returns border of the comment frame
function Comment:get_border_line()
	local fill_len = self.frame_width - (self.start_str:len() + self.end_str:len())

	return self.indent_str .. self.start_str .. string.rep(self.fill_char, fill_len) .. self.end_str
end

return Comment
