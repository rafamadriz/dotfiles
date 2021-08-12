require("vis")
require("commentary")

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options
	vis:command("set autoindent on")
	vis:command("set escdelay 0")
	vis:command("set tabwidth 4")
	vis:command("set ignorecase")
	vis:command("set expandtab")
	vis:command("set theme gruvbox")
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	-- Your per window configuration options
	vis:command("set number")
	vis:command("set relativenumbers")
	vis:command("set cursorline")
end)

-- not sure of what this does.
-- vis:map(vis.modes.NORMAL, "<Escape>", function()
	-- if vis.count then
		-- vis.count = nil
	-- else
		-- vis:feedkeys("<vis-selections-remove-all>")
	-- end
-- end)

vis:command_register("fzf", function(argv, force, cur_win, selection, range)
	local out = io.popen("fzf"):read()
	if out then
		if argv[1] then
			vis:command(string.format('e "%s"', out))
		else
			vis:command(string.format('open "%s"', out))
		end
		vis:feedkeys("<vis-redraw>")
	end
end, "fuzzy file search")

vis:command_register("sts", function(argv, force, win, selection, range)
	local lines = win.file.lines
	for index = 1, #lines do
		lines[index] = lines[index]:gsub("%s+$", "")
	end
	return true
end, "Strip line trailing spaces")

