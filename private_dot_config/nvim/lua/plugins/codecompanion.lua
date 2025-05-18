---@module "lazy"
---@type LazySpec
return {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanionChat" },
    opts = {
        adapters = {
            copilot = function()
                return require("codecompanion.adapters").extend("copilot", {
                    schema = {
                        model = {
                            default = "claude-3.7-sonnet", -- this model seems to not be able to use the @editor, probably because it's reasoning aloud
                        },
                    },
                })
            end,
        },
        strategies = {
            chat = {
                keymaps = {
                    close = {
                        modes = { n = "Q", i = "<C-_>" },
                    },
                    completion = {
                        modes = {
                            i = "<C-Space>",
                        },
                    },
                },
            },
        },
    },
    dependencies = {
        { "zbirenbaum/copilot.lua", opts = {} },
    },
}
