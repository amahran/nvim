local map = vim.keymap
local opts = { noremap = true, silent = true }

map.set("n", "<leader>pv", vim.cmd.Ex)

-- move stuff around faster
map.set("v", "J", ":m '>+1<CR>gv=gv")
map.set("v", "K", ":m '<-2<CR>gv=gv")

map.set("n", "J", "mzJ`z") -- keep the cursor in place when joining lines

-- always keep the cursor in the middle when half page scrolling
-- or navigating between the search hits
map.set("n", "<C-d>", "<C-d>zz")
map.set("n", "<C-u>", "<C-u>zz")
-- allow search terms to stay in the middle
map.set("n", "n", "nzzzv") -- zv -> expands any folds when the cursor is there
map.set("n", "N", "Nzzzv")

-- greatest remap ever
-- keep the yank register when pasting text over selected text and don't replace
-- it with the deleted text
map.set("x", "<leader>p", [["_dP]]) -- x for cahracter wise visual mode (enabled
-- with v), and v is for all visual modes (v, V, <C-v>)

-- next greatest remap ever : asbjornHaland
-- yank to the + register (the system clipboard)
map.set({"n", "v"}, "<leader>y", [["+y]])
map.set("n", "<leader>Y", [["+Y]]) -- Y is same as yy

-- delete to the void register so not saved anywhere
map.set({"n", "v"}, "<leader>d", [["_d]])

map.set("n", "Q", "<nop>")
map.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- quick fix navigating
-- TODO: figure out a consistent keymaps
map.set("n", "<C-n>", "<cmd>cnext<CR>zz")
map.set("n", "<C-p>", "<cmd>cprev<CR>zz")
map.set("n", "<leader>k", "<cmd>lnext<CR>zz")
map.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace the word under the cusrsor command
map.set("n", "<leader>cw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- make the file of the current buffer executable
map.set("n", "<leader>x", "<cmd>!chmod +x %<cr>", { silent = true })
map.set("n", "<leader>X", "<cmd>!chmod -x %<cr>", { silent = true })

map.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- remove the highlighted search
--map.set("n", "<c-l>", ":<c-u>nohlsearch<cr><c-l>")

-- quality of life, although not so much needed with telescope around
map.set("c", "%%", function()
    if (vim.fn.getcmdtype() == ':') then
        return vim.fn.expand('%:h') .. '/'
    else
        return '%%'
    end
end, { expr = true })

-- scratch buffers
local scratch_bufnr = nil
vim.keymap.set("n", "<leader>.", function()
  if scratch_bufnr and vim.api.nvim_buf_is_valid(scratch_bufnr) then
    -- If scratch buffer still exists, switch to it
    local win = vim.fn.bufwinid(scratch_bufnr)
    if win ~= -1 then
      vim.api.nvim_set_current_win(win)
    else
      vim.cmd("buffer " .. scratch_bufnr)
    end
  else
    -- Create a new scratch buffer
    vim.cmd("enew")
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "hide"
    vim.bo.swapfile = false
    vim.bo.modifiable = true
    vim.bo.readonly = false
    scratch_bufnr = vim.api.nvim_get_current_buf()
  end
end, { desc = "Open or switch to scratch buffer" })

-- what else would you do with the history window other than search
map.set('n', 'q:', 'q:?')
