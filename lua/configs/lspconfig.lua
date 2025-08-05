require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "tailwindcss",
  "vtsls",
  -- "eslint",
  "lua_ls",
  "gopls",
  "pylsp",
  "pyright",
}

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("<space><enter>", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

    map("\\d", vim.diagnostic.open_float, "Hover")
  end,
})
