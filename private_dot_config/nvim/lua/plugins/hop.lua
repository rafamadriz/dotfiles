local hop = require 'hop'
local hint = require 'hop.hint'
local after = hint.HintDirection.AFTER_CURSOR
local before = hint.HintDirection.BEFORE_CURSOR

hop.setup()

as.nnoremap('f', function() hop.hint_char1 { direction = after, current_line_only = true } end)
as.nnoremap('F', function() hop.hint_char1 { direction = before, current_line_only = true } end)
as.onoremap('f', function() hop.hint_char1 { direction = after, current_line_only = true, inclusive_jump = true } end)
as.onoremap('F', function() hop.hint_char1 { direction = before, current_line_only = true, inclusive_jump = true } end)
as.nnoremap('t', function() hop.hint_char1 { direction = after, current_line_only = true } end)
as.nnoremap('T', function() hop.hint_char1 { direction = before, current_line_only = true } end)
as.nmap('S', function() hop.hint_char2() end)
