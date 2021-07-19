local String = {}

-- Returns an array of strings splitted by given pattern
function String.split(str, pattern)
	local lines = {}

	for s in str:gmatch(pattern) do
		table.insert(lines, s)
	end

	return lines
end

function String.trim(str)
	return str:gsub('^%s+', ''):gsub('%s+$', '')
end

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
		if (str:len() <= wrap_len) then
			return str:len()
		end

		-- if non of the above criteria are a match, then we need to find the
		-- last word
		local last_space_index = 1

		while true do
			local index = last_space_index

			if last_space_index ~= 1 then
				index = index + 1
			end

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

	for _, line in ipairs(String.wrap_lines(str:sub(break_point + 1), wrap_len) or {}) do
		table.insert(lines, line)
	end

	return lines
end

 return {
	 String = String
 }
