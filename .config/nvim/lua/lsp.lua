-- ~/.config/nvim/lua/lsp.lua

-- ============================================================
-- Diagnostics display
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

-- ============================================================
-- Keymaps applied whenever an LSP attaches to a buffer
-- ============================================================
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
    map("n", "[d", vim.diagnostic.goto_prev,  "Previous diagnostic")
    map("n", "]d", vim.diagnostic.goto_next,  "Next diagnostic")
    map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic")
  end,
})

-- ============================================================
-- C / C++
-- ============================================================
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

-- ============================================================
-- Rust
-- ============================================================
vim.lsp.config.rust_analyzer = {
  cmd       = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json" },
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
    },
  },
}
vim.lsp.enable("rust_analyzer")

-- ============================================================
-- Bash
-- ============================================================
vim.lsp.config.bashls = {
  cmd       = { "bash-language-server", "start" },
  filetypes = { "sh", "bash", "zsh" },
  root_markers = { ".git" },
}
vim.lsp.enable("bashls")

