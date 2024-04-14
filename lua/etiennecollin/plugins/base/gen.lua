return {
	"David-Kunz/gen.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("gen").setup({
			model = "dolphincoder", -- The default model to use.
			host = "localhost", -- The host running the Ollama service.
			port = "11434", -- The port on which the Ollama service is listening.
			quit_map = "q", -- set keymap for close the response window
			retry_map = "<c-r>", -- set keymap to re-send the current prompt
			init = function(options) end,
			-- Function to initialize Ollama
			command = function(options)
				local body = { model = options.model, stream = true }
				return "curl --silent --no-buffer -X POST http://"
					.. options.host
					.. ":"
					.. options.port
					.. "/api/chat -d $body"
			end,
			display_mode = "float", -- The display mode. Can be "float" or "split".
			show_prompt = false, -- Shows the prompt submitted to Ollama.
			show_model = false, -- Displays which model you are using at the beginning of your chat session.
			no_auto_close = false, -- Never closes the window automatically.
			debug = false, -- Prints errors and the command which is run.
		})

		require("etiennecollin.core.remaps_plugin").gen()
	end,
}
