-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "C:\\Users\\ELVHIL\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.1707061634\\share\\lua\\5.1\\?.lua;C:\\Users\\ELVHIL\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.1707061634\\share\\lua\\5.1\\?\\init.lua;C:\\Users\\ELVHIL\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.1707061634\\lib\\luarocks\\rocks-5.1\\?.lua;C:\\Users\\ELVHIL\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.1707061634\\lib\\luarocks\\rocks-5.1\\?\\init.lua"
local install_cpath_pattern = "C:\\Users\\ELVHIL\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.1707061634\\lib\\lua\\5.1\\?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason-nvim-dap.nvim"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\mason-nvim-dap.nvim",
    url = "https://github.com/jay-babu/mason-nvim-dap.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["neodev.nvim"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\neodev.nvim",
    url = "https://github.com/folke/neodev.nvim"
  },
  neogen = {
    config = { "\27LJ\2\nR\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\19snippet_engine\fluasnip\nsetup\vneogen\frequire\0" },
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\neogen",
    url = "https://github.com/danymat/neogen"
  },
  neotest = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\neotest",
    url = "https://github.com/nvim-neotest/neotest"
  },
  ["neotest-dotnet"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\neotest-dotnet",
    url = "https://github.com/Issafalcon/neotest-dotnet"
  },
  nightfox = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\25colorscheme nightfox\bcmd\bvim\0" },
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nightfox",
    url = "https://github.com/EdenEast/nightfox.nvim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-ui"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-treesitter-refactor",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-treesitter-textsubjects"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-treesitter-textsubjects",
    url = "https://github.com/RRethy/nvim-treesitter-textsubjects"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["nx.nvim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\anx\frequire\0" },
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nx.nvim",
    url = "https://github.com/Equilibris/nx.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["rest.nvim"] = {
    config = { "\27LJ\2\n>\0\1\5\0\4\0\0066\1\0\0009\1\1\0019\1\2\0015\3\3\0\18\4\0\0D\1\3\0\1\5\0\0\ttidy\a-i\a-q\6-\vsystem\afn\bvim¿\3\1\0\6\0\r\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0005\4\a\0003\5\b\0=\5\t\4=\4\n\3=\3\v\0024\3\0\0=\3\f\2B\0\2\1K\0\1\0\29custom_dynamic_variables\vresult\15formatters\thtml\0\1\0\2\tjson\ajq\thtml\0\1\0\5\15formatters\0\17show_headers\2\19show_http_info\2\22show_curl_command\1\rshow_url\2\14highlight\1\0\2\fenabled\2\ftimeout\3ñ\1\1\0\n\29custom_dynamic_variables\0\vresult\0\renv_file\t.env\20jump_to_request\1\14highlight\0\15encode_url\2\26skip_ssl_verification\1\26result_split_in_place\1\28result_split_horizontal\1\17yank_dry_run\2\nsetup\14rest-nvim\frequire\0" },
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\rest.nvim",
    url = "https://github.com/rest-nvim/rest.nvim"
  },
  ["roslyn.nvim"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\roslyn.nvim",
    url = "https://github.com/jmederosalvarado/roslyn.nvim"
  },
  ["telescope-file-browser.nvim"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-project.nvim"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-project.nvim",
    url = "https://github.com/nvim-telescope/telescope-project.nvim"
  },
  ["telescope-running-commands.nvim"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-running-commands.nvim",
    url = "https://github.com/keyvchan/telescope-running-commands.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  undotree = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-abolish",
    url = "https://github.com/tpope/vim-abolish"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-compiler-plugin-for-dotnet"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-compiler-plugin-for-dotnet",
    url = "https://github.com/tmadsen/vim-compiler-plugin-for-dotnet"
  },
  ["vim-dispatch"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-dispatch",
    url = "https://github.com/tpope/vim-dispatch"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-lastplace"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-lastplace",
    url = "https://github.com/farmergreg/vim-lastplace"
  },
  ["vim-matchup"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-surround",
    url = "https://github.com/tpope/vim-surround"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: neogen
time([[Config for neogen]], true)
try_loadstring("\27LJ\2\nR\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\19snippet_engine\fluasnip\nsetup\vneogen\frequire\0", "config", "neogen")
time([[Config for neogen]], false)
-- Config for: rest.nvim
time([[Config for rest.nvim]], true)
try_loadstring("\27LJ\2\n>\0\1\5\0\4\0\0066\1\0\0009\1\1\0019\1\2\0015\3\3\0\18\4\0\0D\1\3\0\1\5\0\0\ttidy\a-i\a-q\6-\vsystem\afn\bvim¿\3\1\0\6\0\r\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0005\4\a\0003\5\b\0=\5\t\4=\4\n\3=\3\v\0024\3\0\0=\3\f\2B\0\2\1K\0\1\0\29custom_dynamic_variables\vresult\15formatters\thtml\0\1\0\2\tjson\ajq\thtml\0\1\0\5\15formatters\0\17show_headers\2\19show_http_info\2\22show_curl_command\1\rshow_url\2\14highlight\1\0\2\fenabled\2\ftimeout\3ñ\1\1\0\n\29custom_dynamic_variables\0\vresult\0\renv_file\t.env\20jump_to_request\1\14highlight\0\15encode_url\2\26skip_ssl_verification\1\26result_split_in_place\1\28result_split_horizontal\1\17yank_dry_run\2\nsetup\14rest-nvim\frequire\0", "config", "rest.nvim")
time([[Config for rest.nvim]], false)
-- Config for: nx.nvim
time([[Config for nx.nvim]], true)
try_loadstring("\27LJ\2\n4\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\anx\frequire\0", "config", "nx.nvim")
time([[Config for nx.nvim]], false)
-- Config for: nightfox
time([[Config for nightfox]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\25colorscheme nightfox\bcmd\bvim\0", "config", "nightfox")
time([[Config for nightfox]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nvim-treesitter ]]
vim.cmd [[ packadd nvim-treesitter-textobjects ]]
time([[Sequenced loading]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
