local ok, ts = pcall(require, "nvim-treesitter")
if not ok then return end

vim.api.nvim_create_autocmd('User', { pattern = 'TSUpdate',
    callback = function()
        require"nvim-treesitter.parsers".qf = {
            install_info = {
                url = "https://github.com/OXY2DEV/tree-sitter-qf",
                branch = "main",
                queries = "queries/"
            },
        }
    end
})

local parsers = {
    "bash",
    "c",
    "comment",
    "cpp",
    "css",
    "diff",
    "gitcommit",
    "go",
    "html",
    "http",
    "javascript",
    "json",
    "jsx",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "python",
    "qf",
    "query",
    "regex",
    "rust",
    "scss",
    "todotxt",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
    "zig",
}

local installed = ts.get_installed()
local function get_parsers_to_install()
    return vim.tbl_filter(function(parser)
        return not vim.tbl_contains(installed, parser)
    end, parsers)
end
ts.install(get_parsers_to_install())

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)

        if not vim.tbl_contains(installed, lang) then
            return
        end

        -- indentation, provided by nvim-treesitter
        vim.treesitter.start(args.buf, lang)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        -- treesitter based folding
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

        local ok, _ = pcall(require, "nvim-treesitter-textobjects.select")
        if not ok then return end

        vim.keymap.set({ "x", "o" }, "af", function()
            require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
        end, { buf = args.buf })
        vim.keymap.set({ "x", "o" }, "if", function()
            require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
        end, { buf = args.buf })
        vim.keymap.set({ "x", "o" }, "ac", function()
            require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
        end, { buf = args.buf })
        vim.keymap.set({ "x", "o" }, "ic", function()
            require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
        end, { buf = args.buf })
    end,
})
