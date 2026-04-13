-- ~/.config/nvim/init.lua

local gh = function(x) return "https://github.com/" .. x end

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
opt.scrolloff      = 0
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

-- trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- ============================================================
-- keymaps
-- ============================================================
vim.keymap.set("n", "ff", ":GFiles<CR>",  { silent = true, desc = "Find git files" })
vim.keymap.set("n", "fs", ":RG<CR>",      { silent = true, desc = "Ripgrep search" })
vim.keymap.set("n", "fb", ":Buffers<CR>", { silent = true, desc = "Find open buffers" })

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- ============================================================
-- plugins
-- ============================================================

vim.pack.add({
  -- colorscheme
  gh("ellisonleao/gruvbox.nvim"),

  -- statusline
  gh("nvim-lualine/lualine.nvim"),

  -- fzf
  gh("junegunn/fzf"),
  gh("junegunn/fzf.vim"),

  -- treesitter
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
})

-- colorscheme
vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")

-- lualine
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

-- treesitter
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- treesitter: auto-install missing parsers on startup
do
  local wanted = { "c", "cpp", "rust", "bash", "lua" }
  local installed = require("nvim-treesitter.config").get_installed()
  local to_install = vim.iter(wanted)
    :filter(function(p) return not vim.tbl_contains(installed, p) end)
    :totable()
  if #to_install > 0 then
    require("nvim-treesitter").install(to_install)
  end
end

require('vim._core.ui2').enable({})

-- ============================================================
-- lsp
-- ============================================================

vim.diagnostic.config({
  virtual_text     = true,
  update_in_insert = true,
  underline        = false,
  severity_sort    = true,
  float = {
    focusable = false,
    style     = "minimal",
    border    = "single",
    source    = "always",
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
    end

    map("n", "gd",        vim.lsp.buf.definition,     "Go to definition")
    map("n", "gD",        vim.lsp.buf.declaration,    "Go to declaration")
    map("n", "gr",        vim.lsp.buf.references,     "List references")
    map("n", "gi",        vim.lsp.buf.implementation, "Go to implementation")
    map("n", "K",         vim.lsp.buf.hover,          "Hover docs")
    map("n", "<leader>r", vim.lsp.buf.rename,         "Rename symbol")
    map("n", "<leader>a", vim.lsp.buf.code_action,    "Code action")
    map("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, "Format file")

    map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
    map("n", "]d", function() vim.diagnostic.jump({ count = 1,  float = true }) end, "Next diagnostic")
    map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic")

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "rust_analyzer" then
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(buf) then
          vim.lsp.inlay_hint.enable(true, { bufnr = buf })
        end
      end, 5000)
    end
  end,
})

-- C / C++
vim.lsp.config.clangd = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--all-scopes-completion",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
  },
  filetypes    = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_markers = {
    "CMakeLists.txt", ".clangd", ".clang-tidy", ".clang-format",
    "compile_commands.json", "compile_flags.txt", ".git",
  },
}
vim.lsp.enable("clangd")

-- Rust
vim.lsp.config.rust_analyzer = {
  cmd       = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json" },
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
      inlayHints = {
        chainingHints = { enable = true },
      },
    },
  },
}
vim.lsp.enable("rust_analyzer")

-- Bash
vim.lsp.config.bashls = {
  cmd       = { "bash-language-server", "start" },
  filetypes = { "sh", "bash", "zsh" },
  root_markers = { ".git" },
}
vim.lsp.enable("bashls")

