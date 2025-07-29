local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "goimports", "gofmt" },
    python = { "ruff_format" },
    -- Use the "*" filetype to run formatters on all filetypes.
    ["*"] = { "typos" },
    -- Use the "_" filetype to run formatters on filetypes that don't
    -- have other formatters configured.
    ["_"] = { "trim_whitespace" },
  },
}

return options
