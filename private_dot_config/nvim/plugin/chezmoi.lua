local tempfile = vim.fn.tempname()
vim.fn.writefile({ "#!/bin/sh", "", 'if [ -n "$NVIM" ]; then', '    nvim --server "$NVIM" --remote "$@"', "else", '    nvim "$@"', "fi", "" }, tempfile)
vim.system({"chmod", "+x", tempfile})

-- vim.system({"chmod +x", tempfile})
--- Source: https://github.com/juniorsundar/cling.nvim/blob/b24a6b29f83a98493001aa12496b995fd0d77b84/lua/cling/core.lua#L41-L64
--- Builds the chezmoi split command string based on smods.
--- @param smods table|nil Command modifiers from nvim_create_user_command.
--- @param chezmoi_args string The fnameescape'd terminal command.
--- @return string
local function build_chezmoi_cmd(smods, chezmoi_args)
    local cmd = string.format("env VISUAL=%s EDITOR=%s chezmoi %s", tempfile, tempfile, chezmoi_args)
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

local subcommands = {
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

local global_flags = {
    -- Global Flags:
    "--age-recipient", -- string                           Override age recipient
    "--age-recipient-file", -- string                      Override age recipient
    "--cache", -- path                                     Set cache directory (default /home/rafael/.cache/chezmoi)
    "--color", -- bool|auto                                Colorize output (default auto)
    "-c", -- "--config", path                                    Set config file
    "--config-format", -- <none>|json|toml|yaml            Set config file format
    "--debug",                                          -- Include debug information in output
    "-D", "--destination", -- path                               Set destination directory (default /home/rafael)
    "-n", "--dry-run",                                        -- Do not make any modifications to the destination directory
    "--force",                                          -- Make all changes without prompting
    "--interactive",                                    -- Prompt for all changes
    "-k", "--keep-going",                                     -- Keep going as far as possible after an error
    "--less-interactive",                               -- Prompt for changed or pre-existing targets
    "--mode", -- file|symlink                              Mode (default file)
    "--no-pager",                                       -- Do not use the pager
    "--no-tty",                                         -- Do not attempt to get a TTY for prompts
    "-o", "--output", -- path                                    Write output to path instead of stdout
    "--override-data", -- string                           Override data
    "--override-data-file", -- path                        Override data with file
    "--persistent-state", -- path                          Set persistent state file
    "--progress", -- bool|auto                             Display progress bars (default auto)
    "-R", "--refresh-externals", -- always|auto|never [= always]   Refresh external cache (default auto)
    "-S", "--source", -- path                                    Set source directory (default /home/rafael/.local/share/chezmoi)
    "--source-path",                                    -- Specify targets by source path
    "--use-builtin-age", -- bool|auto                      Use builtin age (default auto)
    "--use-builtin-diff",                               -- Use builtin diff
    "--use-builtin-git", -- bool|auto                      Use builtin git (default auto)
    "-v", "--verbose",                                        -- Make output more verbose
    "-W", "--working-tree", -- path                              Set working tree directory
}

local get_subcommand_suggestion = {}
local suggestion_cache = {}
local subcommand_handler = {}

local get_managed_files = function()
    local dest_dir = vim.json.decode(vim.fn.system("chezmoi data")).chezmoi.destDir .. "/"
    local managed = vim.fn.systemlist({ "chezmoi", "managed", "--exclude", "externals" })
    local managed_files = {}
    for _, file in pairs(managed) do
        table.insert(managed_files, dest_dir .. file)
    end

    return managed_files
end

for _, cmd in pairs({"edit", "forget"}) do
    get_subcommand_suggestion[cmd] = function()
        if suggestion_cache.managed_files then
            return suggestion_cache.managed_files
        end
        suggestion_cache.managed_files = get_managed_files()
        return suggestion_cache.managed_files
    end
end

for _, cmd in pairs({"add", "re-add"}) do
    get_subcommand_suggestion[cmd] = function(arg_lead)
        return vim.fn.getcompletion(arg_lead, "file")
    end
end

get_subcommand_suggestion.help = function()
    return subcommands
end

subcommand_handler.edit = function(opts)
    if not opts.smods.horizontal then
        opts.smods.vertical = true
    end
    vim.cmd(build_chezmoi_cmd(opts.smods, opts.args))
end

subcommand_handler.apply = function(opts)
    vim.cmd(build_chezmoi_cmd(opts.smods, opts.args))
    vim.cmd.startinsert()
end

subcommand_handler.data = function(opts)
    local filetype = string.find(opts.args, "yaml") and "yaml" or "json"
    local output = vim.fn.system("chezmoi " .. opts.args)
    if not opts.smods.horizontal then
        opts.smods.vertical = true
    end
    if vim.v.shell_error == 0 then
        vim.cmd.new({ mods = opts.smods })
        vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, "\n"))
        vim.cmd("set filetype=" .. filetype)
        vim.cmd("set buftype=nofile")
    else
        vim.api.nvim_echo({ { "Error: " .. output, "ErrorMsg" } }, true, {})
    end
end

local function parse_cmd(cmd_string, arg_lead)
    local result = { subcommand = nil, is_typing_subcmd = false }

    -- Find earliest recognized subcommand in the line
    local subcmd_end = math.huge
    for _, cmd in ipairs(subcommands) do
        local _, end_index = cmd_string:find(' ' .. cmd .. ' ', 1, true)
        if end_index ~= nil and end_index < subcmd_end then
            result.subcommand = cmd
            subcmd_end = end_index
        end
    end

    -- Still typing the subcommand itself
    if result.subcommand == nil or arg_lead == result.subcommand then
        result.is_typing_subcmd = true
    end

    return result
end

vim.api.nvim_create_user_command("Chezmoi", function(opts)
    for _, arg in pairs(opts.fargs) do
        if subcommand_handler[arg] then
            subcommand_handler[arg](opts)
            return
        else
            vim.cmd(build_chezmoi_cmd(opts.smods, opts.args))
            return
        end
    end
end, {
        nargs = "+",
        complete = function(arg_lead, cmd_string, _)
            if vim.startswith(arg_lead, "-") then
                if arg_lead == "-" or arg_lead == "--" then return global_flags end
                return vim.fn.matchfuzzy(global_flags, arg_lead)
            end

            local parsed = parse_cmd(cmd_string, arg_lead)

            if parsed.is_typing_subcmd then
                if arg_lead == "" then return subcommands end
                return vim.fn.matchfuzzy(subcommands, arg_lead)
            end

            if parsed.subcommand and get_subcommand_suggestion[parsed.subcommand] then
                local suggestions = get_subcommand_suggestion[parsed.subcommand](arg_lead)
                if arg_lead == "" then return suggestions end
                return vim.fn.matchfuzzy(suggestions, vim.fn.expand(arg_lead))
            end
        end
    })
