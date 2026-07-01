-- =============================================================================
-- init.lua — Neovim Configuration (lazy.nvim)
-- =============================================================================
-- Prerequisites (install on system before first launch):
--   git, curl                  — bootstrap
--   ripgrep (rg)               — required by Telescope live grep
--   clangd                     — C/C++ LSP  (apt/brew install clangd)
--   golangci-lint              — Go linter (https://golangci-lint.run/install/)
--   make, gcc                  — required by telescope-fzf-native and avante builds
--
-- First-run steps:
--   1. nvim                    → lazy.nvim auto-installs all plugins
--   2. :MasonUpdate            → sync Mason registry
--   3. :GoInstallBinaries      → installs gopls, goimports, and other Go tools
-- =============================================================================

-- ─────────────────────────────────────────────────────────────────────────────
-- 0. LEADER KEY — must be set before lazy.nvim loads any plugin
-- ─────────────────────────────────────────────────────────────────────────────
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. BOOTSTRAP: lazy.nvim
-- ─────────────────────────────────────────────────────────────────────────────
local uv       = vim.uv or vim.loop
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not uv.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. PLUGINS
-- ─────────────────────────────────────────────────────────────────────────────
require('lazy').setup({

  -- ── LSP / Toolchain ────────────────────────────────────────────────────────
  {
    'mason-org/mason.nvim',
    build = ':MasonUpdate',
    opts  = {},
  },
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      ensure_installed = {
        'clangd', 'gopls', 'pyright',
        'jsonls', 'yamlls', 'taplo',
        -- ruff is installed via standalone binary (PEP 668 blocks pip on this system):
        --   curl -LsSf https://astral.sh/ruff/install.sh | sh
      },
    },
  },

  -- ── Completion ─────────────────────────────────────────────────────────────
  {
    'saghen/blink.cmp',
    version = '*',
    lazy    = false,
    opts    = {
      keymap     = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      sources    = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      snippets   = { preset = 'default' },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        menu          = { border = 'rounded' },
      },
      signature  = { enabled = true },
    },
  },

  -- ── Syntax Highlighting ────────────────────────────────────────────────────
  {
    'nvim-treesitter/nvim-treesitter',
    build  = ':TSUpdate',
    lazy   = false,
    config = function()
        require('nvim-treesitter').setup()

        require('nvim-treesitter').install({
          'c', 'cpp', 'go', 'python', 'lua',
          'json', 'yaml', 'toml', 'bash', 'markdown', 'vim',
        })

        vim.api.nvim_create_autocmd('FileType', {
          callback = function(args)
            local ok = pcall(vim.treesitter.start, args.buf)
            if ok then
              vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end,
        })
      end,
  },

  -- ── Colorscheme ────────────────────────────────────────────────────────────
  {
    'maxmx03/solarized.nvim',
    lazy     = false,
    priority = 1000,
    opts     = {
      -- Match the terminal background exactly. Ghostty uses the "Solarized
      -- Dark Patched" theme (background #001e27, see the ghostty role), while
      -- solarized.nvim defaults to standard Solarized base03 (#002b36) — that
      -- is lighter/greener and made nvim's background visibly differ from the
      -- shell. base03 is the Normal background, so overriding it makes the
      -- editor blend seamlessly into the terminal.
      on_colors = function(_colors)
        return { base03 = '#001e27' }
      end,
      -- Solarized renders most tokens in the base foreground, which looks flat.
      -- Remap the treesitter capture groups to distinct accents so functions,
      -- keywords, types, strings, etc. each get their own colour. `colors.*`
      -- resolves against the active palette, so this stays internally consistent.
      on_highlights = function(colors, _color)
        return {
          -- functions / methods
          ['@function']            = { fg = colors.blue,    bold = true },
          ['@function.call']       = { fg = colors.blue },
          ['@function.builtin']    = { fg = colors.cyan },
          ['@function.method']     = { fg = colors.blue },
          ['@constructor']         = { fg = colors.yellow },

          -- keywords / control flow
          ['@keyword']             = { fg = colors.green,   bold = true },
          ['@keyword.function']    = { fg = colors.green,   bold = true },
          ['@keyword.return']      = { fg = colors.magenta, bold = true },
          ['@conditional']         = { fg = colors.green },
          ['@repeat']              = { fg = colors.green },
          ['@operator']            = { fg = colors.orange },

          -- types
          ['@type']                = { fg = colors.yellow },
          ['@type.builtin']        = { fg = colors.yellow,  bold = true },

          -- strings / numbers / constants
          ['@string']              = { fg = colors.cyan },
          ['@string.escape']       = { fg = colors.orange },
          ['@number']              = { fg = colors.magenta },
          ['@boolean']             = { fg = colors.magenta },
          ['@constant']            = { fg = colors.violet },
          ['@constant.builtin']    = { fg = colors.violet,  bold = true },

          -- variables / properties / params
          ['@variable']            = { fg = colors.base0 },
          ['@variable.member']     = { fg = colors.blue },   -- struct/obj fields
          ['@property']            = { fg = colors.blue },
          ['@parameter']           = { fg = colors.orange },

          -- punctuation / comments
          ['@punctuation.bracket'] = { fg = colors.base1 },
          ['@comment']             = { fg = colors.base01, italic = true },
        }
      end,
    },
    config   = function(_, opts)
      require('solarized').setup(opts)
    end,
  },

  -- ── File Tree ──────────────────────────────────────────────────────────────
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch       = 'v3.x',
    lazy         = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles   = false,
          hide_gitignored = true,
        },
        follow_current_file = { enabled = true },
      },
      window = {
        width    = 30,
        mappings = { ['<Space>'] = 'noop' },
      },
    },
  },

  -- ── Fuzzy Finder ───────────────────────────────────────────────────────────
  {
    'nvim-telescope/telescope.nvim',
    tag          = '0.1.8',
    lazy         = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      defaults = {
        layout_strategy = 'horizontal',
        layout_config   = { preview_width = 0.55 },
        path_display    = { 'truncate' },
      },
    },
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build        = 'make',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config       = function()
      require('telescope').load_extension('fzf')
    end,
  },

  -- ── Go tooling ─────────────────────────────────────────────────────────────
  {
    'fatih/vim-go',
    build = ':GoUpdateBinaries',
    ft    = { 'go' },
    init  = function()
      vim.g.go_fmt_command          = 'goimports'
      vim.g.go_metalinter_command   = 'golangci-lint'
      vim.g.go_metalinter_autosave  = 0
      vim.g.go_highlight_types            = 1
      vim.g.go_highlight_fields           = 1
      vim.g.go_highlight_functions        = 1
      vim.g.go_highlight_function_calls   = 1
      vim.g.go_highlight_operators        = 1
      vim.g.go_highlight_extra_types      = 1
      vim.g.go_def_mapping_enabled  = 0
      vim.g.go_doc_popup_window     = 0
      vim.g.go_gopls_enabled        = 0
    end,
  },

  -- ── Test runner ────────────────────────────────────────────────────────────
  {
    'vim-test/vim-test',
    init = function()
      vim.g['test#strategy']             = 'neovim'
      vim.g['test#neovim#term_position'] = 'botright'
      vim.g['test#python#runner']        = 'pytest'
    end,
  },

  -- ── Git ────────────────────────────────────────────────────────────────────
  { 'tpope/vim-fugitive' },
  {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    opts = {
      signs = {
        add          = { text = '▎' },
        change       = { text = '▎' },
        delete       = { text = '' },
        topdelete    = { text = '' },
        changedelete = { text = '▎' },
      },
      on_attach = function(bufnr)
        local gs  = package.loaded.gitsigns
        local map = function(mode, l, r)
          vim.keymap.set(mode, l, r, { buffer = bufnr, silent = true })
        end
        map('n', ']h', gs.next_hunk)
        map('n', '[h', gs.prev_hunk)
        map('n', '<Leader>hs', gs.stage_hunk)
        map('n', '<Leader>hr', gs.reset_hunk)
        map('n', '<Leader>hp', gs.preview_hunk)
        map('n', '<Leader>hb', function() gs.blame_line({ full = true }) end)
        map('n', '<Leader>hd', gs.diffthis)
      end,
    },
  },

  -- ── Statusline ─────────────────────────────────────────────────────────────
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy         = false,
    config       = function()
      require('lualine').setup({
        options = {
          theme                = 'solarized_dark',
          section_separators   = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          globalstatus         = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { { 'filename', path = 1, symbols = { modified = ' ●', readonly = ' ', unnamed = '[No Name]' } } },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = { 'location' },
        },
      })
    end,
  },

  -- ── AI Assistant ───────────────────────────────────────────────────────────
  {
    'yetone/avante.nvim',
    lazy         = false,
    version      = false,
    build        = 'make',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'stevearc/dressing.nvim',
      'nvim-tree/nvim-web-devicons',
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = { file_types = { 'markdown', 'Avante' } },
        ft   = { 'markdown', 'Avante' },
      },
      {
        'HakonHarnes/img-clip.nvim',
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name  = false,
            drag_and_drop         = { insert_mode = true },
            use_absolute_path     = true,
          },
        },
      },
    },
    opts = {
      provider = 'claude',   -- requires ANTHROPIC_API_KEY env var
      behaviour = { auto_suggestions = false },
    },
  },

  -- ── Utilities ──────────────────────────────────────────────────────────────
  { 'jiangmiao/auto-pairs',  lazy = false },
  { 'tpope/vim-commentary',  lazy = false },
  { 'tpope/vim-surround',    lazy = false },

}, {
  ui = { border = 'rounded' },
})

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. GENERAL OPTIONS
-- ─────────────────────────────────────────────────────────────────────────────
local o = vim.opt

