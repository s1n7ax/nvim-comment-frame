local Assert = require('nvim-comment-frame.assertion')
local Util = require('nvim-comment-frame.util')

local Comment = {}

function Comment:new(opt)
	opt = opt or {}

	self:validate_config(opt)

	self.start_str = opt.start_str
	self.end_str = opt.end_str
	self.fill_char = opt.fill_char
	self.box_width = opt.box_width
	self.word_wrap_len = opt.word_wrap_len

	self.COMMENT_LINE_FORMAT = '%%s%%%is%%s'
	self.TEXT_LINE_FORMAT = '%%s%%%is%%s%%%is%%s'

	return self
end

-- validates all the properties
function Comment:validate_config(opt)
	-- if the end_str is not passed, start_str will be used
	opt.end_str = opt.end_str or opt.start_str

	Assert.String.is_str(opt.start_str, "start_str should be a string")
	Assert.String.is_str(opt.end_str, "end_str should be a string")
	Assert.String.is_str(opt.fill_char, "fill_char should be a single character string")

	Assert.String.is_not_empty(opt.start_str, "start_str shouldn't be empty")
	Assert.String.is_not_empty(opt.end_str, "end_str shouldn't be empty")

	Assert.String.is_char(opt.fill_char, "fill_char should be a single character")

	Assert.Number.is_number(opt.box_width, "box_width should be a number")
	Assert.Number.is_number(opt.word_wrap_len, "word_wrap should be a number")

	local padding = opt.box_width - (opt.start_str:len() + opt.end_str:len())

	Assert.is_true(
		opt.word_wrap_len <= padding,
		"word_wrap should be less than or equal to " .. padding
	)
end

-- Returns the lines of comment frame
function Comment:get_comment(text)
	Assert.String.is_not_empty(text, "comment text shouldn't be empty")

	local lines = {}

	table.insert(lines, self:get_border_line())

	for _, line in ipairs(Util.String.wrap_lines(text, self.word_wrap_len)) do
		table.insert(lines, self:get_text_line(line))
	end

	table.insert(lines, self:get_border_line())

	return lines
end

-- Returns comment line for a given text
function Comment:get_text_line(text)
	local padding = self.box_width - (
		self.start_str:len() + self.end_str:len() + text:len()
	)

	local left_padding = math.floor(padding / 2)
	local right_padding = padding - left_padding

	return self.TEXT_LINE_FORMAT
		:format(left_padding, right_padding)
		:format(
			self.start_str,
			'',
			text,
			'',
			self.end_str
		)
end

-- Returns border of the comment frame
function Comment:get_border_line()
	local padding_len = self.box_width - (self.start_str:len() + self.end_str:len())
	local comment, _ =  self.COMMENT_LINE_FORMAT
		:format(padding_len)
		:format(
			self.start_str,
			'',
			self.end_str
		):gsub(' ', self.fill_char)

	return comment
end

return Comment
