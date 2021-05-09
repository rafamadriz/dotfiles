local M = {}

M.b = vim.b
M.vi_mode_utils = require("feline.providers.vi_mode")
M.lsp = require("feline.providers.lsp")

if Theming.statusline_color == nil or Theming.statusline_color:gsub("%s+", "") == "" then
    M.status_color = "nord"
else
    M.status_color = Theming.statusline_color:gsub("%s+", "")
end

M.properties = {
    force_inactive = {
        filetypes = {},
        buftypes = {},
        bufnames = {}
    }
}

M.properties.force_inactive.filetypes = {
    "NvimTree",
    "packer",
    "startify",
    "toggleterm"
}

M.properties.force_inactive.buftypes = {
    "terminal"
}

M.icons = {
    locker = "", -- #f023
    confirm = "✓",
    page = "☰", -- 2630
    line_number = "", -- e0a1
    connected = "", -- f817
    dos = "", -- e70f
    unix = "", -- f17c
    mac = "", -- f179
    mathematical_L = "𝑳",
    vertical_bar = "┃",
    vertical_bar_thin = "│",
    left = "",
    right = "",
    block = "█",
    left_filled = "",
    right_filled = "",
    slant_left = "",
    slant_left_thin = "",
    slant_right = "",
    slant_right_thin = "",
    slant_left_2 = "",
    slant_left_2_thin = "",
    slant_right_2 = "",
    slant_right_2_thin = "",
    left_rounded = "",
    left_rounded_thin = "",
    right_rounded = "",
    right_rounded_thin = "",
    circle = "●"
}

-- get vi_modes
function M.mode()
    local alias = {
        n = "NORMAL",
        no = "NORMAL",
        i = "INSERT",
        v = "VISUAL",
        V = "V-LINE",
        [""] = "V-BLOCK",
        c = "COMMAND",
        cv = "COMMAND",
        ce = "COMMAND",
        R = "REPLACE",
        Rv = "REPLACE",
        s = "SELECT",
        S = "SELECT",
        [""] = "SELECT",
        t = "TERMINAL"
    }
    return " " .. alias[vim.fn.mode()] .. " "
end

-- get diagnostics
M.get_diag = function(str)
    local count = vim.lsp.diagnostic.get_count(0, str)
    return (count > 0) and " " .. count .. " " or ""
end

-- custom providers

-------------
-- classic --
-------------
M.encodign_component_classic = {
    provider = function()
        local os = M.icons[vim.bo.fileformat] or ""
        return string.format(" %s %s ", os, vim.bo.fileencoding)
    end,
    left_sep = {str = " ", hl = {bg = "bg"}},
    hl = {fg = "white", bg = "fore"}
}
M.spaces_component_classic = {
    provider = function()
        local spaces = vim.api.nvim_buf_get_option(0, "shiftwidth")
        return string.format(" TAB: %s ", spaces)
    end,
    hl = {style = "bold"}
}
M.position_component_classic = {
    provider = function()
        local line = vim.fn.line(".")
        local col = vim.fn.col(".")
        return string.format(" %s %s:%s", M.icons.line_number, line, col)
    end,
    right_sep = {str = " ", hl = {bg = "back"}},
    hl = {fg = "bg", bg = "back", style = "bold"}
}

-----------
-- slant --
-----------
M.encodign_component_slant = {
    provider = function()
        local os = M.icons[vim.bo.fileformat] or ""
        return string.format(" %s %s ", os, vim.bo.fileencoding)
    end,
    hl = {fg = "white", bg = "fore"},
    left_sep = {str = M.icons.left_filled, hl = {fg = "fore", bg = "bg"}}
}

M.spaces_component_slant = {
    provider = function()
        local spaces = vim.api.nvim_buf_get_option(0, "shiftwidth")
        return string.format(" TAB: %s ", spaces)
    end,
    hl = {style = "bold"},
    left_sep = {str = M.icons.left_filled, hl = {fg = "bg", bg = "fore"}}
}

M.position_component_slant = {
    provider = function()
        local line = vim.fn.line(".")
        local col = vim.fn.col(".")
        return string.format(" %s %s:%s", M.icons.line_number, line, col)
    end,
    left_sep = {str = M.icons.left_filled, hl = {fg = "back", bg = "bg"}},
    right_sep = {str = " ", hl = {bg = "back"}},
    hl = {fg = "bg", bg = "back", style = "bold"}
}

return M
