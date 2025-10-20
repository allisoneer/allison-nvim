-- Supermaven AI completion
-- Currently disabled. To re-enable:
-- 1. Uncomment the spec below
-- 2. Add { name = "supermaven" } to CMP sources in lua/plugins/cmp.lua
-- 3. Run :Lazy sync

return {}

--[[
return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<Tab>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-j>",
			},
		})
	end,
}
--]]
