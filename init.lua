-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.clipboard = "unnamedplus"

vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("bashls")
vim.lsp.enable("jsonls")

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    {
      "folke/tokyonight.nvim",
      priority = 1000,
      config = function()
        vim.cmd.colorscheme("tokyonight")
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.6",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.find_files)
        vim.keymap.set("n", "<leader>fg", builtin.live_grep)
        vim.keymap.set("n", "<leader>fb", builtin.buffers)
      end,
     },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      opts = {
        ensure_installed = { "lua", "vim", "python", "json" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
    },
    
          {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
},
{
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "tokyonight" },
      })
    end,
  },

    {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "bashls", "jsonls" },
      })
    end,
  },
 {
  'stevearc/conform.nvim',
  opts = {},
},

{
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = 'super-tab' },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = false } },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" }
}, 
{
  "mfussenegger/nvim-lint",
  opts = {
    -- Event to trigger linters
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      fish = { "fish" },
      json = { "jsonlint" },
      -- Use the "*" filetype to run linters on all filetypes.
      -- ['*'] = { 'global linter' },
      -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
      -- ['_'] = { 'fallback linter' },
      -- ["*"] = { "typos" },
    },
    -- LazyVim extension to easily override linter options
    -- or add custom linters.
    ---@type table<string,table>
    linters = {
      -- -- Example of using selene only when a selene.toml file is present
      -- selene = {
      --   -- `condition` is another LazyVim extension that allows you to
      --   -- dynamically enable/disable linters based on the context.
      --   condition = function(ctx)
      --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
      --   end,
      -- },
    },
  },
  config = function(_, opts)
    local M = {}

    local lint = require("lint")
    for name, linter in pairs(opts.linters) do
      if type(linter) == "table" and type(lint.linters[name]) == "table" then
        lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
        if type(linter.prepend_args) == "table" then
          lint.linters[name].args = lint.linters[name].args or {}
          vim.list_extend(lint.linters[name].args, linter.prepend_args)
        end
      else
        lint.linters[name] = linter
      end
    end
    lint.linters_by_ft = opts.linters_by_ft

    function M.debounce(ms, fn)
      local timer = vim.uv.new_timer()
      return function(...)
        local argv = { ... }
        timer:start(ms, 0, function()
          timer:stop()
          vim.schedule_wrap(fn)(unpack(argv))
        end)
      end
    end

    function M.lint()
      -- Use nvim-lint's logic first:
      -- * checks if linters exist for the full filetype first
      -- * otherwise will split filetype by "." and add all those linters
      -- * this differs from conform.nvim which only uses the first filetype that has a formatter
      local names = lint._resolve_linter_by_ft(vim.bo.filetype)

      -- Create a copy of the names table to avoid modifying the original.
      names = vim.list_extend({}, names)

      -- Add fallback linters.
      if #names == 0 then
        vim.list_extend(names, lint.linters_by_ft["_"] or {})
      end

      -- Add global linters.
      vim.list_extend(names, lint.linters_by_ft["*"] or {})

      -- Filter out linters that don't exist or don't match the condition.
      local ctx = { filename = vim.api.nvim_buf_get_name(0) }
      ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
      names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if not linter then
          LazyVim.warn("Linter not found: " .. name, { title = "nvim-lint" })
        end
        return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
      end, names)

      -- Run linters.
      if #names > 0 then
        lint.try_lint(names)
      end
    end

    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = M.debounce(100, M.lint),
    })
  end,
},

{
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
      end,
      mode = { "n", "x" },
      desc = "Format Injected Langs",
    },
  },
  init = function()
    -- Install the conform formatter on VeryLazy
    LazyVim.on_very_lazy(function()
      LazyVim.format.register({
        name = "conform.nvim",
        priority = 100,
        primary = true,
        format = function(buf)
          require("conform").format({ bufnr = buf })
        end,
        sources = function(buf)
          local ret = require("conform").list_formatters(buf)
          ---@param v conform.FormatterInfo
          return vim.tbl_map(function(v)
            return v.name
          end, ret)
        end,
      })
    end)
  end,
  opts = function()
    local plugin = require("lazy.core.config").plugins["conform.nvim"]
    if plugin.config ~= M.setup then
      LazyVim.error({
        "Don't set `plugin.config` for `conform.nvim`.\n",
        "This will break **LazyVim** formatting.\n",
        "Please refer to the docs at https://www.lazyvim.org/plugins/formatting",
      }, { title = "LazyVim" })
    end
    ---@type conform.setupOpts
    local opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
      },
      -- The options you set here will be merged with the builtin formatters.
      -- You can also define any custom formatters here.
      ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
      formatters = {
        injected = { options = { ignore_errors = true } },
        -- # Example of using dprint only when a dprint.json file is present
        -- dprint = {
        --   condition = function(ctx)
        --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
        --
        -- # Example of using shfmt with extra args
        -- shfmt = {
        --   prepend_args = { "-i", "2", "-ci" },
        -- },
      },
    }
    return opts
  end,
  config = M.setup,
}
  }
}
})
