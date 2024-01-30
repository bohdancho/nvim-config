vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamed"
vim.opt.fillchars = { eob = " " }
vim.opt.formatoptions:remove { "c", "r", "o" }
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup { { import = "plugins" }, { import = "plugins.language" } }

require("mappings").load "general"
--local general_mappings = require("mappings").general
--require("utils").set_mappings(general_mappings)
