-- IMPORTS
local vim = vim
local mode = vim.fn.mode
local galaxyline = require("galaxyline")
local section = galaxyline.section

-- CONSTANTS
-- Defined in https://github.com/Iron-E/nvim-highlite
local _COLORS = {
    black = {"#202020", 0, "black"},
    gray = {"#808080", 244, "gray"},
    gray_dark = {"#353535", 236, "darkgrey"},
    gray_darker = {"#505050", 244, "gray"},
    gray_light = {"#c0c0c0", 251, "gray"},
    white = {"#ffffff", 15, "white"},
    tan = {"#f4c069", 180, "darkyellow"},
    red = {"#ee4a59", 196, "red"},
    red_dark = {"#a80000", 124, "darkred"},
    red_light = {"#ff4090", 203, "red"},
    orange = {"#ff8900", 208, "darkyellow"},
    orange_light = {"#f0af00", 214, "yellow"},
    yellow = {"#f0df33", 220, "yellow"},
    green = {"#77ff00", 72, "green"},
    green_dark = {"#35de60", 83, "darkgreen"},
    green_light = {"#a0ff70", 72, "green"},
    blue = {"#7090ff", 63, "darkblue"},
    cyan = {"#33efff", 87, "cyan"},
    ice = {"#49a0f0", 63, "cyan"},
    teal = {"#00d0c0", 38, "cyan"},
    turqoise = {"#2bff99", 33, "blue"},
    magenta = {"#cc0099", 126, "magenta"},
    pink = {"#ffa6ff", 162, "magenta"},
    purple = {"#cf55f0", 129, "magenta"},
    magenta_dark = {"#bb0099", 126, "darkmagenta"},
    pink_light = {"#ffb7b7", 38, "white"},
    purple_light = {"#af60af", 63, "magenta"}
}

_COLORS.bar = {middle = _COLORS.gray_dark, side = _COLORS.black}
_COLORS.text = _COLORS.gray_light

-- hex color subtable
local _HEX_COLORS =
    setmetatable(
    {
        ["bar"] = setmetatable(
            {},
            {
                ["__index"] = function(_, key)
                    return _COLORS.bar[key] and _COLORS.bar[key][1] or nil
                end
            }
        )
    },
    {
        ["__index"] = function(_, key)
            local color = _COLORS[key]
            return color and color[1] or nil
        end
    }
)

local _MODES = {
    ["c"] = {"COMMAND-LINE", _COLORS.red},
    ["ce"] = {"NORMAL EX", _COLORS.red_dark},
    ["cv"] = {"EX", _COLORS.red_light},
    ["i"] = {"INSERT", _COLORS.green},
    ["ic"] = {"INS-COMPLETE", _COLORS.green_light},
    ["n"] = {"NORMAL", _COLORS.purple_light},
    ["no"] = {"OPERATOR-PENDING", _COLORS.purple},
    ["r"] = {"HIT-ENTER", _COLORS.cyan},
    ["r?"] = {":CONFIRM", _COLORS.cyan},
    ["rm"] = {"--MORE", _COLORS.cyan},
    ["R"] = {"REPLACE", _COLORS.pink},
    ["Rv"] = {"VIRTUAL", _COLORS.pink},
    ["s"] = {"SELECT", _COLORS.turqoise},
    ["S"] = {"SELECT", _COLORS.turqoise},
    [""] = {"SELECT", _COLORS.turqoise},
    ["t"] = {"TERMINAL", _COLORS.orange},
    ["v"] = {"VISUAL", _COLORS.blue},
    ["V"] = {"VISUAL LINE", _COLORS.blue},
    [""] = {"VISUAL BLOCK", _COLORS.blue},
    ["!"] = {"SHELL", _COLORS.yellow},
    -- libmodal
    ["TABS"] = _COLORS.tan,
    ["BUFFERS"] = _COLORS.teal,
    ["TABLES"] = _COLORS.orange_light
}

local _SEPARATORS = {
    left = "",
    right = ""
}

--[[
	/*
	 * PROVIDERS
	 */
--]]
local function all(...)
    local args = {...}
    return function()
        for _, fn in ipairs(args) do
            if not fn() then
                return false
            end
        end
        return true
    end
