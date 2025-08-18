-- === 外观设置 ===
vim.o.relativenumber = true                         -- Relative line numbers

-- === 命令行和菜单 ===
vim.o.completeopt = "menuone,noinsert,noselect"     -- Completion options
vim.o.pumheight = 20                                -- Popup menu height

-- === 显示和滚动 ===
vim.o.wrap = false                                  -- Don't wrap long lines
vim.o.linebreak = true                              -- Break lines at word boundaries
vim.o.scrolloff = 10                                -- Keep 10 lines above/below cursor
vim.o.sidescrolloff = 8                             -- Keep 8 columns left/right of cursor

-- === 搜索设置 ===
vim.o.hlsearch = false                              -- Don't highlight search results

-- === 折叠设置 ===
vim.wo.foldmethod = 'expr'                          -- Use expression for folding
vim.wo.foldlevel = 999                              -- Start with all folds open
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- Use treesitter for folding

-- === 文件处理 ===
vim.o.writebackup = false                           -- Don't create backup before writing
vim.o.swapfile = false                              -- Don't create swap files

-- === 行为设置 ===
vim.o.confirm = true                                -- Get alert when quit on an unsaved buffer
vim.o.inccommand = 'nosplit'                        -- Preview substitutions live
vim.opt.shortmess:append("c")                       -- Don't show completion messages
-- vim.o.virtualedit = 'block'                      -- Useful for block selections

-- === 特殊字符显示 ===
vim.o.list = true                                   -- Show invisible characters
vim.opt.listchars = {
  tab = '» ',                                       -- Show tabs
  trail = '·',                                      -- Show trailing spaces
  nbsp = '␣',                                       -- Show non-breaking spaces
  extends = '→',                                    -- Show when line extends beyond screen
  precedes = '←',                                   -- Show when line precedes screen
}
vim.opt.fillchars = {
  eob = " ",                                        -- Remove ~ at end of buffer
  diff = " "                                        -- Better diff separator
}

vim.g.health = { style = 'float' }
vim.g.vscode_snippets_path = vim.fn.stdpath "config" .. "/snippets"
