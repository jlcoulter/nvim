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
     "nvim-treesitter",
  beforeAll = function()
    _G.Paq.add({
      {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
      },
    })
  end,
  load = function(name)
    vim.cmd.packadd(name)
    vim.cmd.packadd("nvim-treesitter-textobjects")
  end,
  after = function()
    -- Note that some queries have dependencies, but if a dependency is
    -- deleted, it won't automatically be reinstalled
    require("nvim-treesitter").install({
      -- Bundled parsers
      "c",
      "lua",
      "markdown",
      "markdown_inline",
      "query",
      "vim",
      "vimdoc",
      -- Extra parsers
      "bash",
      "comment",
      "diff",
      "python",
      "todotxt",
      "vhdl",
      "xml",
    })

    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
      },
    })

    local function map(lhs, obj)
      vim.keymap.set({ "x", "o" }, lhs, function()
        require("nvim-treesitter-textobjects.select").select_textobject(
          obj,
          "textobjects"
        )
      end)
    end

    map("af", "@function.outer")
    map("if", "@function.inner")
    map("ac", "@class.inner")
    map("ic", "@class.inner")
    map("ar", "@parameter.inner")
    map("ir", "@parameter.inner")
    map("ak", "@block.inner")
    map("ik", "@block.inner")

    -- Register the todotxt parser to be used for text filetypes
    vim.treesitter.language.register("todotxt", "text")

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        if pcall(vim.treesitter.start) then
          -- Set indentexpr for queries that have an indents.scm, check in
          -- ~/.local/share/nvim/site/queries/QUERY/
          -- Hopefully this will happen automatically in the future
          if
            ({
              c = true,
              lua = true,
              markdown = true,
              python = true,
              query = true,
              xml = true,
            })[ev.match]
          then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end
      end,
    })
  end,
      },

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
