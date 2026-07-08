-- Go uses tabs (gofmt). Pin display width so it's deterministic
-- and immune to guess-indent's per-file heuristic.
vim.bo.expandtab = false
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 0
