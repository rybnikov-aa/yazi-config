--- @since 26.5.6

local function setup(_, opts)
	local config = {
		hours = 24,
		recent_file_fg = "#ffc400",
		recent_dir_fg = "#ffc400",
		-- recent_dir_bg = "#2c3e22",
		bold = true,
		-- Символ-индикатор для недавних файлов
		recent_sign = "●",
	}

	if opts then
		for k, v in pairs(opts) do
			config[k] = v
		end
	end

	local recent_file_style = ui.Style()
	if config.recent_file_fg then
		recent_file_style = recent_file_style:fg(config.recent_file_fg)
	end

	local recent_dir_style = ui.Style()
	if config.recent_dir_fg then
		recent_dir_style = recent_dir_style:fg(config.recent_dir_fg)
	end
	if config.recent_dir_bg then
		recent_dir_style = recent_dir_style:bg(config.recent_dir_bg)
	end

	Linemode:children_add(function(self)
		local file = self._file
		if not file or not file.cha then
			return ""
		end

		local mt = file.cha.mtime
		if not mt then
			return ""
		end

		local now = os.time()
		local threshold = config.hours * 60 * 60

		if (now - mt) < threshold then
			if file.is_hovered then
				return ui.Line { " ", config.recent_sign }
			end

			local style = file.cha.is_dir and recent_dir_style or recent_file_style
			return ui.Line {
				" ",
				ui.Span(config.recent_sign):style(style),
			}
		end

		return ""
	end, 1600)
end

return { setup = setup }