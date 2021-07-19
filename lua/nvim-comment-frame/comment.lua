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

function Comment:validate_config(opt)
	-- if the end_str is not passed, start_str will be used
	opt.end_str = opt.end_str or opt.start_str

	Assert.String.is_str(opt.start_str, "start_str should be a string")
	Assert.String.is_str(opt.end_str, "end_str should be a string")
	Assert.String.is_str(opt.fill_char, "fill_char should be a single character string")

	Assert.String.is_not_empty(opt.start_str, "start_str shouldn't be empty")
	Assert.String.is_not_empty(opt.end_str, "end_str should't be empty")

	Assert.String.is_char(opt.fill_char, "fill_char should be a single character")

	Assert.Number.is_number(opt.box_width, "box_width should be a number")
	Assert.Number.is_number(opt.word_wrap_len, "word_wrap should be a number")

	local padding = opt.box_width - (opt.start_str:len() + opt.end_str:len())

	Assert.is_true(
		opt.word_wrap_len <= padding,
		"word_wrap should be less than or equal to " .. padding
	)
end

function Comment:get_comment(text)
	Assert.String.is_not_empty(text, "comment text shouldn't be empty")

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

	local lines = {}

	local comment_line = comment_line_format:format(
		self.start_str,
		'',
		self.end_str
	):gsub(' ', self.fill_char)

	table.insert(lines, comment_line)

	for _, line in ipairs(Util.String.wrap_lines(text, self.word_wrap_len)) do
		local text_line = text_line_format:format(
			self.start_str,
			'',
			line,
			'',
			self.end_str
		)

		table.insert(lines, text_line)
	end

	table.insert(lines, comment_line)

	for _, i in ipairs(lines) do
		print(i)
	end

	return lines
end

return Comment
