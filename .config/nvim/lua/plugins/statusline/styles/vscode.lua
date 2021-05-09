local u = require("utils/statusline")

require("feline").setup(
    {
        default_fg = "#d4d4d4",
        default_bg = "#68217A",
        vi_mode_colors = {
            NORMAL = "#579C4C",
            OP = "#35CDAF",
            INSERT = "#237AD3",
            VISUAL = "#35CDAF",
            BLOCK = "#35CDAF",
            REPLACE = "#D7BA7D",
            ["V-REPLACE"] = "#D7BA7D",
            ENTER = "#35CDAF",
            MORE = "#35CDAF",
            SELECT = "#D16969",
            COMMAND = "#D16969",
            SHELL = "#237AD3",
            TERM = "#237AD3",
            NONE = "default_fg"
        },
        components = {
            left = {
                active = {
                    {
                        provider = u.icons.circle,
                        hl = function()
                            local val = {}
                            val.fg = u.vi_mode_utils.get_mode_color()
                            return val
                        end,
                        left_sep = " ",
                        right_sep = " "
                    },
                    {
                        provider = function()
                            local dir = vim.fn.expand("%:p:h:t")
                            local file = vim.fn.expand("%:t")
                            return string.format("%s/%s", dir, file)
                        end,
                        hl = {style = "bold"},
                        right_sep = function()
                            local val = {hl = {fg = "#56abe4"}}
                            if vim.bo.modifiable then
                                if vim.bo.modified then
                                    val.str = "  "
                                else
                                    val.str = " "
                                end
                                return val
                            end
                        end
                    },
                    {
                        provider = u.icons.locker,
                        hl = {fg = "#D16969"},
                        enabled = function()
                            return vim.bo.readonly
                        end,
                        left_sep = " "
                    },
                    {
                        provider = "git_branch",
                        icon = "  ",
                        hl = {fg = "#DB8E73", style = "bold"}
                    },
                    {
                        provider = "git_diff_added",
                        hl = {fg = "#B5CEA8"}
                    },
                    {
                        provider = "git_diff_changed",
                        hl = {fg = "#D9DAA2"}
                    },
                    {
                        provider = "git_diff_removed",
                        hl = {fg = "#C586C0"}
                    },
                    {
                        provider = function()
                            local line = vim.fn.line(".")
                            local col = vim.fn.col(".")
                            return string.format("%s %s:%s ", u.icons.line_number, line, col)
                        end,
                        left_sep = function()
                            local val = {hl = {fg = "fg"}}
                            if u.b.gitsigns_status_dict then
                                val.str = "  "
                            else
                                val.str = " "
                            end
                            return val
                        end
                    },
                    {
                        provider = "line_percentage",
                        left_sep = " "
                    }
                },
                inactive = {
                    {
                        provider = u.icons.circle,
                        hl = function()
                            local val = {}
                            val.fg = u.vi_mode_utils.get_mode_color()
                            return val
                        end,
                        left_sep = " ",
                        right_sep = " "
                    },
                    {
                        provider = "file_type",
                        hl = {
                            style = "bold"
                        }
                    },
                    {
                        provider = function()
                            local line = vim.fn.line(".")
                            local col = vim.fn.col(".")
                            return string.format(" %s %s:%s ", u.icons.line_number, line, col)
                        end,
                        hl = {style = "bold"}
                    }
                }
            },
            mid = {active = {}, inactive = {}},
            right = {
                active = {
                    {
                        provider = "diagnostic_errors",
                        enabled = function()
                            return u.lsp.diagnostics_exist("Error")
                        end,
                        hl = {fg = "#D16969"}
                    },
                    {
                        provider = "diagnostic_warnings",
                        enabled = function()
                            return u.lsp.diagnostics_exist("Warning")
                        end,
                        hl = {fg = "#D7BA7D"}
                    },
                    {
                        provider = "diagnostic_info",
                        enabled = function()
                            return u.lsp.diagnostics_exist("Information")
                        end,
                        hl = {fg = "#85DDFF"}
                    },
                    {
                        provider = "diagnostic_hints",
                        enabled = function()
                            return u.lsp.diagnostics_exist("Hint")
                        end,
                        hl = {fg = "#B5CEA8"}
                    },
                    {
                        provider = function()
                            return string.upper(string.format("  %s", vim.bo.fileencoding))
                        end
                    },
                    {
                        provider = function()
                            local spaces = vim.api.nvim_buf_get_option(0, "shiftwidth")
                            return string.format("TAB: %s", spaces)
                        end,
                        left_sep = "  ",
                        right_sep = "  "
                    },
                    {
                        provider = "file_type",
                        hl = {style = "bold"},
                        right_sep = " "
                    },
                    {
                        provider = u.icons.confirm,
                        enabled = function()
                            return not vim.tbl_isempty(vim.lsp.buf_get_clients(0))
                        end,
                        hl = {fg = "#b8bb26", style = "bold"},
                        right_sep = " "
                    }
                },
                inactive = {
                    {
                        provider = "line_percentage",
                        hl = {style = "bold"},
                        right_sep = " "
                    }
                }
            },
            properties = u.properties
        }
    }
)
