local installer = require "nvim-lsp-installer"
installer.setup {}

local set_mappings = function(client, bufnr)
    local with_desc = function(desc)
        return { buffer = bufnr, desc = desc }
    end

    as.nnoremap("[d", vim.diagnostic.goto_prev, with_desc "Previous diagnostic")
    as.nnoremap("]d", vim.diagnostic.goto_next, with_desc "Next diagnostic")
    as.nnoremap("gD", vim.lsp.buf.declaration, with_desc "Go to declaration")
    as.nnoremap("gd", vim.lsp.buf.definition, { desc = "Go to definition" })
    as.nnoremap("gr", vim.lsp.buf.references, with_desc "Go to references")
    as.nnoremap("gi", vim.lsp.buf.implementation, with_desc "Go to implementation")
    as.nnoremap("K", vim.lsp.buf.hover, with_desc "Document hover")
    as.nnoremap("<C-k>", vim.lsp.buf.signature_help, with_desc "Signature help")

    as.nnoremap(
        "<leader>lwa",
        vim.lsp.buf.add_workspace_folder,
        with_desc "Add folder to workspace"
    )
    as.nnoremap(
        "<leader>lwr",
        vim.lsp.buf.remove_workspace_folder,
        with_desc "Remove folder from workspace"
    )
    as.nnoremap("<leader>lwl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, with_desc "List workspace folders")
    as.nnoremap("<leader>la", vim.lsp.buf.code_action, with_desc "Code action")
    as.xnoremap("<leader>la", vim.lsp.buf.range_code_action, with_desc "Code action")
    as.nnoremap("<leader>lc", vim.lsp.codelens.run, with_desc "Run code lens")
    as.nnoremap("<leader>lt", vim.lsp.buf.type_definition, with_desc "Go to type definition")
    as.nnoremap("<leader>lr", vim.lsp.buf.rename, with_desc "Rename symbol")
    as.nnoremap("<leader>lf", vim.lsp.buf.formatting, with_desc "Formatting")
    as.nnoremap("<leader>ll", vim.diagnostic.open_float, with_desc "Line diagnostics")
    as.nnoremap("<leader>li", "<cmd>LspInfo<CR>", with_desc "LSP info")

    as.nnoremap("<leader>lp", function()
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
            if result == nil or vim.tbl_isempty(result) then
                return nil
            end
            vim.lsp.util.preview_location(result[1], { border = as.lsp.borders })
        end)
    end, { desc = "Peek definition" })

    require("which-key").register({
        ["<leader>"] = {
            ["l"] = {
                name = "LSP",
                ["w"] = "Workspace",
            },
        },
    }, { mode = "n" })

    require("which-key").register({
        ["<leader>"] = {
            ["l"] = {
                name = "LSP",
                ["a"] = "Code action",
            },
        },
    }, { mode = "x" })
end

local on_attach = function(client, bufnr)
    set_mappings(client, bufnr)
    require("lsp_signature").on_attach { max_width = 90, fix_pos = true, hint_prefix = " " }

    if client and client.server_capabilities.codeLensProvider then
        as.augroup("RefreshCodeLens", {
            {
                event = { "BufEnter", "CursorHold", "InsertLeave" },
                buffer = bufnr,
                command = function()
                    vim.lsp.codelens.refresh()
                end,
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
