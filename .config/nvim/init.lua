-- ~/.config/nvim/init.lua

-- ============================================================
-- Bootstrap lazy.nvim  
-- ============================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================
-- Options
-- ============================================================
local opt = vim.opt

opt.number         = true
opt.relativenumber = true
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.softtabstop    = 4
opt.expandtab      = true
opt.autoindent     = true
opt.smartindent    = true
opt.mouse          = "a"
opt.termguicolors  = true
opt.signcolumn     = "yes"
opt.updatetime     = 250
opt.scrolloff      = 8
opt.wrap           = false
opt.ignorecase     = true
opt.smartcase      = true
opt.splitbelow     = true
opt.splitright     = true
opt.swapfile       = false
opt.undofile       = true
opt.completeopt    = "menuone,noinsert,noselect"
opt.shortmess:append("c")

-- ============================================================
-- Autocmds
-- ============================================================

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- ============================================================
-- Keymaps
-- ============================================================
vim.keymap.set("n", "ff", ":GFiles<CR>",  { silent = true, desc = "Find git files" })
vim.keymap.set("n", "fs", ":RG<CR>",      { silent = true, desc = "Ripgrep search" })
vim.keymap.set("n", "fb", ":Buffers<CR>", { silent = true, desc = "Find open buffers" })

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- ============================================================
-- Plugins
-- ============================================================
require("lazy").setup({

  -- Colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")
    end,
  },

  -- Statusline + git signs in gutter
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "lewis6991/gitsigns.nvim" },
    config = function()
      require("gitsigns").setup()
      require("lualine").setup({
        options = {
          icons_enabled        = false,
          theme                = "gruvbox",
          component_separators = "|",
          section_separators   = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- FZF
  { "junegunn/fzf",     build = "./install --bin" },
  { "junegunn/fzf.vim" },

  -- Treesitter 
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "rust", "bash", "lua" },
        highlight        = { enable = true },
        indent           = { enable = true },
      })
    end,
  },

}, {
  ui = { border = "single" },
})

-- ============================================================
-- LSP
-- ============================================================
require("lsp")

