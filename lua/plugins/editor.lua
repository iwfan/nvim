return {
  { "nvim-lua/plenary.nvim" },
  { "tpope/vim-repeat" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "astro",
        "bash",
        "beancount",
        "comment",
        "css",
        "diff",
        "dockerfile",
        "fish",
        "go",
        "gomod",
        "gowork",
        "graphql",
        "html",
        "markdown",
        "markdown_inline",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "jsonc",
        "latex",
        "lua",
        "luadoc",
        "python",
        "ruby",
        "rust",
        "scss",
        "sql",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
        "yaml",
        "regex",
      },
      sync_install = false,
      auto_install = true,
      ignore_install = {},
      modules = {},
      highlight = {
        enable = true,
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<cr>",
          node_incremental = "<cr>",
          node_decremental = "<s-cr>",
          scope_incremental = false,
        },
      },
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["a?"] = "@conditional.outer",
            ["i?"] = "@conditional.inner",
            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
          },
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true or false
          include_surrounding_whitespace = true,
        },
        move = {
          enable = false,
          set_jumps = true,
          goto_next_start = {
            ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
          },
          goto_next_end = {
            ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
          },
          goto_previous_start = {
            ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
          },
          goto_previous_end = {
            ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
          },
          swap_previous = {
            ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
          },
        },
      },
      matchup = {
        enable = not vim.g.vscode,
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "User FilePost",
    opts = {},
  },
  {
    "MagicDuck/grug-far.nvim",
    event = "User FilePost",
    opts = {
      windowCreationCommand = "botright split",
      transient = true,
    },
    keys = {
      {
        "<A-f>",
        mode = "n",
        function()
          require("grug-far").open { prefills = { search = vim.fn.expand "<cword>" } }
        end,
        desc = "Spectre",
      },
      {
        "<A-f>",
        mode = "v",
        function()
          require("grug-far").with_visual_selection { prefills = { paths = vim.fn.expand "%" } }
        end,
        desc = "Spectre",
      },
    },
  },
  {
    "andymass/vim-matchup",
    event = "User FilePost",
    config = function()
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },
  {
    "mg979/vim-visual-multi",
    event = "User FilePost",
    init = function()
      vim.g.VM_default_mappings = 0
      vim.g.VM_maps = {
        ["Add Cursor Down"] = "<A-n>",
        ["Add Cursor Up"] = "<A-p>",
      }
    end,
  },
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
          require("flash").jump { multi_window = false }
        end,
        desc = "Flash",
      },
    },
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "User FilePost",
    enabled = vim.fn.has "nvim-0.10.0" == 1,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
  },
  {
    "johmsalas/text-case.nvim",
    opts = {},
  },
}
