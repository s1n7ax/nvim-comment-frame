local Assertion = require('nvim-comment-frame.assertion')
local String = Assertion.String
local Number = Assertion.Number

local Comment = {}

function Comment:new(opt)
	opt = opt or {}

	String.is_str(opt.start_str, "start_str should be a string")
	String.is_str(opt.end_str, "end_str should be a string")
	String.is_str(opt.fill_char, "fill_char should be a single character string")

	String.is_not_empty(opt.start_str, "start_str shouldn't be empty")
	String.is_not_empty(opt.end_str, "end_str should't be empty")

	String.is_char(opt.fill_char, "fill_char should be a single character")

	Number.is_number(opt.box_width, "box_width should be a number")

	self.start_str = opt.start_str
	self.end_str = opt.end_str
	self.fill_char = opt.fill_char

	self.box_width = opt.box_width

	self.COMMENT_LINE_FORMAT = '%%s%%%is%%s'
	self.TEXT_LINE_FORMAT = '%%s%%%is%%s%%%is%%s'

	return self
end

function Comment:get_comment(text)
	String.is_not_empty(text, "comment text shouldn't be empty")

	local text_len = string.len(text)
	local padding_len = self.box_width - string.len(self.start_str .. self.end_str)

	local text_padding_len = padding_len - text_len
	local left_text_padding_len = math.floor(text_padding_len / 2)
	local right_text_padding_len = text_padding_len - left_text_padding_len

	local comment_line_format = self.COMMENT_LINE_FORMAT:format(padding_len)
	local text_line_format = self.TEXT_LINE_FORMAT:format(
		left_text_padding_len,
		right_text_padding_len
	)

	local comment_line = comment_line_format:format(
		self.start_str,
		'',
		self.end_str
	):gsub(' ', self.fill_char)

	local text_line = text_line_format:format(
		self.start_str,
		'',
		text,
		'',
		self.end_str
	)

	return {
		comment_line,
		text_line,
		comment_line
	}
end

return Comment
