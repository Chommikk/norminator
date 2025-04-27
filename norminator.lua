
-- helper funcion for belowe this formats the types in funcion definition output
local function tab_in_decleration(text)
	text = text:gsub("int", "int\t")
	text = text:gsub("char", "char\t")
	text = text:gsub("void", "void\t")
	text = text:gsub("size_t", "size_t\t")
--	text = text:gsub("int", "int\t")
	return text
end

-- this puts tab after type in funcion declarations
local function typenito_funcionato_declerato(text)
	local result = ""
	local last_end = 1

	for start_pos, end_pos in text:gmatch("()%b{}()") do
		local before = text:sub(last_end, start_pos - 1)
		result = result .. tab_in_decleration(before)
		local inside = text:sub(start_pos, end_pos - 1)
		result = result .. inside
		last_end = end_pos
	end
	result = result .. tab_in_decleration(text:sub(last_end))
	return result
end
-- figure out types how to do tham differently in () 
-- and in funcions and in funcion definitions
local function typenito_isido_funcionito(text)
	local result = text:gsub("%b()", function(match)
		local inside = match
		inside = inside:gsub("int\t", "int ")
		inside = inside:gsub("char\t", "char ")
		inside = inside:gsub("void\t", "void ")
		inside = inside:gsub("size_t\t", "size_t ")
		inside = inside:gsub("const", "const ")
		inside = inside:gsub("unsigned", "unsigned ")
		inside = inside:gsub("long", "long ")
		inside = inside:gsub("float", "const ")
		return inside
	end)
	return result
end

-- this gets rid of tabs and spaces

local function tab_space_slayer(text)
	local result = text:gsub("[ \t]","")
	return result
end


--  getting rid of empty lines
local function lines_begone(text)
	local result = text:gsub(";",";\n")
	result = result:gsub("\n\n","\n")
	return result
end

-- this puts spaces before and after spesific keys
local function return_of_the_spaces(text)
    -- Protect special operators first
    text = text:gsub("(%+%+)", "__PLUSPLUS__")
    text = text:gsub("%-%-", "__MINUSMINUS__")
    text = text:gsub("%+=", "__PLUSEQUAL__")
    text = text:gsub("%-=", "__MINUSEQUAL__")
    text = text:gsub("==", "__EQEQ__")
    text = text:gsub("!=", "__NOTEQ__")
    text = text:gsub("&&", "__ANDAND__")
    text = text:gsub("||", "__OROR__")

    -- Add spaces around basic operators (+, -, /)
    text = text:gsub("([%w%)])%s*([%+%-%/])%s*([%w%(])", "%1 %2 %3")
	text = text:gsub("=", " = ")
    -- Restore the protected operators
    text = text:gsub("__PLUSPLUS__", " ++ ")
    text = text:gsub("__MINUSMINUS__", " -- ")
    text = text:gsub("__PLUSEQUAL__", " += ")
    text = text:gsub("__MINUSEQUAL__", " -= ")
    text = text:gsub("__EQEQ__", " == ")
    text = text:gsub("__NOTEQ__", " != ")
    text = text:gsub("__ANDAND__", " && ")
    text = text:gsub("__OROR__", " || ")

    return text
end


-- this puts spaces  after spesific keys
local function return_of_the_spaces_2_electric_boogaloo(text)
	local result = text:gsub("\nwhile","\nwhile ")
	result = result:gsub("\nif","\nif ")
	result = result:gsub("\nelse","\nelse ")
	result = result:gsub("\nelseif","\nelse if ")
	result = result:gsub("\nreturn","\nreturn ")
	result = result:gsub(",",", ")
	result = result:gsub("%["," %[")
	result = result:gsub("%[ ","%[")
	return result
end



--this funcion will be called with keybind 
local function norming()
	local header = vim.api.nvim_buf_get_lines(0,0,11,false) 
-- need to figure out how to ignore header
	local lines = vim.api.nvim_buf_get_lines(0,11,-1,false)
	local text = table.concat(lines,"\n") .."\n"
	
	--removing tabs and spaces
	text = tab_space_slayer(text)
	
	--removing empty lines
	text = lines_begone(text)
	
	--adding spaces 
	text = return_of_the_spaces(text)
	
	-- adding more spaces
	text = return_of_the_spaces_2_electric_boogaloo(text)

	-- formating types in declaring funions return type
	text = typenito_funcionato_declerato(text)
	
	-- formaating types inside of () funcion declarations
	text = typenito_isido_funcionito(text)

-- returning to file

	--	this returns the normed_text into lines
	local normed_text ={}
	for _,line in ipairs(header) do
		table.insert(normed_text, line)
	end
    for line in text:gmatch("[^\n]+") do
        table.insert(normed_text, line)
    end
	-- this will return normed_lines to buffer
	vim.api.nvim_buf_set_lines(0,0,-1,false,normed_text)
end










-- keymaping currently to f2
vim.keymap.set('n','<F3>',norming,{noremap = true, silent = true})
