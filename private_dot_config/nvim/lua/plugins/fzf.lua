local M = {}

M.config = {
    fzf_opts = {
        ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-history",
    },
    files = {
        -- formatter = "path.filename_first",
        fzf_opts = {
            ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-files-history",
        },
        fd_opts = [[--color=never --type f --type l --exclude .git --hidden]],
        cwd_prompt = false,
        winopts = { preview = { hidden = "hidden" } },
    },
    grep = {
        -- debug = true,
        multiline = 2, -- fzf >= 0.53.0
        -- formatter = "path.filename_first",
        winopts = {
            width = 0.8, -- window width
            preview = {
                layout = "vertical",
            },
        },
        rg_glob = true,
        rg_opts = [[--column --hidden --glob "!**/.git/**" ]]
            .. [[--line-number --no-heading --color=always ]]
            .. [[--smart-case --max-columns=4096 -e]],
        fzf_opts = {
            ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-grep-history",
        },
        -- first returned string is the new search query
        -- second returned string are (optional) additional rg flags
        -- @return string, string?
        rg_glob_fn = function(query, _)
            local regex, flags = query:match "^(.-)%s%-%-(.*)$"
            -- If no separator is detected will return the original query
            return (regex or query), flags
        end,
        previewer = { toggle_behavior = "extend" },
    },
    keymap = {
        fzf = {
            ["ctrl-q"] = "select-all+accept",
            ["alt-a"] = "toggle-all",
            ["ctrl-n"] = "down",
            ["ctrl-p"] = "up",
            ["ctrl-j"] = "next-history",
            ["ctrl-k"] = "previous-history",
        },
    },
}

M.keymaps = {
    -- find
    { "<leader><Space>", "<cmd>FzfLua files<CR>", desc = "Find files" },
    { "<leader>fa", "<cmd>FzfLua builtin<CR>", desc = "All pickers" },
    { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files" },
    {
        "<leader>f%",
        string.format("<cmd>FzfLua files cwd=%s<CR>", vim.fn.expand "%:p:h"),
        desc = "Find files in directory of current buffer",
    },
    { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Grep project" },
    { "<leader>fG", "<cmd>FzfLua lgrep_curbuf<CR>", desc = "Grep on current buffer" },
    {
        "<leader>fw",
        "<cmd>FzfLua grep_cword<CR>",
        desc = "Grep word under cursor",
        mode = { "n" },
    },
    {
        "<leader>fw",
        "<cmd>FzfLua grep_visual<CR>",
        desc = "Grep visual selection",
        mode = { "v" },
    },
    { "<leader>?", "<cmd>FzfLua help_tags<CR>", desc = "Help tags" },
    { "<leader>fc", "<cmd>FzfLua commands<CR>", desc = "Commands" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },
    { "<leader>fq", "<cmd>FzfLua quickfix<CR>", desc = "Quickfix" },
    { "<leader>fQ", "<cmd>FzfLua quickfix_stack<CR>", desc = "Quickfix history" },
    { "<leader>`", "<cmd>FzfLua resume<CR>", desc = "Resume last picker" },
    -- buffers
    { "<leader>b", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
    -- git
    { "<leader>gf", "<cmd>FzfLua git_files<CR>", desc = "Git files" },
    { "<leader>gb", "<cmd>FzfLua git_branches<CR>", desc = "Branches" },
    { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
    { "<leader>gC", "<cmd>FzfLua git_bcommits<CR>", desc = "Buffer commits" },
    { "<leader>gm", "<cmd>FzfLua git_status<CR>", desc = "Modified files" },
    -- lsp
    { "<leader>ld", "<cmd>FzfLua lsp_document_diagnostics<CR>", desc = "Document diagnostics" },
    { "<leader>lD", "<cmd>FzfLua lsp_workspace_diagnostics<CR>", desc = "Workspace diagnostics" },
    { "<leader>ls", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "Document symbols" },
    { "<leader>lS", "<cmd>FzfLua lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
}

---@module "lazy"
---@type LazySpec
return {
    {
        "ibhagwan/fzf-lua",
        cmd = { "FzfLua" },
        config = function() require("fzf-lua").setup(M.config) end,
        keys = M.keymaps,
    },
}
