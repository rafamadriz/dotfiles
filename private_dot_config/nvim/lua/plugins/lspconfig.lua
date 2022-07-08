local installer = require "nvim-lsp-installer"
installer.setup {}

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
                ["a"] = { vim.lsp.buf.code_action, "Code action" },
                ["c"] = { vim.lsp.codelens.run, "Run code lens" },
                ["t"] = { vim.lsp.buf.type_definition, "Go to type definition" },
                ["r"] = { vim.lsp.buf.rename, "Rename symbol" },
                ["f"] = { vim.lsp.buf.formatting, "Formatting" },
                ["l"] = { vim.diagnostic.open_float, "Line diagnostics" },
                ["s"] = { builtins.lsp_document_symbols, "Document symbols" },
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

                ["w"] = { name = "Workspace" },
                ["wa"] = { vim.lsp.buf.add_workspace_folder, "Add folder to workspace" },
                ["wr"] = { vim.lsp.buf.remove_workspace_folder, "Remove folder from workspace" },
                ["wd"] = { builtins.diagnostics, "Workspace diagnostics" },
                ["ws"] = { builtins.lsp_workspace_symbols, "Workspace symbols" },
                ["wl"] = {
                    function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
                    "List workspace folders",
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local installed = {}
for _, server in pairs(installer.get_installed_servers()) do
    table.insert(installed, server["name"])
end

local opts = { on_attach = on_attach, capabilities = capabilities }
for _, lsp in pairs(installed) do
    if lsp == "sumneko_lua" then
        opts.settings = {
            Lua = {
                diagnostics = {
                    globals = {
                        "vim",
                        "as",
                    },
                },
                workspace = {
                    maxPreload = 10000,
                    preloadFileSize = 50000,
                },
            },
        }
    end

    require("lspconfig")[lsp].setup(opts)
end
