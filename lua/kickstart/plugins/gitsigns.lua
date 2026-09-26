-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        -- <leader>hd / <leader>hD toggle: a second press (from either pane) closes the diff
        local function close_diff()
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)):match '^gitsigns://' then
              vim.api.nvim_win_close(win, true)
              vim.cmd 'diffoff!' -- don't leave the working file stuck in diff mode
              return true
            end
          end
          return false
        end
        local function toggle_diff(base)
          if not close_diff() then
            gitsigns.diffthis(base)
          end
        end
        map('n', '<leader>hd', function()
          toggle_diff()
        end, { desc = 'git [d]iff against index (toggle)' })
        map('n', '<leader>hD', function()
          toggle_diff '@'
        end, { desc = 'git [D]iff against last commit (toggle)' })
        -- gitsigns doesn't attach to its own diff buffer, so the maps above don't exist there
        vim.api.nvim_create_autocmd('BufWinEnter', {
          group = vim.api.nvim_create_augroup('gitsigns-diff-close', { clear = true }),
          pattern = 'gitsigns://*',
          callback = function(ev)
            for _, lhs in ipairs { 'q', '<leader>hd', '<leader>hD' } do
              vim.keymap.set('n', lhs, close_diff, { buffer = ev.buf, desc = 'Close git diff' })
            end
          end,
        })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
}
