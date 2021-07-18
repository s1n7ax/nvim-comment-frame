local String = {}

function String.is_str(value, message)
	message = message or 'value is not a string'

	if type(value) ~= 'string' then
		error(message)
	end
end

function String.is_not_empty(str, message)
	message = message or 'string is empty'
	String.is_str(str)

	if str:len() < 1 then
		error(message)
	end
end

function String.is_char(str, message)
	message = message or 'string is not a char'
	String.is_str(str)

	if str:len(str) ~= 1 then
		error(message)
	end
end

local Number = {}

function Number.is_number(value, message)
	message = message or 'value is not a number'

	if type(value) ~= 'number' then
		error(message)
	end
end

return {
	String = String,
	Number = Number
}
