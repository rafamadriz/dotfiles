--- Source: https://github.com/juniorsundar/cling.nvim/blob/b24a6b29f83a98493001aa12496b995fd0d77b84/lua/cling/core.lua#L41-L64
--- Builds the chezmoi split command string based on smods.
--- @param smods table|nil Command modifiers from nvim_create_user_command.
--- @param chezmoi_args string The fnameescape'd terminal command.
--- @return string
local function build_chezmoi_cmd(smods, chezmoi_args)
    local cmd = "chezmoi " .. chezmoi_args
    if not smods then
        return "bot split term://" .. cmd
    end

    if smods.tab and smods.tab >= 0 then
        return "tabnew term://" .. cmd
    end

    local prefix = ""
    if smods.split == "topleft" then
        prefix = "topleft "
    elseif smods.split == "botright" then
        prefix = "botright "
    else
        prefix = "botright " -- default position
    end

    if smods.vertical then
        return prefix .. "vsplit term://" .. cmd
    else
        return prefix .. "split term://" .. cmd
    end
end

local function create_session_and_restart()
    local cache_dir = vim.fn.stdpath("cache")
    if not vim.fn.isdirectory(cache_dir) then
        vim.fn.mkdir(cache_dir, "p")
    end
    vim.cmd.mksession { cache_dir .. "/chezmoi.vim", bang = true }
    vim.cmd.restart { args = { "source", cache_dir .. "/chezmoi.vim" } }
end

local function is_nvim_config(target)
    if string.find(target, "config/nvim.*") then
        return true
    end
    return false
end

vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("chezmoi", {}),
    pattern = vim.json.decode(vim.fn.system("chezmoi data")).chezmoi.sourceDir .. "/*",
    nested = true,
    callback = function(info)
        local origin_win = vim.api.nvim_get_current_win()

        vim.schedule(function()
            if vim.fn.fnamemodify(info.file, ":."):match "^%." then
                -- ignore files starting with `.`
                return
            end

            local target = vim.fn.systemlist({ "chezmoi", "target-path", info.file })[1]
            local dry_run_output = vim.fn.systemlist({ "chezmoi", "apply", "--dry-run", target })
            if vim.tbl_isempty(dry_run_output) then
                local apply_job = vim.system({ "chezmoi", "apply", target}):wait()
                if apply_job.code == 0 then
                    if is_nvim_config(target) then create_session_and_restart() end
                    vim.api.nvim_echo({ { "Chezmoi: Target has been updated > ", "OkMsg" }, { target, "OkMsg" } }, true, {})
                else
                    vim.api.nvim_echo({ { "Chezmoi: " .. apply_job.stderr, "ErrorMsg" } }, true, {})
                end
                return
            end
            vim.cmd("keepalt " .. build_chezmoi_cmd(nil, "apply " .. target))
            vim.cmd.startinsert()
            local term_buf = vim.api.nvim_get_current_buf()

            vim.api.nvim_create_autocmd("TermClose", {
                buffer = term_buf,
                once = true,
                callback = function()
                    if vim.tbl_isempty(dry_run_output) then
                        if vim.api.nvim_win_is_valid(origin_win) then
                            vim.api.nvim_set_current_win(origin_win)
                        end

                        if vim.api.nvim_buf_is_valid(term_buf) then
                            vim.api.nvim_buf_delete(term_buf, { force = true })
                        end
                    end
                end,
            })
        end)
    end,
})

vim.api.nvim_create_user_command("Chezmoi", function(opts)
    vim.cmd(build_chezmoi_cmd(opts.smods, opts.args))
    vim.cmd.startinsert()
end, {
        nargs = "+",
        complete = function()
            return {
                -- Documentation commands:
                "doctor",               -- Check your system for potential problems
                "help",                 -- Print help about a command
                "license",              -- Print license

                -- Daily commands:
                "add",                  -- Add an existing file, directory, or symlink to the source state
                "apply",                -- Update the destination directory to match the target state
                "chattr",               -- Change the attributes of a target in the source state
                "diff",                 -- Print the diff between the target state and the destination state
                "edit",                 -- Edit the source state of a target
                "forget",               -- Remove a target from the source state
                "init",                 -- Setup the source directory and update the destination directory to match the target state
                "merge",                -- Perform a three-way merge between the destination state, the source state, and the target state
                "merge-all",            -- Perform a three-way merge for each modified file
                "re-add",               -- Re-add modified files
                "status",               -- Show the status of targets
                "update",               -- Pull and apply any changes

                -- Template commands:
                "cat",                  -- Print the target contents of a file, script, or symlink
                "data",                 -- Print the template data
                "execute-template",     -- Execute the given template(s)

                -- Advanced commands:
                "cd",                   -- Launch a shell in the source directory
                "edit-config",          -- Edit the configuration file
                "edit-config-template", -- Edit the configuration file template
                "generate",             -- Generate a file for use with chezmoi
                "git",                  -- Run git in the source directory
                "ignored",              -- Print ignored targets
                "managed",              -- List the managed entries in the destination directory
                "unmanaged",            -- List the unmanaged files in the destination directory
                "verify",               -- Exit with ssccess if the destination state matches the target state, fail otherwise

                -- Encryption commands:
                "age",                  -- Interact with age
                "age-keygen",           -- Generate an age identity or convert an age identity to an age recipient
                "decrypt",              -- Decrypt file or standard inpst
                "edit-encrypted",       -- Edit an encrypted file
                "encrypt",              -- Encrypt file or standard input

                -- Remote commands:
                "docker",               -- Use your dotfiles in a Docker container
                "ssh",                  -- SSH to a host and initialize dotfiles

                -- Migration commands:
                "archive",              -- Generate a tar archive of the target state
                "destroy",              -- Permanently delete an entry from the source state, the destination directory, and the state
                "import",               -- Import an archive into the source state
                "purge",                -- Purge chezmoi's configuration and data

                -- Internal commands:
                "cat-config",           -- Print the configuration file
                "completion",           -- Generate shell completion code
                "dump",                 -- Generate a dump of the target state
                "dump-config",          -- Dump the configuration values
                "secret",               -- Interact with a secret manager
                "source-path",          -- Print the source path of a target
                "state",                -- Manipulate the persistent state
                "target-path",          -- Print the target path of a source path
            }
        end
    })
