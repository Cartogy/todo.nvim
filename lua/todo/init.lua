local M = {}

local todo_file = "TODO.md"

M.setup = function(opts) 
    if opts['todo_file'] then
        todo_file = opts['todo_file']
    end
end

local has_git = function()
	-- Check if there is a git repo.
	vim.cmd("let @x = system('git rev-parse --show-toplevel')")
	-- Compare strings to check if it is a git repo or not.
	-- If the command contains 'fatal', then it is not a git repo.
	
	-- 1) Check if there is root
	local no_git = vim.fn.stridx(vim.fn.getreg('x'),"fatal")

	if no_git == 0 then
		return false
    else
        return true
    end
end

local has_todo_file = function(root_directory)
    local file = root_directory .. "/" .. todo_file
    local in_dir = vim.fn.filereadable(file)
    if in_dir == 1 then
        return true
    else
        return false
    end
end

M.open_todo = function()
    print("In TODO")
    if has_git() then
        -- Remove new line char
        local root_dir = vim.fn.getreg('x'):gsub("[\n]","")
        if has_todo_file(root_dir) then
            print(root_dir .. "/" .. todo_file)
            local file = root_dir .. "/" .. todo_file
            vim.cmd("vsplit ".. file)
        else
            print("HELLO")
            print("ERROR: No todo file in root directory")
        end
    else
        print("ERROR: Not a Git repository")
    end
end

M.set_current_task = function()
    vim.cmd('execute "normal! A\\<tab>\\<tab>(CURRENT)\\<esc>0"')
end

M.complete_task = function()
    -- Delete CURRENT and and x in the brackets
    vim.cmd('execute "normal! $da(F[lrx0"')
    -- Add time of completion
    vim.cmd("let @x=strftime('%c')")
    local date_time = vim.fn.getreg('x')
    print(date_time)
    local command = 'execute "normal! $a<' .. date_time  .. '>\"'
    vim.cmd(command)
end



return M
