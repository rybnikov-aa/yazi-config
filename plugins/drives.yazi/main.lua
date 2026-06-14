--- @since 26.1.0
--- Drives picker plugin for Windows
--- Bind to a key to quickly jump to a drive letter, i.e. { on = "e", run = "plugin drives", desc = "Pick a drive" }

-- Use Lua long-bracket string to avoid escaping nightmares with quotes inside PowerShell.
-- Output format: <letter>|<label>, one per line.
local WINDOWS_CMD = [[powershell -NoProfile -Command "Get-Volume | Where-Object { $_.DriveLetter } | ForEach-Object { $_.DriveLetter.ToString() + '|' + $_.FileSystemLabel }"]]

local function get_drives()
	local drives = {}
	local handle = io.popen(WINDOWS_CMD)
	if not handle then
		return drives
	end

	local output = handle:read("*a")
	local ok = handle:close()

	-- close() returns the exit status; non-zero means PowerShell failed
	if not output or output == "" then
		return drives
	end

	for line in output:gmatch("[^\r\n]+") do
		local letter, label = line:match("^(%a)|(.*)")
		if letter then
			label = label:gsub("^%s+", ""):gsub("%s+$", "")
			table.insert(drives, {
				letter = letter:upper(),
				label  = label ~= "" and label or "Local Disk",
			})
		end
	end

	table.sort(drives, function(a, b)
		return a.letter < b.letter
	end)

	return drives
end

local function entry(_, _)
	local drives = get_drives()

	if #drives == 0 then
		ya.notify({
			title   = "Drives",
			content = "No drives found",
			level   = "warn",
			timeout = 2,
		})
		return
	end

	-- Build candidates for ya.which key picker
	local cands = {}
	for _, d in ipairs(drives) do
		table.insert(cands, {
			on   = d.letter:lower(),
			desc = d.letter .. ":\\  " .. d.label,
			path = d.letter .. ":\\",
		})
	end

	local idx = ya.which({ cands = cands })
	if not idx then
		return -- user cancelled
	end

	ya.emit("cd", { cands[idx].path })
end

return { entry = entry }
