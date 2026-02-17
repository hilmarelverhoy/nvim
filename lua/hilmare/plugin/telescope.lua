local conf = require("telescope.config").values
local channel = require("plenary.async.control").channel
local sorters = require "telescope.sorters"
local make_entry = require "telescope.make_entry"
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
require'telescope'.load_extension('project')
local builtin = require('telescope.builtin')
local path;
local sitepath;
if vim.loop.os_uname().sysname == "Darwin" or vim.loop.os_uname().sysname == "Linux" then
    path = "~/.config/nvim"
else
    path = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim"
end

if vim.loop.os_uname().sysname == "Darwin" or vim.loop.os_uname().sysname == "Linux" then
    sitepath = "~/.local/share/nvim/"
else
    sitepath = "C:\\Users\\ELVHIL\\AppData\\Local\\nvim-data"
end

vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>tf', builtin.find_files, {})
vim.keymap.set('n', '<leader>tr', builtin.resume, {})
vim.keymap.set('n', '<leader>tc', function ()
    local config = {
        -- hidden = true,
        cwd = path
    }
    builtin.find_files(config)
end, {})
vim.keymap.set('n', '<leader>tC', function ()
    local config = {
        -- hidden = true,
        cwd = sitepath
    }
    builtin.find_files(config)
end, {})
local function split_prompt(prompt)
  local tags = {}
  local series = {}
  local title = {}
  -- Iterates over all non-space substrings.
  -- `prompt:gmatch` is syntax sugar for `string.gmatch(prompt, ..)`
  for word in prompt:gmatch("([^%s]+)") do
    -- Use `sub(1, 1)` to get the first character.
    -- It works with empty strings too!
    local fst = word:sub(1, 1)
    if fst == "@" then
      -- Use `sub(2)` to skip the `@`.
      table.insert(tags, word:sub(2))
    elseif fst == "#" then
      table.insert(series, word:sub(2))
    else
      table.insert(title, word)
    end
  end

  return {
    tags = tags,
    series = series,
    -- Combine non-tagged elements into a string.
    -- Could've be done outside this function but it'll always be done
    -- so I thought it would be easier to join here.
    title = vim.fn.join(title, " "),
  }
end
-- Match the list `prompt_elements` against `entry_element`, either a list or a string.
local function score_element(prompt_elements, entry_element, sorter)
  -- We didn't prompt for this type, ignore it.
  -- This is a "is list empty?" check in Lua.
  if next(prompt_elements) == nil then
    return 0
  end

  -- We prompted for this type, but entry didn't have it, so remove the entry.
  -- For example if we prompt for a series, this removes all posts
  -- without a series.
  if not entry_element then
    return -1
  end

  -- Convert multiple entry values to a string like `tag1:tag2`.
  local entry
  -- We can use `type()` to dynamically check the type of a variable
  -- and act occordingly.
  if type(entry_element) == "string" then
    entry = entry_element
  elseif type(entry_element) == "table" then
    entry = vim.fn.join(entry_element, ":")
  end

  local total = 0
  -- For each prompt element (`tag1`, `tag2`, ...), match against the entry string (`tag1:tag2`).
  for _, prompt_element in ipairs(prompt_elements) do
    local score = sorter:scoring_function(prompt_element, entry)
    -- Require a match for every element.
    if score < 0 then
      return -1
    end
    total = total + score
  end

  -- Clamp score to 0..1.
  -- Not strictly needed but it feels neater.
  return total / #prompt_elements
end
local function post_sorter(opts)
  opts = opts or {}
  -- We can use `fzy_sorter` for the actual fuzzy matching.
  local fzy_sorter = sorters.get_fzy_sorter(opts)

  return sorters.Sorter:new({
    -- Allow us to filter entries as well as sorting them.
    discard = true,

    scoring_function = function(_, prompt, entry)
        prompt = split_prompt(prompt)

        local series_score = score_element(prompt.series, entry.series, fzy_sorter)
        if series_score < 0 then
            return -1
        end

        local tags_score = score_element(prompt.tags, entry.tags, fzy_sorter)
        if tags_score < 0 then
            return -1
        end

        local title_score = fzy_sorter:scoring_function(prompt.title, entry.title)
        if title_score < 0 then
            return -1
        end

        return series_score + tags_score + title_score
    end,

        -- We could also specify a highlighter. The highlighter works fine in this case,
        -- but if we modify `scoring_function` we have to modify this too.
        -- I admit, I currently don't use a highlighter for my posts finder.
    highlighter = fzy_sorter.highlighter,
    })
end
local function get_workspace_symbols_requester(bufnr, opts)
  local cancel = function() end

  return function(prompt)
    local tx, rx = channel.oneshot()
    cancel()
    _, cancel = vim.lsp.buf_request(bufnr, "workspace/symbol", { query = prompt }, tx)

    -- Handle 0.5 / 0.5.1 handler situation
    local err, res = rx()
    assert(not err, err)

    local locations = vim.lsp.util.symbols_to_items(res or {}, bufnr) or {}
    if not vim.tbl_isempty(locations) then
      locations = utils.filter_symbols(locations, opts) or {}
    end
    return locations
  end
end
vim.keymap.set('n','æe',
    function ()
        opts = {bufnr = 0}
        pickers
            .new(opts, {
                finder = finders.new_dynamic {
                    entry_maker = opts.entry_maker or make_entry.gen_from_lsp_symbols(opts),
                    fn = get_workspace_symbols_requester(opts.bufnr, opts),
                },
                -- This is the important `sorter` function.
                sorter = post_sorter(opts),
            })
            :find()
    end
    ,{})

vim.keymap.set('n', '<leader>/', builtin.live_grep, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
-- vim.keymap.set('n', '<leader>gh', require'telescope'.extensions.git_file_history.git_file_history, {})

vim.keymap.set('n', '<leader>lw', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>ls', builtin.lsp_dynamic_workspace_symbols, {})
vim.keymap.set('n', '<leader>ld', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>d', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>q', builtin.quickfix, {})
vim.keymap.set('n', '<leader>tp', require 'telescope'.extensions.project.project, {})
-- open file_browser with the path of the current buffer
-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
local project_actions = require("telescope._extensions.project.actions")
require("telescope").setup {
    extensions = {
        project = {
            base_dirs = {
                autotavla = "~/Autotavla/",
                gse = "~/GeoguessrScoringEngine//"
            },
            hidden_files = true,
            theme = "dropdown",
        },
    },
}

-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension "file_browser"
-- require("telescope").load_extension("git_file_history")
-- This is your opts table
