return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		-- Add or skip cursor above/below the main cursor
		vim.keymap.set({ "n", "x" }, "<m-up>", function()
			mc.lineAddCursor(-1)
		end, { desc = "Add cursor above" })
		vim.keymap.set({ "n", "x" }, "<m-down>", function()
			mc.lineAddCursor(1)
		end, { desc = "Add cursor below" })
		vim.keymap.set({ "n", "x" }, "<leader><up>", function()
			mc.lineSkipCursor(-1)
		end, { desc = "Skip cursor above" })
		vim.keymap.set({ "n", "x" }, "<leader><down>", function()
			mc.lineSkipCursor(1)
		end, { desc = "Skip cursor below" })

		-- Add or skip adding a new cursor by matching word/selection
		vim.keymap.set({ "n", "x" }, "<leader>nn", function()
			mc.matchAddCursor(1)
		end, { desc = "Add cursor to next match of current word" })
		vim.keymap.set({ "n", "x" }, "<leader>ns", function()
			mc.matchSkipCursor(1)
		end, { desc = "Skip cursor to next match of current word" })
		vim.keymap.set({ "n", "x" }, "<leader>nN", function()
			mc.matchAddCursor(-1)
		end, { desc = "Add cursor to previous match of current word" })
		vim.keymap.set({ "n", "x" }, "<leader>nS", function()
			mc.matchSkipCursor(-1)
		end, { desc = "Skip cursor to previous match of current word" })

		-- Add and remove cursors with mouse
		vim.keymap.set("n", "<m-leftmouse>", mc.handleMouse)
		vim.keymap.set("n", "<m-leftdrag>", mc.handleMouseDrag)
		vim.keymap.set("n", "<m-leftrelease>", mc.handleMouseRelease)

		-- Mappings defined in a keymap layer only apply when there are multiple cursors
		mc.addKeymapLayer(function(layerSet)
			-- Select a different cursor as the main one.
			layerSet({ "n", "x" }, "<left>", mc.prevCursor, { desc = "Previous cursor" })
			layerSet({ "n", "x" }, "<right>", mc.nextCursor, { desc = "Next cursor" })

			-- Delete the main cursor
			layerSet({ "n", "x" }, "<m-x>", mc.deleteCursor, { desc = "Delete cursor" })

			-- Enable and clear cursors using escape
			layerSet("n", "<esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				else
					mc.clearCursors()
				end
			end)
		end)

		-- Customize how cursors look.
		-- local hl = vim.api.nvim_set_hl
		-- hl(0, "MultiCursorCursor", { reverse = true })
		-- hl(0, "MultiCursorVisual", { link = "Visual" })
		-- hl(0, "MultiCursorSign", { link = "SignColumn" })
		-- hl(0, "MultiCursorMatchPreview", { link = "Search" })
		-- hl(0, "MultiCursorDisabledCursor", { reverse = true })
		-- hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		-- hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end,
}
