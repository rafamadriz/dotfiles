local u = require("utils/statusline")

local color = require("plugins/statusline/colors")
local c = color[u.status_color]
local cc = color[u.status_color].colors

require("feline").setup(
    {
        default_fg = c.default_fg,
        default_bg = c.default_bg,
        colors = {
            fore = cc.fore,
            back = cc.back,
            dark = cc.dark,
            white = cc.white,
            skyblue = cc.skyblue,
            cyan = cc.cyan,
            green = cc.green,
            oceanblue = cc.oceanblue,
            magenta = cc.magenta,
            orange = cc.orange,
            red = cc.red,
            violet = cc.violet,
            yellow = cc.yellow
        },
        vi_mode_colors = {
            NORMAL = "back",
            OP = "cyan",
            INSERT = "skyblue",
            VISUAL = "cyan",
            BLOCK = "cyan",
            REPLACE = "yellow",
            ["V-REPLACE"] = "yellow",
            ENTER = "cyan",
            MORE = "cyan",
            SELECT = "magenta",
            COMMAND = "orange",
            SHELL = "skyblue",
            TERM = "skyblue",
            NONE = "orange"
        },
        components = {
            left = {
                active = {
                    {
                        provider = u.icons.block,
                        hl = function()
                            local val = {}
                            val.fg = u.vi_mode_utils.get_mode_color()
                            return val
                        end,
                        right_sep = " "
                    },
                    {
                        provider = "file_info",
                        file_modified_icon = "",
                        hl = {fg = "magenta", style = "bold"}
                    },
                    {
                        provider = function()
                            local line = vim.fn.line(".")
                            local col = vim.fn.col(".")
                            return string.format(" %s %3s:%-2s", u.icons.line_number, line, col)
                        end,
                        hl = {style = "bold"}
                    },
                    {
                        provider = "git_branch",
                        icon = "  ",
                        hl = {fg = "cyan"}
                    },
                    {
                        provider = "git_diff_added",
                        icon = " +",
                        hl = {fg = "green"}
                    },
                    {
                        provider = "git_diff_changed",
                        icon = " ~",
                        hl = {fg = "yellow"}
                    },
                    {
                        provider = "git_diff_removed",
                        icon = " -",
                        hl = {fg = "red"}
                    }
                },
                inactive = {
                    {
                        provider = u.icons.block,
                        hl = function()
                            local val = {}
                            val.fg = u.vi_mode_utils.get_mode_color()
                            return val
                        end,
                        right_sep = " "
                    },
                    {
                        provider = "file_type",
                        hl = {
                            fg = "magenta",
                            style = "bold"
                        }
                    },
                    {
                        provider = function()
                            local line = vim.fn.line(".")
                            local col = vim.fn.col(".")
                            return string.format(" %s %3s:%-2s", u.icons.line_number, line, col)
                        end,
                        hl = {style = "bold"}
                    }
                }
            },
            mid = {active = {}, inactive = {}},
            right = {
                active = {
                    {
                        provider = u.icons.connected,
                        enabled = function()
                            return not vim.tbl_isempty(vim.lsp.buf_get_clients(0))
                        end,
                        hl = {fg = "#b8bb26"},
                        right_sep = "  "
                    },
                    {
                        provider = "diagnostic_errors",
                        enabled = function()
                            return u.lsp.diagnostics_exist("Error")
                        end,
                        hl = {fg = "red", bg = "bg"}
                    },
                    {
                        provider = "diagnostic_warnings",
                        enabled = function()
                            return u.lsp.diagnostics_exist("Warning")
                        end,
                        hl = {fg = "yellow", bg = "bg"}
                    },
                    {
                        provider = "diagnostic_info",
                        enabled = function()
                            return u.lsp.diagnostics_exist("Information")
                        end,
                        hl = {fg = "skyblue", bg = "bg"}
                    },
                    {
                        provider = "diagnostic_hints",
                        enabled = function()
                            return u.lsp.diagnostics_exist("Hint")
                        end,
                        hl = {fg = "cyan", bg = "bg"}
                    },
                    {
                        provider = function()
                            return string.format("  %s", vim.bo.fileencoding)
                        end,
                        hl = function()
                            local val = {}
                            val.fg = u.vi_mode_utils.get_mode_color()
                            return val
                        end
                    },
                    {
                        provider = function()
                            local spaces = vim.api.nvim_buf_get_option(0, "shiftwidth")
                            return string.format("TAB: %s", spaces)
                        end,
                        hl = function()
                            local val = {}
                            val.fg = u.vi_mode_utils.get_mode_color()
                            val.style = "bold"
                            return val
                        end,
                        left_sep = "   ",
                        right_sep = "   "
                    },
                    {
                        provider = function()
                            local total = vim.fn.line("$")
                            return string.format("%s %s", u.icons.mathematical_L, total)
                        end,
                        hl = function()
                            local val = {}
                            val.fg = u.vi_mode_utils.get_mode_color()
                            val.style = "bold"
                            return val
                        end,
                        right_sep = " "
                    }
                },
                inactive = {
                    {
                        provider = function()
                            local total = vim.fn.line("$")
                            return string.format("%s %s", u.icons.mathematical_L, total)
                        end,
                        hl = function()
                            local val = {}
                            val.fg = u.vi_mode_utils.get_mode_color()
                            val.style = "bold"
                            return val
                        end,
                        right_sep = " "
                    }
                }
            },
            properties = u.properties
        }
    }
)
