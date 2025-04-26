-- this gets rid of tabs and spaces

local function tab_space_slayer(text)
	local result = text:gsub("[ \t]","")
	return result
end


-- this puts spaces before and after spesific keys
local function return_of_the_spaces(text)
	local result = text:gsub("+"," + ")
	result = text:gsub("-"," - ")
	result = text:gsub("="," = ")
	result = text:gsub("/"," / ")
	result = text:gsub(" +  + "," ++ ")
	result = text:gsub(" -  - "," -- ")
	return result
end

-- this puts spaces  after spesific keys
local function return_of_the_spaces_2_electric_boogaloo(text)
	local result = text:gsub("while","while ")
	result = text:gsub("if","if ")
	result = text:gsub("else","else ")
	result = text:gsub("return","return ")
	result = text:gsub(" +  + "," ++ ")
	result = text:gsub(" -  - "," -- ")
	return result
end



--this funcion will be called with keybind 
local function norming()
	local lines = vim.api.nvim_buf_get_lines(0,0,-1,false)
	local text = table.concat(lines,"\n") .."\n"
	--removing tabs and spaces
	text = tab_space_slayer(text)
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
vim.keymap.set('n','<F2>',norming,{noremap = true, silent = true})
