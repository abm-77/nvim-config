local M = {}

local cmd = vim.cmd

function M.create_augroup(autocmds, name)
    cmd('augroup' .. name)
    cmd('autocmd!')
    for _, autocmd in ipairs(autocmd) do
        cmd('autocmd' .. table.concat(autocmd, ' '))
    end
    cmd('augroup END')
end

function M.create_scratch_buffer_tab()
    cmd('tabnew')
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "hide"
    cmd('set noswapfile')
end

function M.create_scratch_buffer_window()
    cmd('vsplit scratch')
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "hide"
    cmd('set noswapfile')
end

return M
