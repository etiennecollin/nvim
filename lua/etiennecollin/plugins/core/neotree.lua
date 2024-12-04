return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = function(_, opts)
		local inputs = require("neo-tree.ui.inputs")

		-- Diff the source file against the target
		local function diff(state)
			local node = state.tree:get_node()
			local log = require("neo-tree.log")
			state.clipboard = state.clipboard or {}
			if NEOTREE_DIFF_NODE and NEOTREE_DIFF_NODE ~= tostring(node.id) then
				local current_diff = node.id
				require("neo-tree.utils").open_file(state, NEOTREE_DIFF_NODE, open)
				vim.cmd("vert diffs " .. current_diff)
				log.info("Diffing " .. NEOTREE_DIFF_NAME .. " against " .. node.name)
				NEOTREE_DIFF_NODE = nil
				current_diff = nil
				state.clipboard = {}
				require("neo-tree.ui.renderer").redraw(state)
			else
				local existing = state.clipboard[node.id]
				if existing and existing.action == "diff" then
					state.clipboard[node.id] = nil
					NEOTREE_DIFF_NODE = nil
					require("neo-tree.ui.renderer").redraw(state)
				else
					state.clipboard[node.id] = { action = "diff", node = node }
					NEOTREE_DIFF_NAME = state.clipboard[node.id].node.name
					NEOTREE_DIFF_NODE = tostring(state.clipboard[node.id].node.id)
					log.info("Diff source file " .. NEOTREE_DIFF_NAME)
					require("neo-tree.ui.renderer").redraw(state)
				end
			end
		end

		-- Trash the target
		local function trash(state)
			local node = state.tree:get_node()
			if node.type == "message" then
				return
			end
			local _, name = require("neo-tree.utils").split_path(node.path)
			local msg = string.format("Are you sure you want to trash '%s'?", name)
			inputs.confirm(msg, function(confirmed)
				if not confirmed then
					return
				end
				vim.api.nvim_command("silent !trash -F " .. node.path)
				require("neo-tree.sources.manager").refresh(state)
			end)
		end

		-- Trash the selections (visual mode)
		local function trash_visual(state, selected_nodes)
			local paths_to_trash = {}
			for _, node in ipairs(selected_nodes) do
				if node.type ~= "message" then
					table.insert(paths_to_trash, node.path)
				end
			end
			local msg = "Are you sure you want to trash " .. #paths_to_trash .. " items?"
			inputs.confirm(msg, function(confirmed)
				if not confirmed then
					return
				end
				for _, path in ipairs(paths_to_trash) do
					vim.api.nvim_command("silent !trash -F " .. path)
				end
				require("neo-tree.sources.manager").refresh(state)
			end)
		end

		local function on_move(state)
			Snacks.rename.on_rename_file(state.source, state.destination)
		end
		local events = require("neo-tree.events")
		opts.event_handlers = opts.event_handlers or {}
		vim.list_extend(opts.event_handlers, {
			{ event = events.FILE_MOVED, handler = on_move },
			{ event = events.FILE_RENAMED, handler = on_move },
		})

		require("neo-tree").setup({
			popup_border_style = "rounded",
			window = {
				position = "float",
				mappings = {
					["D"] = "diff_files",
					["d"] = "trash",
				},
			},
			commands = {
				diff_files = diff,
				trash = trash,
				trash_visual = trash_visual,
			},
		})
	end,
}
