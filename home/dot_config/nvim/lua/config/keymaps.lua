local map = vim.keymap.set

-- Set space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Move between windows
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Move lines up and down in visual mode
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- Keep cursor centred when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

-- Clear search highlight
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Better indenting in visual mode (stay in visual mode after indent)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
