local M = {}

function M.is_active()
    local winid = vim.api.nvim_get_current_win()
    local curwin = tonumber(vim.g.actual_curwin)
    return winid == curwin
end

local function pattern_list_match(str, pattern_list)
    for _, pattern in ipairs(pattern_list) do
        if str:find(pattern) then
            return true
        end
    end
    return false
end

local buf_matchers = {
    filetype = function(pattern_list)
        local ft = vim.bo.filetype
        return pattern_list_match(ft, pattern_list)
    end,
    buftype = function(pattern_list)
        local bt = vim.bo.buftype
        return pattern_list_match(bt, pattern_list)
    end,
    bufname = function(pattern_list)
        local bn = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
        return pattern_list_match(bn, pattern_list)
    end,
}


function M.buffer_matches(patterns)
    for kind, pattern_list in pairs(patterns) do
        if buf_matchers[kind](pattern_list) then
            return true
        end
    end
    return false
end

function M.width_percent_below(n, thresh)
    local winwidth = vim.api.nvim_win_get_width(0)
    return n / winwidth <= thresh
end

function M.is_git_repo()
    return vim.b.gitsigns_head or vim.b.gitsigns_status_dict
end

function M.has_diagnostics()
    return #vim.diagnostic.get(0) > 0
end

function M.lsp_attached()
    return #vim.lsp.buf_get_clients() > 0
end


return M
