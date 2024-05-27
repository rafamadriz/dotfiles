-- to run this file as a local nvim config see `help trust`

if (vim.fn.exists "$TMUX" == 1) and (vim.fn.executable "chezmoi" > 0) then
    vim.api.nvim_create_user_command("ChezmoiApply", function(arg)
        local function command(file)
            vim.system({ "tmux", "display-popup", "-E", "chezmoi", "apply", file or nil }, { text = true })
        end

        local filename = vim.fn.expand "%"
        if vim.fn.fnamemodify(filename, ":."):match "^%." then
            -- only execute command without filename
            -- ignore files starting with `.`
            command()
            return
        end

        if arg.bang then
            local chezmoi_file = vim.fn.systemlist({ "chezmoi", "target-path", filename })[1]
            command(chezmoi_file)
        else
            command()
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