o.termguicolors  = true
o.encoding       = 'utf-8'
o.number         = true
o.relativenumber = false
o.signcolumn     = 'yes'
o.cursorline     = true
o.colorcolumn    = '101'
o.wrap           = false
o.scrolloff      = 8
o.sidescrolloff  = 8
o.updatetime     = 300
o.timeoutlen     = 500
o.hidden         = true
o.backup         = false
o.writebackup    = false
o.swapfile       = false
o.undofile       = true
o.undodir        = vim.fn.stdpath('data') .. '/undo'
o.clipboard      = 'unnamedplus'
o.mouse          = 'a'
o.splitright     = true
o.splitbelow     = true
o.incsearch      = true
o.hlsearch       = true
o.ignorecase     = true
o.smartcase      = true
o.cmdheight      = 1
o.showmode       = false

-- ─────────────────────────────────────────────────────────────────────────────
-- 4. CURSOR: block, blinking in all modes
-- ─────────────────────────────────────────────────────────────────────────────
o.guicursor = 'a:block-blinkwait400-blinkon250-blinkoff250'

-- ─────────────────────────────────────────────────────────────────────────────
-- 5. COLORSCHEME: Solarized Dark
-- ─────────────────────────────────────────────────────────────────────────────
vim.o.background = 'dark'
local ok_cs = pcall(vim.cmd.colorscheme, 'solarized')
if not ok_cs then
  vim.cmd('colorscheme default')
