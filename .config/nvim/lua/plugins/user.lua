---@type LazySpec
return {
  { "andweeb/presence.nvim" },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "zathura"
    end,
  },
  {
    "swaits/universal-clipboard.nvim",
    opts = {
      verbose = false, -- optional: set true to log detection details
    },
  },
  { "elkowar/yuck.vim" },
  { "xiyaowong/transparent.nvim" },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function(_, opts)
  --     local esp32 = require "esp32"
  --     opts.servers = opts.servers or {}
  --     opts.servers.clangd = esp32.lsp_config()
  --     return opts
  --   end,
  -- },
}
