local set_mappings = function(client, bufnr)
    local builtins = require "telescope.builtin"
    require("which-key").register({
        ["[d"] = { vim.diagnostic.goto_prev, "Previous diagnostic" },
        ["]d"] = { vim.diagnostic.goto_next, "Next diagnostic" },
        ["gD"] = { vim.lsp.buf.declaration, "Go to declaration" },
        ["gd"] = { vim.lsp.buf.definition, "Go to definition" },
        ["gr"] = { vim.lsp.buf.references, "Go to references" },
        ["gi"] = { vim.lsp.buf.implementation, "Go to implementation" },
        ["K"] = { vim.lsp.buf.hover, "Document hover" },
        ["<C-k>"] = { vim.lsp.buf.signature_help, "Signature help" },

        ["<leader>"] = {
            ["l"] = {
                ["d"] = {
                    function() builtins.diagnostics { bufnr = 0 } end,
                    "Document diagnostics",
                },
                ["D"] = { builtins.diagnostics, "Workspace diagnostics" },
                ["a"] = { vim.lsp.buf.code_action, "Code action" },
                ["c"] = { vim.lsp.codelens.run, "Run code lens" },
                ["t"] = { vim.lsp.buf.type_definition, "Go to type definition" },
                ["r"] = { vim.lsp.buf.rename, "Rename symbol" },
                ["f"] = { vim.lsp.buf.formatting, "Formatting" },
                ["l"] = { vim.diagnostic.open_float, "Line diagnostics" },
                ["s"] = { builtins.lsp_document_symbols, "Document symbols" },
                ["S"] = { builtins.lsp_workspace_symbols, "Workspace symbols" },
                ["p"] = {
                    function()
                        local params = vim.lsp.util.make_position_params()
                        return vim.lsp.buf_request(
                            0,
                            "textDocument/definition",
                            params,
                            function(_, result)
                                if result == nil or vim.tbl_isempty(result) then return nil end
                                vim.lsp.util.preview_location(
                                    result[1],
                                    { border = as.lsp.borders }
                                )
                            end
                        )
                    end,
                    "Peek definition",
                },
            },
        },
    }, { mode = "n", buffer = bufnr })
end

as.nnoremap("<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP info" })

local on_attach = function(client, bufnr)
    set_mappings(client, bufnr)
    require("lsp_signature").on_attach { max_width = 90, fix_pos = true, hint_prefix = " " }

    if client and client.server_capabilities.codeLensProvider then
        as.augroup("RefreshCodeLens", {
            {
                event = { "BufEnter", "CursorHold", "InsertLeave" },
                buffer = bufnr,
                command = function() vim.lsp.codelens.refresh() end,
            },
        })
    end
end

require("lspconfig.ui.windows").default_options.border = as.lsp.borders

local lspconfig = require "lspconfig"

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
    on_attach = on_attach,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Setup ccls with lspconfig since it's not going to be supported by mason.nvim
-- Source: https://github.com/williamboman/mason.nvim/issues/349
if as.executable "ccls" then lspconfig.ccls.setup {} end

require("mason-lspconfig").setup_handlers {

    function(server_name) lspconfig[server_name].setup {} end,

    ["sumneko_lua"] = function()
        lspconfig.sumneko_lua.setup {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = {
                            "vim",
                            "as",
                        },
                    },
                },
            },
        }
    end,

    ["rust_analyzer"] = function()
        lspconfig.rust_analyzer.setup {
            settings = {
                ["rust-analyzer"] = {
                    checkOnSave = {
                        command = "clippy",
                    },
                },
            },
        }
    end,
}