end

local function buffer_not_empty()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
end

local function checkwidth()
    return (vim.fn.winwidth(0) / 2) > 40
end

local function find_git_root()
    return require("galaxyline/provider_vcs").get_git_dir(vim.fn.expand("%:p:h"))
end

local function get_file_icon_color()
    return require("galaxyline/provider_fileinfo").get_file_icon_color()
end

local function printer(str)
    return function()
        return str
    end
end

local function negated(fn)
    return function()
        return not fn()
    end
end

local space = printer(" ")

--[[
	/*
	 * GALAXYLINE CONFIG
	 */
--]]
galaxyline.short_line_list = {
    "diff",
    "undotree",
    "NvimTree",
    "startify",
    "packer",
    "packager",
    "FloaTerm",
    "toggleterm"
}

section.left = {
    {
        ViMode = {
            provider = function()
                -- auto change color according the vim mode
                local mode_color = nil
                local mode_name = nil

                if vim.g.libmodalActiveModeName then
                    mode_name = vim.g.libmodalActiveModeName
                    mode_color = _MODES[mode_name]
                else
                    local current_mode = _MODES[mode(true)] or _MODES[mode(false)]

                    mode_name = current_mode[1]
                    mode_color = current_mode[2]
                end

                require("highlite").highlight("GalaxyViMode", {fg = mode_color, style = "bold"})

                return mode_name .. " "
            end,
            icon = "▊ ",
            highlight = {_HEX_COLORS.bar.side, _HEX_COLORS.bar.side},
            separator = _SEPARATORS.right,
            separator_highlight = {_HEX_COLORS.bar.side, get_file_icon_color}
        }
    },
    {
        FileIcon = {
            provider = {space, "FileIcon"},
            highlight = {_HEX_COLORS.bar.side, get_file_icon_color},
            separator = _SEPARATORS.left,
            separator_highlight = {_HEX_COLORS.bar.side, get_file_icon_color}
        }
    },
    {
        FileName = {
            provider = {space, "FileName", "FileSize"},
            condition = buffer_not_empty,
            highlight = {_HEX_COLORS.text, _HEX_COLORS.bar.side, "bold"}
        }
    },
    {
        GitSeparator = {
            provider = printer(_SEPARATORS.right),
            condition = find_git_root,
            highlight = {_HEX_COLORS.bar.side, _HEX_COLORS.green_dark}
        }
    },
    {
        GitBranch = {
            provider = "GitBranch",
            icon = "   ",
            condition = find_git_root,
            highlight = {_HEX_COLORS.bar.side, _HEX_COLORS.green_dark, "bold"},
            separator = _SEPARATORS.left,
            separator_highlight = {_HEX_COLORS.bar.middle, _HEX_COLORS.green_dark}
        }
    },
    {
        LeftEnd = {
            provider = printer(_SEPARATORS.left),
            condition = negated(find_git_root),
            highlight = {_HEX_COLORS.bar.middle, find_git_root() and _HEX_COLORS.green_dark or _HEX_COLORS.bar.side}
        }
    },
    {
        DiffAdd = {
            provider = "DiffAdd",
            condition = all(checkwidth, find_git_root),
            icon = "+",
            highlight = {_HEX_COLORS.green_light, _HEX_COLORS.bar.middle}
        }
    },
    {
        DiffModified = {
            provider = "DiffModified",
            condition = checkwidth,
            icon = "~",
            highlight = {_HEX_COLORS.orange_light, _HEX_COLORS.bar.middle}
        }
    },
    {
        DiffRemove = {
            provider = "DiffRemove",
            condition = checkwidth,
            icon = "-",
            highlight = {_HEX_COLORS.red_light, _HEX_COLORS.bar.middle}
        }
    },
    {
        DiagnosticError = {
            provider = "DiagnosticError",
            icon = "Ⓧ ",
            highlight = {_HEX_COLORS.red, _HEX_COLORS.bar.middle},
            separator = " ",
            separator_highlight = {_HEX_COLORS.bar.middle, _HEX_COLORS.bar.middle}
        }
    },
    {
        DiagnosticWarn = {
            provider = "DiagnosticWarn",
            icon = "⚠️ ",
            highlight = {_HEX_COLORS.yellow, _HEX_COLORS.bar.middle},
            separator = " ",
            separator_highlight = {_HEX_COLORS.bar.middle, _HEX_COLORS.bar.middle}
        }
    },
    {
        DiagnosticHint = {
            provider = "DiagnosticHint",
            icon = "💡",
            highlight = {_HEX_COLORS.magenta, _HEX_COLORS.bar.middle},
            separator = " ",
            separator_highlight = {_HEX_COLORS.bar.middle, _HEX_COLORS.bar.middle}
        }
    },
    {
        DiagnosticInfo = {
            provider = "DiagnosticInfo",
            icon = "ⓘ ",
            highlight = {_HEX_COLORS.white, _HEX_COLORS.bar.middle},
            separator = " ",
            separator_highlight = {_HEX_COLORS.bar.middle, _HEX_COLORS.bar.middle}
        }
    }
} -- section.left

