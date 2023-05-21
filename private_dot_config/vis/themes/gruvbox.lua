-- Gruvbox color scheme by Pavel Pertsev (https://github.com/morhetz)
-- For the Vis text editor by Marc Tanner (https://github.com/martanne)

-- Set to 'dark' or 'light'
local mode	= 'dark'
-- Set to 'hard', 'medium', or 'soft'
local contrast	= 'medium'

local gruvbox = {
	dark0h	= '#1d2021',
	dark0	= '#282828',
	dark0s	= '#32302f',
	dark1	= '#3c3836',
	dark2	= '#504945',
	dark3	= '#665c54',
	dark4	= '#7c6f64',
	light0h	= '$f9f5d7',
	light0	= '#fbf1c7',
	light0s	= '#f2e5bc',
	light1	= '#ebdbb2',
	light2	= '#d5c4a1',
	light3	= '#bdae93',
	light4	= '#a89984',
	gray	= '#928374',
	red0	= '#fb4934',
	red1	= '#9d0006',
	green0	= '#b8bb26',
	green1	= '#79740e',
	yellow0	= '#fabd2f',
	yellow1	= '#b57614',
	blue0	= '#83a598',
	blue1	= '#076678',
	purple0	= '#d3869b',
	purple1	= '#8f3f71',
	aqua0	= '#8ec07c',
	aqua1	= '#427b58',
	orange0	= '#fe8019',
	orange1	= '#af3a03',
}

local colors = {}

if mode == 'dark' then
	if contrast == 'hard' then
		colors.bg0 = gruvbox.dark0h
	elseif contrast == 'medium' then
		colors.bg0 = gruvbox.dark0
	elseif contrast == 'soft' then
		colors.bg0 = gruvbox.dark0s
	end
	colors.bg1	= gruvbox.dark1
	colors.bg2	= gruvbox.dark2
	colors.bg3	= gruvbox.dark3
	colors.bg4	= gruvbox.dark4
	colors.fg0	= gruvbox.light0
	colors.fg1	= gruvbox.light1
	colors.fg2	= gruvbox.light2
	colors.fg3	= gruvbox.light3
	colors.fg4	= gruvbox.light4
	colors.gray	= gruvbox.gray
	colors.red	= gruvbox.red0
	colors.green	= gruvbox.green0
	colors.yellow	= gruvbox.yellow0
	colors.blue	= gruvbox.blue0
	colors.purple	= gruvbox.purple0
	colors.aqua	= gruvbox.aqua0
	colors.orange	= gruvbox.orange0
elseif mode == 'light' then
	if contrast == 'hard' then
		colors.bg0 = gruvbox.light0h
	elseif contrast == 'medium' then
		colors.bg0 = gruvbox.light0
	elseif contrast == 'soft' then
		colors.bg0 = gruvbox.light0s
	end
	colors.bg1	= gruvbox.light1
	colors.bg2	= gruvbox.light2
	colors.bg3	= gruvbox.light3
	colors.bg4	= gruvbox.light4
	colors.fg0	= gruvbox.dark0
	colors.fg1	= gruvbox.dark1
	colors.fg2	= gruvbox.dark2
	colors.fg3	= gruvbox.dark3
	colors.fg4	= gruvbox.dark4
	colors.gray	= gruvbox.gray
	colors.red	= gruvbox.red1
	colors.green	= gruvbox.green1
	colors.yellow	= gruvbox.yellow1
	colors.blue	= gruvbox.blue1
	colors.purple	= gruvbox.purple1
	colors.aqua	= gruvbox.aqua1
	colors.orange	= gruvbox.orange1
end

-- To use your terminal's default background (e.g. for transparency), set the value below to 'back:default,fore:'..colors.fg1
vis.lexers.STYLE_DEFAULT		= 'back:'..colors.bg0..',fore:'..colors.fg1
vis.lexers.STYLE_NOTHING		= ''
vis.lexers.STYLE_CLASS			= 'fore:'..colors.yellow
vis.lexers.STYLE_COMMENT		= 'fore:'..colors.gray..',italics'
vis.lexers.STYLE_CONSTANT		= 'fore:'..colors.purple
vis.lexers.STYLE_DEFINITION		= 'fore:'..colors.yellow
vis.lexers.STYLE_ERROR			= 'fore:'..colors.red..',back:'..colors.bg0..',reverse'
vis.lexers.STYLE_FUNCTION		= 'fore:'..colors.green..',bold'
vis.lexers.STYLE_KEYWORD		= 'fore:'..colors.red
vis.lexers.STYLE_LABEL			= 'fore:'..colors.red
vis.lexers.STYLE_NUMBER			= 'fore:'..colors.purple
vis.lexers.STYLE_OPERATOR		= vis.lexers.STYLE_DEFAULT
vis.lexers.STYLE_REGEX			= 'fore:'..colors.aqua
vis.lexers.STYLE_STRING			= 'fore:'..colors.green
vis.lexers.STYLE_PREPROCESSOR		= 'fore:'..colors.aqua
vis.lexers.STYLE_TAG			= 'fore:'..colors.blue
vis.lexers.STYLE_TYPE			= 'fore:'..colors.yellow
vis.lexers.STYLE_VARIABLE		= 'fore:'..colors.blue
vis.lexers.STYLE_WHITESPACE		= ''
vis.lexers.STYLE_EMBEDDED		= 'fore:'..colors.orange
vis.lexers.STYLE_IDENTIFIER		= 'fore:'..colors.blue

vis.lexers.STYLE_LINENUMBER		= 'fore:'..colors.bg4
vis.lexers.STYLE_LINENUMBER_CURSOR	= 'fore:'..colors.yellow..',back:'..colors.bg1
vis.lexers.STYLE_CURSOR			= 'reverse'
vis.lexers.STYLE_CURSOR_PRIMARY		= vis.lexers.STYLE_CURSOR..',fore:'..colors.yellow
vis.lexers.STYLE_CURSOR_LINE		= 'back:'..colors.bg1
vis.lexers.STYLE_COLOR_COLUMN		= 'reverse'
vis.lexers.STYLE_SELECTION		= 'back:'..colors.bg3..',reverse'
vis.lexers.STYLE_STATUS			= 'fore:'..colors.bg1..',back:'..colors.fg4..',reverse'
vis.lexers.STYLE_STATUS_FOCUSED		= 'fore:'..colors.bg2..',back:'..colors.fg1..',reverse'
vis.lexers.STYLE_SEPARATOR		= 'fore:'..colors.bg3
vis.lexers.STYLE_INFO			= 'fore:'..colors.yellow..',bold'
vis.lexers.STYLE_EOF			= vis.lexers.STYLE_LINENUMBER
