-- Taken from snacks' bigfile but with some modifcations to make simplier
-- https://github.com/folke/snacks.nvim/blob/main/lua/snacks/bigfile.lua
vim.filetype.add({
    pattern = {
        [".*"] = {
            function(path, buf)
                if not path or not buf or vim.bo[buf].filetype == "bigfile" then
                    return
                end
                if path ~= vim.fs.normalize(vim.api.nvim_buf_get_name(buf)) then
                    return
                end
                local size = vim.fn.getfsize(path)
                if size <= 0 then
                    return
                end
                local size_limit = 1.5 * 1024 * 1024 -- 1.5MB
                if size > size_limit then
                    return "bigfile"
                end
                local lines = vim.api.nvim_buf_line_count(buf)
                local line_length = 1000 -- average line length (useful for minified files)
                return (size - lines) / lines > line_length and "bigfile" or nil
            end,
        },
    },
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("Bigfile", { clear = true }),
    pattern = "bigfile",
    callback = function(ev)
        vim.api.nvim_buf_call(ev.buf, function()
            if vim.fn.exists(":NoMatchParen") ~= 0 then
                vim.cmd([[NoMatchParen]])
            end
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.undolevels = 50
            vim.opt_local.statuscolumn = ""
            vim.opt_local.relativenumber = false
            vim.opt_local.conceallevel = 0
            vim.b.minianimate_disable = true
            vim.b.minihipatterns_disable = true

            vim.schedule(function()
                -- NOTE: We don't need to explicitly disable treesitter because the filetype is being 
                -- set to "bigfile" in the filetype.add function above. Which automatically disables 
                -- treesitter because there are no parsers for files of type "bigfile"
                if vim.api.nvim_buf_is_valid(ev.buf) then
                    vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
                end
            end)
        end)
    end,
})