section.right = {
    {
        Vista = {
            provider = "VistaPlugin",
            condition = function()
                return vim.fn.exists(":Vista") ~= 0
            end,
            highlight = {_HEX_COLORS.text, _HEX_COLORS.bar.middle}
        }
    },
    {
        RightBegin = {
            provider = space,
            highlight = {_HEX_COLORS.bar.middle, _HEX_COLORS.bar.side},
            separator = _SEPARATORS.right,
            separator_highlight = {_HEX_COLORS.bar.middle, _HEX_COLORS.bar.side}
        }
    },
    {
        FileFormat = {
            provider = {"FileFormat", space},
            highlight = {_HEX_COLORS.text, _HEX_COLORS.bar.side}
        }
    },
    {
        FileType = {
            provider = "FileTypeName",
            highlight = {_HEX_COLORS.black, get_file_icon_color, "bold"},
            separator = _SEPARATORS.left,
            separator_highlight = {get_file_icon_color, _HEX_COLORS.bar.side}
        }
    },
    {
        FileSep = {
            provider = printer(_SEPARATORS.right),
            highlight = {get_file_icon_color, _HEX_COLORS.bar.side}
        }
    },
    {
        LineNumber = {
            provider = function()
                return vim.fn.line(".")
            end,
            icon = " ",
            condition = buffer_not_empty,
            highlight = {_HEX_COLORS.text, _HEX_COLORS.bar.side},
            separator = " ",
            separator_highlight = {_HEX_COLORS.bar.side, _HEX_COLORS.bar.side}
        },
        ColumnNumber = {
            provider = function()
                return vim.fn.col(".")
            end,
            icon = " ",
            condition = buffer_not_empty,
            highlight = {_HEX_COLORS.text, _HEX_COLORS.bar.side},
            separator = " ",
            separator_highlight = {_HEX_COLORS.bar.side, _HEX_COLORS.bar.side}
        }
    },
    {
        PerCentSeparator = {
            provider = printer(_SEPARATORS.left),
            highlight = {_HEX_COLORS.magenta_dark, _HEX_COLORS.bar.side},
            separator = " ",
            separator_highlight = {_HEX_COLORS.bar.side, _HEX_COLORS.bar.side}
        }
    },
    {
        PerCent = {
            provider = "LinePercent",
            highlight = {_HEX_COLORS.white, _HEX_COLORS.magenta_dark}
        }
    },
    {
        ScrollBar = {
            provider = "ScrollBar",
            highlight = {_HEX_COLORS.gray, _HEX_COLORS.magenta_dark}
        }
    }
} -- section.right

section.short_line_left = {
    {
        BufferType = {
            provider = {space, space, "FileTypeName", space},
            highlight = {_HEX_COLORS.black, _HEX_COLORS.purple, "bold"},
            separator = _SEPARATORS.right,
            separator_highlight = {_HEX_COLORS.purple, _HEX_COLORS.bar.middle}
        }
    }
}

section.short_line_right = {
    {
        BufferIcon = {
            provider = "BufferIcon",
            highlight = {_HEX_COLORS.black, _HEX_COLORS.purple, "bold"},
            separator = _SEPARATORS.left,
            separator_highlight = {_HEX_COLORS.purple, _HEX_COLORS.bar.middle}
        }
    }
}
