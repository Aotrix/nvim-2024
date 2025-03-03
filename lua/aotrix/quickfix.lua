local quickfix_is_open = false;
vim.api.nvim_create_autocmd('BufWinEnter', {
    pattern = 'quickfix',
    callback = function(args) quickfix_is_open = true end
})
vim.api.nvim_create_autocmd('BufWinLeave', {
    pattern = 'quickfix',
    callback = function(args) quickfix_is_open = false end
})
local nb_elements_quickfix = 0;
vim.api.nvim_create_autocmd('DiagnosticChanged', {
    callback = function(args)
        nb_elements_quickfix = #vim.diagnostic.get()
        if quickfix_is_open then
            if nb_elements_quickfix == 0 then
                quickfix_is_open = false
                vim.cmd.cclose()
            else
                vim.diagnostic.setqflist()
            end
        end
    end
})
vim.keymap.set("n", "<leader>q", function()
    if #vim.diagnostic.get() > 0 then
        if quickfix_is_open then
            vim.cmd.cclose()
            quickfix_is_open = false
        else
            vim.diagnostic.setqflist()
            vim.cmd.cfirst()
        end
    end
end)
vim.keymap.set("n", "<M-j>", function()
    if #vim.diagnostic.get() > 0 and quickfix_is_open then
        if #vim.diagnostic.get() == 1 then
            vim.cmd.cfirst()
        else
            vim.diagnostic.goto_next({float = false})
        end
    end
end)
vim.keymap.set("n", "<M-k>", function()
    if #vim.diagnostic.get() > 0 and quickfix_is_open then
        if #vim.diagnostic.get() == 1 then
            vim.cmd.cfirst()
        else
            vim.diagnostic.goto_prev({float = false})
        end
    end
end)
