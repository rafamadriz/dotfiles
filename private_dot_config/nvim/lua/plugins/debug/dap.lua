local M = {}

M.dapui = {
    "rcarriga/nvim-dap-ui",
    config = function()
        local dapui = require "dapui"
        dapui.setup()
        vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "DAP UI" })
    end,
    dependencies = {
        "nvim-neotest/nvim-nio",
    },
}

-- Stolen from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/dap/core.lua
-- Credits: @folke
---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
    local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
    config = vim.deepcopy(config)
    ---@cast args string[]
    config.args = function()
        local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
        return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
    end
    return config
end

return {
    "mfussenegger/nvim-dap",
    dependencies = { M.dapui },
    lazy = false,
    config = function()
        local dap = require "dap"

        dap.adapters.cppdbg = {
            id = "cppdbg",
            type = "executable",
            command = "OpenDebugAD7",
        }

        dap.configurations.c = {
            {
                name = "Launch file",
                type = "cppdbg",
                request = "launch",
                program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
                cwd = "${workspaceFolder}",
                stopAtEntry = true,
            },
            {
                name = "Attach to gdbserver :1234",
                type = "cppdbg",
                request = "launch",
                MIMode = "gdb",
                miDebuggerServerAddress = "localhost:1234",
                miDebuggerPath = "/usr/bin/gdb",
                cwd = "${workspaceFolder}",
                program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
            },
        }
    end,

    keys = {
        {
            "<leader>dB",
            function() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end,
            desc = "Breakpoint Condition",
        },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
        { "<leader>da", function() require("dap").continue { before = get_args } end, desc = "Run with Args" },
        { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
        { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
        { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
        { "<leader>dj", function() require("dap").down() end, desc = "Down in stacktrace, no stepping" },
        { "<leader>dk", function() require("dap").up() end, desc = "Up in stacktrace, no stepping" },
        { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
        { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
        { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
        { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
        { "<leader>dR", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
        { "<leader>dr", function() require("dap").run() end, desc = "Run" },
        { "<leader>ds", function() require("dap").session() end, desc = "Session" },
        { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
        { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
}
