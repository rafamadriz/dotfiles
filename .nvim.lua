-- to run this file as a local nvim config see `help trust`

if vim.fn.exists "$TMUX" == 1 then
    vim.api.nvim_create_user_command("ChezmoiApply", function(arg)
        local filename = vim.fn.expand "%"

        if vim.fn.fnamemodify(filename, ":."):match "^%." then
            -- ignore files starting with `.`
            return
        end

        local fmt = string.format
        local tmux_cmd = [[tmux display-popup -E]]
        local chezmoi_cmd = [[chezmoi apply]]
        local chezmoi_file = vim.fn.systemlist({ "chezmoi", "target-path", filename })[1]

        if arg.bang then
            vim.fn.system(fmt("%s %s %s", tmux_cmd, chezmoi_cmd, chezmoi_file))
        else
            vim.fn.system(fmt("%s %s", tmux_cmd, chezmoi_cmd))
        end
    end, { bang = true })

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("chezmoi-nvim-lua", { clear = true }),
        callback = function(info)
            if vim.fn.fnamemodify(info.file, ":."):match "^%." then
                -- ignore files starting with `.`
                return
            end

            vim.cmd.ChezmoiApply { bang = true }
        end,
    })
end

-- https://github.com/MunifTanjim/dotfiles/blob/8c13a4e05359bb12f9ade5abc1baca6fcec372db/.nvim.lua
-- https://github.com/atusy/dotfiles/blob/2bcb80069a6f02f118ab303857293c3c868e317a/.nvim.lua
-- https://github.com/gametaro/dotfiles/blob/a02fb500820268ef7c5188f9d60fd4f5771b38fc/.nvim.lua
-- if vim.fn.has "nvim-0.10" == 0 then return end
