-- Install packer
local install_path = os.getenv('HOME') .. '/nix-neovim/local/share/nvim/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd [[
set runtimepath-=~/.config/nvim
set runtimepath-=~/.config/nvim/after
set runtimepath-=~/.local/share/nvim/site
set runtimepath-=~/.local/share/nvim/site/after

set runtimepath+=~/nix-neovim/config/nvim/after
set runtimepath^=~/nix-neovim/config/nvim
set runtimepath+=~/nix-neovim/local/share/nvim/site/after
set runtimepath^=~/nix-neovim/local/share/nvim/site

set packpath-=~/.config/nvim
set packpath-=~/.config/nvim/after
set packpath-=~/.local/share/nvim/site
set packpath-=~/.local/share/nvim/site/after

set packpath^=~/nix-neovim/config/nvim
set packpath+=~/nix-neovim/config/nvim/after
set packpath^=~/nix-neovim/local/share/nvim/site
set packpath+=~/nix-neovim/local/share/nvim/site/after
]]

vim.api.nvim_exec(
  [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
    augroup end
]],
  false
)
-- Why do this? https://dev.to/creativenull/installing-neovim-nightly-alongside-stable-10d0
-- A little more context, if you have a different location for your init.lua outside ~/.config/nvim
-- in my case, this is ~/nix-neovim/config/nvim - you may want to set a custom location for packer
local packer = require 'packer'
packer.init {
  package_root = os.getenv('HOME') .. '/nix-neovim/local/share/nvim/site/pack',
  compile_path = os.getenv('HOME') .. '/nix-neovim/config/nvim/plugin/packer_compiled.vim'
}

local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Package manager
  use 'kdheepak/lazygit.nvim' -- Git commands in nvim
  use 'tpope/vim-fugitive' -- Git commands in nvim
  use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
  use 'tpope/vim-commentary' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sensible'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-surround'
  use 'tpope/vim-rsi'
  use 'tpope/vim-repeat'
  use 'christoomey/vim-tmux-navigator'
  use 'roxma/vim-tmux-clipboard'
  -- use 'ludovicchabant/vim-gutentags' -- Automatic tags management
  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } } }
  -- themes --
  use 'joshdick/onedark.vim' -- Theme inspired by Atom
  use 'morhetz/gruvbox'
  use 'sainnhe/gruvbox-material'
  use 'dracula/vim'
  use 'NLKNguyen/papercolor-theme'
  -- use 'itchyny/lightline.vim' -- Fancier statusline
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'
  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
  use 'jreybert/vimagit'
  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use 'nvim-treesitter/nvim-treesitter'
  use 'nvim-treesitter/playground'
  -- vim plugin which shows a git diff in the sign solumn
  use 'airblade/vim-gitgutter'
  -- working with sql databases
  use 'tpope/vim-dadbod' -- a more modern take on dbext.vim
  use { "kristijanhusak/vim-dadbod-completion" }
  use { "kristijanhusak/vim-dadbod-ui" }
  -- fzf
  use { "junegunn/fzf" }
  use { 'junegunn/fzf.vim', requires = 'junegunn/fzf' }
  use 'Olical/conjure'
end)

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.g.onedark_terminal_italics = 2
-- vim.cmd [[colorscheme onedark]]
-- vim.cmd [[colorscheme PaperColor]]
-- vim.cmd [[colorscheme gruvbox-material]]
vim.cmd [[
colorscheme PaperColor
set background=dark
]]

vim.cmd [[
set nobackup
set nowritebackup
set noswapfile
]]

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

--Add leader shortcuts
vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })

vim.cmd [[
nmap <leader><Tab> :b#<cr>
nmap <leader>w :w<cr>
nmap <leader>fs :w<cr>
set clipboard+=unnamedplus
]]
-- airline settings
vim.cmd [[
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#fnametruncate = 16
let g:airline#extensions#tabline#fnamecollapse = 2

let g:airline#extensions#tabline#buffer_idx_mode = 1

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
]]

vim.cmd [[
au FileType python setlocal equalprg=black\ -\ 2>/dev/null
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
au FileType xml :set sw=4 ts=4 et
au FileType html :set sw=4 ts=4 et
au FileType javascript :set sw=4 ts=4 et
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set smartindent
set autoindent
set cindent
set expandtab
]]

vim.cmd [[
nmap <leader>ff :Files<cr>
nmap <leader>* :Ag <c-r>=expand("<cword>")<cr><cr>
nmap <leader>// :Ag<space>
]]