end

-- ─────────────────────────────────────────────────────────────────────────────
-- 6. INDENTATION
-- ─────────────────────────────────────────────────────────────────────────────
o.tabstop     = 4
o.shiftwidth  = 4
o.softtabstop = 4
o.expandtab   = true
o.smartindent = true
o.autoindent  = true

vim.api.nvim_create_autocmd('FileType', {
  pattern  = { 'javascript', 'typescript', 'html', 'css', 'yaml', 'json', 'lua', 'vim', 'xml' },
  callback = function()
    vim.opt_local.tabstop     = 2
    vim.opt_local.shiftwidth  = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab   = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern  = { 'python' },
  callback = function()
    vim.opt_local.colorcolumn = '80'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern  = { 'go' },
  callback = function()
    vim.opt_local.tabstop     = 4
    vim.opt_local.shiftwidth  = 4
    vim.opt_local.softtabstop = 0
    vim.opt_local.expandtab   = false  -- gofmt enforces tabs
  end,
})

-- ─────────────────────────────────────────────────────────────────────────────
-- 7. LSP (native vim.lsp.config API — Neovim 0.11+)
-- ─────────────────────────────────────────────────────────────────────────────
vim.lsp.config('clangd', {
  cmd          = { 'clangd', '--background-index', '--clang-tidy' },
  filetypes    = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
})

vim.lsp.config('gopls', {
  cmd          = { 'gopls' },
  filetypes    = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  settings     = {
    gopls = {
      analyses    = { unusedparams = true },
      staticcheck = true,
      gofumpt     = true,
    },
  },
})

vim.lsp.config('pyright', {
  cmd          = { 'pyright-langserver', '--stdio' },
  filetypes    = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  settings     = {
    pyright = { disableOrganizeImports = true },  -- ruff handles imports
    python  = { analysis = { ignore = { '*' } } }, -- ruff handles diagnostics
  },
})

vim.lsp.config('ruff', {
  cmd          = { 'ruff', 'server' },
  filetypes    = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
})

vim.lsp.config('jsonls', {
  cmd       = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
})

vim.lsp.config('yamlls', {
  cmd       = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml' },
})

vim.lsp.config('taplo', {
  cmd       = { 'taplo', 'lsp', 'stdio' },
  filetypes = { 'toml' },
})

vim.lsp.enable({ 'clangd', 'gopls', 'pyright', 'ruff', 'jsonls', 'yamlls', 'taplo' })

