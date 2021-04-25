local u = require("utils/statusline")

local color = require("plugins/statusline/colors")
local c = color[u.status_color]
local cc = color[u.status_color].colors

require("feline").setup(
    {
        default_fg = c.default_fg,
        default_bg = cc.dark,
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
            ----------
            -- Left --
            ----------
            left = {
                active = {
                    {
                        provider = u.mode,
                        hl = function()
                            return {
                                name = u.vi_mode_utils.get_mode_highlight_name(),
                                fg = "bg",
                                bg = u.vi_mode_utils.get_mode_color(),
                                style = "bold"
                            }
                        end
                    },
                    {
                        provider = "file_info",
                        file_modified_icon = "",
                        hl = {style = "bold", fg = "back"},
                        left_sep = " "
                    },
                    {
                        provider = u.icons.locker,
                        hl = {fg = "red"},
                        enabled = function()
                            return vim.bo.readonly
                        end
                    },
                    {
                        provider = "git_branch",
                        icon = "  ",
                        hl = {fg = "white", bg = "fore", style = "bold"}
                    },
                    {
                        provider = "git_diff_added",
                        icon = " +",
                        hl = {
                            fg = "cyan",
                            bg = "fore",
                            style = "bold"
                        }
                    },
                    {
                        provider = "git_diff_changed",
                        icon = " ~",
                        hl = {
                            fg = "yellow",
                            bg = "fore",
                            style = "bold"
                        }
                    },
                    {
                        provider = "git_diff_removed",
                        icon = " -",
                        hl = {
                            fg = "red",
                            bg = "fore",
                            style = "bold"
                        },
                        right_sep = " "
                    }
                },
                inactive = {
                    {
                        provider = "file_type",
                        hl = {
                            bg = "bg",
                            fg = "white",
                            style = "bold"
                        }
                    }
                }
            },
            mid = {active = {}, inactive = {}},
            -----------
            -- Right --
            -----------
            right = {
                active = {
                    {
                        provider = u.icons.connected,
                        enabled = function()
                            return not vim.tbl_isempty(vim.lsp.buf_get_clients(0))
                        end,
                        hl = {fg = "#b8bb26"},
                        right_sep = " "
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
                    u.encodign_component_classic,
                    {
                        provider = "file_type",
                        hl = {bg = "fore", fg = "cyan", style = "bold"},
                        right_sep = {str = " ", hl = {bg = "fore"}}
                    },
                    u.spaces_component_classic,
                    u.position_component_classic,
                    {
                        provider = " " .. u.icons.page,
                        left_sep = {str = u.icons.left, hl = {fg = "bg", bg = "back"}},
                        right_sep = {str = " ", hl = {bg = "back"}},
                        hl = {fg = "bg", bg = "back"}
                    },
                    {
                        provider = "line_percentage",
                        right_sep = {str = " ", hl = {bg = "back"}},
                        hl = {
                            fg = "bg",
                            bg = "back",
                            style = "bold"
                        }
                    },
                    {
                        provider = "scroll_bar",
                        hl = {
                            bg = "back",
                            fg = "yellow",
                            style = "bold"
                        }
                    }
                },
                inactive = {
                    u.position_component_classic
                }
            }
        },
        properties = u.properties
    }
)
