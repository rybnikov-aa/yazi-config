require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}

require("git"):setup {
	-- Order of status signs showing in the linemode
	order = 1500,
}

-- You can also configure bookmarks with key arrays
local bookmarks = {
  { tag = "Documents", path = "~/Documents", key = { "h", "D" } },
  { tag = "Downloads", path = "~/Downloads", key = { "h", "d" } },
  { tag = "Music",     path = "~/Music",     key = { "h", "m" } },
  { tag = "Pictures",  path = "~/Pictures",  key = { "h", "p" } },
  { tag = "Videos",    path = "~/Videos",    key = { "h", "v" } },

  { tag = "NAS - Personal",     path = [[\\DXP4800-9181\personal_folder\]], key = { "n", "p" } },
  { tag = "NAS - Public",       path = [[\\DXP4800-9181\Public\]],          key = { "n", "P" } },
  { tag = "NAS - Backup",       path = [[\\DXP4800-9181\Backup\]],          key = { "n", "b" } },
  { tag = "NAS - Immich",       path = [[\\DXP4800-9181\Immich\]],          key = { "n", "i" } },
  { tag = "NAS - Network",      path = [[\\DXP4800-9181\Network\]],         key = { "n", "n" } },
  { tag = "NAS - Sync",         path = [[\\DXP4800-9181\Sync\]],            key = { "n", "s" } },
  { tag = "NAS - Surveillance", path = [[\\DXP4800-9181\Surveillance\]],    key = { "n", "S" } },
  { tag = "NAS - Torrents",     path = [[\\DXP4800-9181\Torrents\]],        key = { "n", "t" } },
  { tag = "NAS - docker",       path = [[\\DXP4800-9181\docker\]],          key = { "n", "d" } },
}

-- Windows-specific bookmarks
if ya.target_family() == "windows" then
  local home_path = os.getenv("USERPROFILE")
  table.insert(bookmarks, {
    tag = "Scoop Global",
    path = os.getenv("SCOOP_GLOBAL") or "C:\\ProgramData\\scoop",
    key = { "<C-S>" }
  })
  table.insert(bookmarks, {
    tag = "Scoop Local",
    path = os.getenv("SCOOP") or (home_path .. "\\scoop"),
    key = { "<C-s>" }
  })

end


require("whoosh"):setup {
  -- Configuration bookmarks (cannot be deleted through plugin)
  bookmarks = bookmarks,

  -- Notification settings
  jump_notify = false,

  -- Key generation for auto-assigning bookmark keys
  keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",

  -- Configure the built-in menu action hotkeys
  -- false - hide menu item
  special_keys = {
    create_temp = "<Enter>",         -- Create a temporary bookmark from the menu
    fuzzy_search = "<Space>",        -- Launch fuzzy search (fzf)
    history = "<Tab>",               -- Open directory history
    previous_dir = "<Backspace>",    -- Jump back to the previous directory
    project_root = "-",              -- Jump to the current Git repository root
  },

  -- File path for storing user bookmarks
  bookmarks_path = (ya.target_family() == "windows" and os.getenv("APPDATA") .. "\\yazi\\config\\plugins\\whoosh.yazi\\bookmarks") or
         (os.getenv("HOME") .. "/.config/yazi/plugins/whoosh.yazi/bookmarks"),

  -- Replace home directory with "~"
  home_alias_enabled = true,                            -- Toggle home aliasing in displays

  -- Path truncation in navigation menu
  path_truncate_enabled = false,                        -- Enable/disable path truncation
  path_max_depth = 3,                                   -- Maximum path depth before truncation

  -- Path truncation in fuzzy search (fzf)
  fzf_path_truncate_enabled = false,                    -- Enable/disable path truncation in fzf
  fzf_path_max_depth = 5,                               -- Maximum path depth before truncation in fzf

  -- Long folder name truncation
  path_truncate_long_names_enabled = false,             -- Enable in navigation menu
  fzf_path_truncate_long_names_enabled = false,         -- Enable in fzf
  path_max_folder_name_length = 20,                     -- Max length in navigation menu
  fzf_path_max_folder_name_length = 20,                 -- Max length in fzf

  -- History directory settings
  history_size = 10,                                    -- Number of directories in history (default 10)
  history_fzf_path_truncate_enabled = false,            -- Enable/disable path truncation by depth for history
  history_fzf_path_max_depth = 5,                       -- Maximum path depth before truncation for history (default 5)
  history_fzf_path_truncate_long_names_enabled = false, -- Enable/disable long folder name truncation for history
  history_fzf_path_max_folder_name_length = 30,         -- Maximum length for folder names in history (default 30)
}

-- Загрузка плагина для подсветки недавних файлов
require("recent-color"):setup()

-- projects.yazi - A plugin for managing project workspaces in Yazi
require("projects"):setup({
    event = {
        save = {
            enable = true,
            name = "project-saved",
        },
        load = {
            enable = true,
            name = "project-loaded",
        },
        delete = {
            enable = true,
            name = "project-deleted",
        },
        delete_all = {
            enable = true,
            name = "project-deleted-all",
        },
        merge = {
            enable = true,
            name = "project-merged",
        },
    },
    save = {
        method = "yazi", -- yazi | lua
        yazi_load_event = "@projects-load", -- event name when loading projects in `yazi` method
        lua_save_path = "", -- path of saved file in `lua` method, comment out or assign explicitly
                            -- default value:
                            -- windows: "%APPDATA%/yazi/state/projects.json"
                            -- unix: "~/.local/state/yazi/projects.json"
    },
    last = {
        update_after_save = true,
        update_after_load = true,
        update_before_quit = false,
        load_after_start = false,
    },
    merge = {
        event = "projects-merge",
        quit_after_merge = false,
    },
    notify = {
        enable = true,
        title = "Projects",
        timeout = 3,
        level = "info",
    },
})