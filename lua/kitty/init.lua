vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  -- {
  --   "NvChad/NvChad",
  --   lazy = false,
  --   branch = "v2.5",
  --   import = "nvchad.plugins",
  -- },
  {
    "folke/flash.nvim",
    event = "User FilePost",
    opts = {
      modes = {
        search = {
          enabled = false,
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
    },
  },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- require "options"
vim.opt.encoding = "utf-8"
vim.opt.clipboard = "unnamedplus"
vim.opt.compatible = false
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.laststatus = 0
vim.opt.showcmd = false
vim.opt.scrollback = 100000


vim.schedule(function()
  -- require "mappings"
end)


vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})
