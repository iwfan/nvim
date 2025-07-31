local map = vim.keymap.set

-- Better vertical movement
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Better search behavior
local search_modes = { 'n', 'x', 'o' }
map(search_modes, 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map(search_modes, 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

-- Emacs-style keybindings
local emacs_insert = {
    ['<C-f>'] = { '<Right>', 'Move Right' },
    ['<C-d>'] = { '<Del>', 'Delete' },
    ['<C-v>'] = { '<C-r>+', 'Paste from clipboard' },
    ['<S-tab>'] = { '<BS>', 'Mapped to backspace' },
}

for key, mapping in pairs(emacs_insert) do
    map('i', key, mapping[1], { desc = mapping[2] })
end

-- Emacs-like keybinding for normal mode
-- for short finger
map({ "n", "v", "o" }, "H", "_")
map({ "n", "v", "o" }, "L", "g_")

-- Move lines up/down
map("n", "<A-j>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- Better indenting in visual mode
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Comment Line & Block
map("n", "<C-/>", "gcc", { remap = true, desc = "commentline" })
map("v", "<C-/>", "gc", { remap = true, desc = "comment visual" })

-- window management
map("n", "<C-h>", [[<c-w>h]], { desc = "Go to top window" })
map("n", "<C-l>", [[<c-w>l]], { desc = "Go to right window" })
map("n", "<C-j>", [[<c-w>j]], { desc = "Go to left window" })
map("n", "<C-k>", [[<c-w>k]], { desc = "Go to bottom window" })
map("n", "<A-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<A-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<A-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<A-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Terminal mode navigation
map('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Terminal left window nav' })
map('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Terminal down window nav' })
map('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Terminal up window nav' })
map('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Terminal right window nav' })
map('t', '<C-]>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- misc
map("n", "q", "<Nop>")
map("n", "Q", "q")
map("n", "gq", "<Nop>", { desc = "Do not open operation mode" })
map("n", "gQ", "Q", { desc = "Do not open Ex mode" })
map("n", "<esc>", "<esc><cmd>noh<CR><cmd>call feedkeys(':','nx')<CR>", { desc = "Clear all" })
map("x", "p", [[p:let @+=@0<CR>:let @"=@0<CR>]], { desc = "Dont copy replaced text" })
map("n", "qr", [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<space><bs>", [["_dd]])
map("n", "[<space>", ":<c-u>put! =repeat(nr2char(10), v:count1)<CR>'[", { silent = true })
map("n", "]<space>", ":<c-u>put =repeat(nr2char(10), v:count1)<CR>", { silent = true })

-- Disabled keys
map("n", "<C-q>", "<Nop>")
map("n", "<C-y>", "<Nop>")
map("n", "<C-t>", "<Nop>")
map("n", "<C-,>", "<Nop>")
map("n", "<C-.>", "<Nop>")
map("n", "<C-;>", "<Nop>")
map("n", "<C-'>", "<Nop>")

map("n", "<leader>p", "<cmd>Telescope enhanced_find_files<cr>", { desc = "telescope find files" })
map("n", "<leader>/", "<cmd>Telescope live_grep<cr>", { desc = "telescope find files" })
map("n", "<leader>g", "<cmd>Neogit<cr>", { desc = "Open Neogit" })
vim.keymap.del("n", "<leader>pt")
vim.keymap.del("n", "<leader>gt")

