-- https://github.com/lutobler/vis-commentary/blob/master/init.lua
local comment_string = {
	actionscript = "//",
	ada = "--",
	ansi_c = "/*|*/",
	antlr = "//",
	apdl = "!",
	apl = "#",
	applescript = "--",
	asp = "'",
	autoit = ";",
	awk = "#",
	b_lang = "//",
	bash = "#",
	batch = ":",
	bibtex = "%",
	boo = "#",
	chuck = "//",
	cmake = "#",
	coffeescript = "#",
	context = "%",
	cpp = "//",
	crystal = "#",
	csharp = "//",
	css = "/*|*/",
	cuda = "//",
	dart = "//",
	desktop = "#",
	django = "{#|#}",
	dmd = "//",
	dockerfile = "#",
	dot = "//",
	eiffel = "--",
	elixir = "#",
	erlang = "%",
	faust = "//",
	fish = "#",
	forth = "|\\",
	fortran = "!",
	fsharp = "//",
	gap = "#",
	gettext = "#",
	gherkin = "#",
	glsl = "//",
	gnuplot = "#",
	go = "//",
	groovy = "//",
	gtkrc = "#",
	haskell = "--",
	html = "<!--|-->",
	icon = "#",
	idl = "//",
	inform = "!",
	ini = "#",
	Io = "#",
	java = "//",
	javascript = "//",
	json = "/*|*/",
	jsp = "//",
	latex = "%",
	ledger = "#",
	less = "//",
	lilypond = "%",
	lisp = ";",
	logtalk = "%",
	lua = "--",
	makefile = "#",
	markdown = "<!--|-->",
	matlab = "#",
	moonscript = "--",
	myrddin = "//",
	nemerle = "//",
	nsis = "#",
	objective_c = "//",
	pascal = "//",
	perl = "#",
	php = "//",
	pico8 = "//",
	pike = "//",
	pkgbuild = "#",
	prolog = "%",
	props = "#",
	protobuf = "//",
	ps = "%",
	pure = "//",
	python = "#",
	rails = "#",
	rc = "#",
	rebol = ";",
	rest = ".. ",
	rexx = "--",
	rhtml = "<!--|-->",
	rstats = "#",
	ruby = "#",
	rust = "//",
	sass = "//",
	scala = "//",
	scheme = ";",
	smalltalk = '"|"',
	sml = "(*)",
	snobol4 = "#",
	sql = "#",
	tcl = "#",
	tex = "%",
	text = "",
	toml = "#",
	vala = "//",
	vb = "'",
	vbscript = "'",
	verilog = "//",
	vhdl = "--",
	wsf = "<!--|-->",
	xml = "<!--|-->",
	yaml = "#",
}

-- escape all magic characters with a '%'
local function esc(str)
	if not str then
		return ""
	end
	return (
			str
				:gsub("%%", "%%%%")
				:gsub("^%^", "%%^")
				:gsub("%$$", "%%$")
				:gsub("%(", "%%(")
				:gsub("%)", "%%)")
				:gsub("%.", "%%.")
				:gsub("%[", "%%[")
				:gsub("%]", "%%]")
				:gsub("%*", "%%*")
				:gsub("%+", "%%+")
				:gsub("%-", "%%-")
				:gsub("%?", "%%?")
		)
end

-- escape '%'
local function pesc(str)
	if not str then
		return ""
	end
	return str:gsub("%%", "%%%%")
end

function rtrim(s)
	local n = #s
	while n > 0 and s:find("^%s", n) do
		n = n - 1
	end
	return s:sub(1, n)
end

local function comment_line(lines, lnum, prefix, suffix)
	if suffix ~= "" then
		suffix = " " .. suffix
	end
	lines[lnum] = string.gsub(lines[lnum], "(%s*)(.*)", "%1" .. pesc(prefix) .. " %2" .. pesc(suffix))
end

local function uncomment_line(lines, lnum, prefix, suffix)
	local match_str = "^(%s*)" .. esc(prefix) .. "%s?(.*)" .. esc(suffix)
	m = table.pack(lines[lnum]:match(match_str))
	lines[lnum] = m[1] .. rtrim(m[2])
end

local function is_comment(line, prefix)
	return (line:match("^%s*(.+)"):sub(0, #prefix) == prefix)
end

local function toggle_line_comment(lines, lnum, prefix, suffix)
	if not lines or not lines[lnum] then
		return
	end
	if not lines[lnum]:match("^%s*(.+)") then
		return
	end -- ignore empty lines
	if is_comment(lines[lnum], prefix) then
		uncomment_line(lines, lnum, prefix, suffix)
	else
		comment_line(lines, lnum, prefix, suffix)
	end
end

-- if one line inside the block is not a comment, comment the block.
-- only uncomment, if every single line is comment.
local function block_comment(lines, a, b, prefix, suffix)
	local uncomment = true
	for i = a, b do
		if lines[i]:match("^%s*(.+)") and not is_comment(lines[i], prefix) then
			uncomment = false
		end
	end

	if uncomment then
		for i = a, b do
			if lines[i]:match("^%s*(.+)") then
				uncomment_line(lines, i, prefix, suffix)
			end
		end
	else
		for i = a, b do
			if lines[i]:match("^%s*(.+)") then
				comment_line(lines, i, prefix, suffix)
			end
		end
	end
end

vis:map(vis.modes.NORMAL, "gcc", function()
	local win = vis.win
	local lines = win.file.lines
	local comment = comment_string[win.syntax]
	if not comment then
		return
	end
	local prefix, suffix = comment:match("^([^|]+)|?([^|]*)$")
	if not prefix then
		return
	end

	for sel in win:selections_iterator() do
		local lnum = sel.line
		local col = sel.col

		toggle_line_comment(lines, lnum, prefix, suffix)
		sel:to(lnum, col) -- restore cursor position
	end

	win:draw()
end, "Toggle comment on a the current line")

local function visual_f(i)
	return function()
		local win = vis.win
		local lines = win.file.lines

		local comment = comment_string[win.syntax]
		if not comment then
			return
		end

		local prefix, suffix = comment:match("^([^|]+)|?([^|]*)$")
		if not prefix then
			return
		end

		for sel in win:selections_iterator() do
			local r = sel.range
			local lnum = sel.line -- line number of cursor
			local col = sel.col -- column of cursor

			if sel.anchored and r then
				sel.pos = r.start
				local a = sel.line
				sel.pos = r.finish
				local b = sel.line - i

				block_comment(lines, a, b, prefix, suffix)

				sel:to(lnum, col) -- restore cursor position
			end
		end

		win:draw()
		vis.mode = vis.modes.NORMAL -- go to normal mode
	end
end

vis:map(vis.modes.VISUAL_LINE, "gc", visual_f(1), "Toggle comment on the selected lines")
vis:map(vis.modes.VISUAL, "gc", visual_f(0), "Toggle comment on the selected lines")