vim.diagnostic.config({
  virtual_text     = { prefix = '●' },
  signs            = true,
  update_in_insert = false,
  severity_sort    = true,
  float            = { border = 'rounded', source = true },
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local map = function(mode, l, r)
      vim.keymap.set(mode, l, r, { buffer = ev.buf, silent = true })
    end
    map('n', 'gd',         vim.lsp.buf.definition)
    map('n', 'gy',         vim.lsp.buf.type_definition)
    map('n', 'gi',         vim.lsp.buf.implementation)
    map('n', 'gr',         vim.lsp.buf.references)
    map('n', 'K',          vim.lsp.buf.hover)
    map('n', '[d',         vim.diagnostic.goto_prev)
    map('n', ']d',         vim.diagnostic.goto_next)
    map('n', '<Leader>rn', vim.lsp.buf.rename)
    map('n', '<Leader>ca', vim.lsp.buf.code_action)
    map('n', '<Leader>F',  function() vim.lsp.buf.format({ async = true }) end)
    map('v', '<Leader>F',  function() vim.lsp.buf.format({ async = true }) end)
    map('n', '<Leader>cd', vim.diagnostic.setloclist)
  end,
})

-- ─────────────────────────────────────────────────────────────────────────────
-- 8. CUSTOM COMMANDS
-- ─────────────────────────────────────────────────────────────────────────────
vim.api.nvim_create_user_command('Tox', function(opts)
  local args = opts.args ~= '' and ' ' .. opts.args or ''
  vim.cmd('botright split | terminal tox' .. args)
end, { nargs = '?' })

-- ─────────────────────────────────────────────────────────────────────────────
-- 9. KEYMAPS
-- ─────────────────────────────────────────────────────────────────────────────
local map = vim.keymap.set
local s   = { silent = true }

-- ── Pane navigation ───────────────────────────────────────────────────────────
map('n', '<Leader><Left>',  '<C-w>h', s)
map('n', '<Leader><Right>', '<C-w>l', s)
map('n', '<Leader><Up>',    '<C-w>k', s)
map('n', '<Leader><Down>',  '<C-w>j', s)

-- ── Buffer management ─────────────────────────────────────────────────────────
map('n', '<Leader>bn', ':bnext<CR>',   s)
map('n', '<Leader>bp', ':bprev<CR>',   s)
map('n', '<Leader>bd', ':bdelete<CR>', s)
map('n', '<Leader>bl', function() require('telescope.builtin').buffers() end, s)

-- ── File tree (neo-tree) ──────────────────────────────────────────────────────
map('n', '<Leader>e',  ':Neotree toggle<CR>', s)
map('n', '<Leader>ef', ':Neotree reveal<CR>',  s)

-- ── Fuzzy finder (Telescope) ──────────────────────────────────────────────────
local tb = function(f) return function() require('telescope.builtin')[f]() end end
map('n', '<Leader>ff', tb('find_files'),           s)   -- find file
map('n', '<Leader>fg', tb('live_grep'),            s)   -- live grep  (requires ripgrep)
map('n', '<Leader>fh', tb('oldfiles'),             s)   -- recently opened files
map('n', '<Leader>fc', tb('commands'),             s)   -- command palette
map('n', '<Leader>fs', tb('git_status'),           s)   -- git-modified files
map('n', '<Leader>fd', tb('diagnostics'),          s)   -- workspace diagnostics
map('n', '<Leader>fr', tb('lsp_references'),       s)   -- LSP references
map('n', '<Leader>fo', tb('lsp_document_symbols'), s)   -- document symbols

-- ── Testing ───────────────────────────────────────────────────────────────────
map('n', '<Leader>tn', ':TestNearest<CR>', s)
map('n', '<Leader>tf', ':TestFile<CR>',    s)
map('n', '<Leader>ts', ':TestSuite<CR>',   s)
map('n', '<Leader>tl', ':TestLast<CR>',    s)
map('n', '<Leader>tx', ':Tox<CR>',         s)

-- ── Terminal ──────────────────────────────────────────────────────────────────
map('n', '<Leader>th', ':split | terminal<CR>',  s)
map('n', '<Leader>tv', ':vsplit | terminal<CR>', s)
map('t', '<Esc>',      '<C-\\><C-n>',            s)

-- ── Go ────────────────────────────────────────────────────────────────────────
map('n', '<Leader>gl', ':GoMetaLinter<CR>', s)

-- ── Misc ──────────────────────────────────────────────────────────────────────
map('n', '<Esc>',     ':nohlsearch<CR>', s)
map('n', '<Leader>w', ':w<CR>',          s)
map('n', '<Leader>q', ':q<CR>',          s)
