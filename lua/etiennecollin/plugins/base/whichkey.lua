return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	config = function()
		local whichkey = require("which-key")

		local conf = {
			window = {
				border = "single", -- none, single, double, shadow
				position = "bottom", -- bottom, top
			},
		}

		local opts = {
			mode = "n", -- NORMAL mode
			-- the prefix is prepended to every mapping
			prefix = "<leader>",
		}

		local mappings = {
			b = {
				name = "Buffer",
				c = { "<cmd>close<cr>", "Close buffer" },
				D = { "<cmd>%bd|e#|bd#<cr>", "Delete all buffers" },
				h = { "<cmd>FocusSplitDown<cr>", "Hsplit window" },
				n = { "<cmd>FocusSplitNicely<cr>", "New buffer" },
				v = { "<cmd>FocusSplitRight<cr>", "Vsplit window" },
			},
			B = {
				name = "Tab",
				c = { "<cmd>tabclose<cr>", "Close tab" },
				n = { "<cmd>tabn<cr>", "Next tab" },
				o = { "<cmd>tabnew<cr>", "Open tab" },
				p = { "<cmd>tabp<cr>", "Previous tab" },
			},

			d = {
				name = "Debug",
			},

			e = { "<cmd>Neotree toggle reveal<cr>", "Toggle Neotree" },

			f = {
				"<cmd>lua vim.lsp.buf.format()<cr>",
				"Format file",
			},

			k = { ":s/\\(\\S.*\\)/ \\1/g<left><left><left><left><left>", "Fighting one-eyed kirby" },

			p = {
				name = "Telescope and Files",
				b = { "<cmd>Telescope buffers<cr>", "Buffers" },
				f = { "<cmd>Telescope find_files<cr>", "Files" },
				h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
				r = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
				s = { "<cmd>Telescope grep_string<cr>", "Search local" },
				S = { "<cmd>Telescope live_grep<cr>", "Search global" },
				v = { "<cmd>Alpha<cr>", "Open Alpha" },
			},

			q = { "<cmd>bd<cr>", "Delete buffer" },
			Q = { "<cmd>q<cr>", "Quit" },

			s = { ":%s//gI<left><left><left>", "Replace all" },
			S = { ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<left><left><left>", "Replace current word" },

			t = {
				name = "Terminal",
				f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
				h = { "<cmd>ToggleTerm direction=horizontal<cr>", "Horizontal" },
				v = { "<cmd>ToggleTerm direction=vertical<cr>", "Vertical" },
				t = { "<cmd>ToggleTerm<cr>", "Bottom" },
				i = { '<cmd>TermExec cmd="ipython"<cr>', "IPython" },
				p = { '<cmd>TermExec cmd="python"<cr>', "Python" },
				j = { '<cmd>TermExec cmd="julia"<cr>', "Julia" },
			},

			u = { "<cmd>UndotreeToggle<cr>", "Undotree" },

			w = { "<cmd>update!<cr>", "Save" },

			x = {
				name = "Trouble",
				d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document diagnostics" },
				l = { "<cmd>TroubleToggle loclist<cr>", "Loclist" },
				q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
				t = { "<cmd>TodoTrouble<cr>", "Todo" },
				w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace diagnostics" },
				x = { "<cmd>TroubleToggle<cr>", "Toggle trouble" },
			},
			X = {
				name = "Utilities",
				A = { "<cmd>CellularAutomaton make_it_rain<cr>", "Cellular automaton" },
				X = { "<cmd>!chmod +x %<cr>", "Make executable" },
				Z = { "<cmd>ZenMode<cr>", "Toggle zen mode" },
			},

			z = {
				name = "Lazy/Mason",
				m = { "<cmd>Mason<cr>", "Mason" },
				l = { "<cmd>Lazy<cr>", "Lazy" },
			},
		}

		whichkey.setup(conf)
		whichkey.register(mappings, opts)
	end,
}
