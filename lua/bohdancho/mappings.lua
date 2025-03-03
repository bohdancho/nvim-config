vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<leader>q", "<C-w>q")

-- insert a line break in normal mode, but not in quickfix list
vim.cmd [[ autocmd FileType qf nnoremap <buffer> <CR> :cc <C-R>=line('.')<CR><CR> ]]
vim.keymap.set("n", "<cr>", "i<cr><esc>")

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using <cmd> :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
vim.keymap.set("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
vim.keymap.set("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+y$]])
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])
vim.keymap.set({ "n", "v" }, "<leader>P", [["+P]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
-- Put the contents of main yank register to the system clipboard one
-- don't yank anything new, just use :let @+ = @"
vim.keymap.set(
    "n",
    "<leader>fy",
    [[<cmd>let @+ = @"<CR>]],
    { desc = "[f]ix [y]ank - Copy from main yank register to the system clipboard one" }
)

vim.keymap.set("v", "p", "P", { desc = "Dont copy replaced text" })
vim.keymap.set("v", "P", "p", { desc = "Do copy replaced text" })
vim.keymap.set("n", "x", '"_x', { noremap = true })

vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move left" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move right" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move down" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move up" })

vim.keymap.set("t", "<C-x>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), { desc = "Escape terminal mode" })

vim.keymap.set("n", "[q", "<cmd>cprevious<cr>", { desc = "Quickfix previous" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Quickfix next" })

vim.keymap.set("n", "<leader>cwc", "sa'(sa({acn<C-C><C-C>l%i,<Space>", { remap = true, desc = "[C]ode [W]rap with [c]n" })

vim.keymap.set(
    "n",
    "<leader>lq",
    [[<cmd>cexpr systemlist('bunx tsc | grep -o "src/[^\(]*" | sed "s/$/:0:0/" | uniq')<cr><cmd>copen<cr>]],
    { desc = "LSP: tsc [q]uickfix" }
)
