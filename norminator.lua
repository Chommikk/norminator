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
    text = text:gsub("__PLUSPLUS__", "++")
    text = text:gsub("__MINUSMINUS__", "--")
    text = text:gsub("__PLUSEQUAL__", "+=")
    text = text:gsub("__MINUSEQUAL__", "-=")
    text = text:gsub("__EQEQ__", "==")
    text = text:gsub("__NOTEQ__", "!=")
    text = text:gsub("__ANDAND__", "&&")
    text = text:gsub("__OROR__", "||")

    return text
end


-- this puts spaces  after spesific keys
local function return_of_the_spaces_2_electric_boogaloo(text)
	local result = text:gsub("while","while ")
	result = result:gsub("if","if ")
	result = result:gsub("else","else ")
	result = result:gsub("return","return ")
	return result
end



--this funcion will be called with keybind 
local function norming()
	local lines = vim.api.nvim_buf_get_lines(0,0,-1,false)
	local text = table.concat(lines,"\n") .."\n"
	
	--removing tabs and spaces
	text = tab_space_slayer(text)
	
	--removing empty lines
	text = lines_begone(text)
	
	--adding spaces 
	text = return_of_the_spaces(text)
	
	-- adding more spaces
	text = return_of_the_spaces_2_electric_boogaloo(text)

	-- returning to file
	--	this returns the normed_text into lines
	local normed_text ={}
    for line in text:gmatch("[^\n]+") do
        table.insert(normed_text, line)
    end
	-- this will return normed_lines to buffer
	vim.api.nvim_buf_set_lines(0,0,-1,false,normed_text)
end










-- keymaping currently to f2
vim.keymap.set('n','<F3>',norming,{noremap = true, silent = true})
