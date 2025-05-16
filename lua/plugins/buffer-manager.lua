return {
  "romgrk/barbar.nvim",
  event = "VeryLazy",
  config = function()
    -- Store buffer access times
    local buffer_last_used = {}
    local max_buffers = 8 -- Maximum number of buffers to keep open
    local max_idle_time = 30 * 60 -- 30 minutes in seconds

    -- Update timestamp when entering a buffer
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        local current_buf = vim.api.nvim_get_current_buf()
        buffer_last_used[current_buf] = os.time()
      end,
    })

    -- Function to get all listed buffers
    local function get_listed_buffers()
      return vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_valid(buf) 
          and vim.bo[buf].buflisted
          and vim.api.nvim_buf_get_name(buf) ~= ""
      end, vim.api.nvim_list_bufs())
    end

    -- Function to close the oldest buffer
    local function close_oldest_buffer()
      local current_buf = vim.api.nvim_get_current_buf()
      local buffers = get_listed_buffers()
      
      -- Don't do anything if we don't have enough buffers
      if #buffers <= max_buffers then
        return
      end
      
      -- Find the oldest buffer
      local oldest_buf = nil
      local oldest_time = os.time()
      
      for _, buf in ipairs(buffers) do
        local last_used = buffer_last_used[buf] or 0
        if buf ~= current_buf and last_used < oldest_time then
          oldest_time = last_used
          oldest_buf = buf
        end
      end
      
      -- Close the oldest buffer if found
      if oldest_buf then
        vim.cmd("silent! BufferClose " .. oldest_buf)
      end
    end

    -- Function to close inactive buffers
    local function close_inactive_buffers()
      local current_time = os.time()
      local current_buf = vim.api.nvim_get_current_buf()
      
      for buf, last_used in pairs(buffer_last_used) do
        if (current_time - last_used) > max_idle_time and buf ~= current_buf then
          if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
            vim.cmd("silent! BufferClose " .. buf)
          end
        end
      end
    end

    -- Close oldest buffer when exceeding max_buffers
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        close_oldest_buffer()
      end,
    })

    -- Set up a timer to check for inactive buffers every 5 minutes
    local timer = vim.loop.new_timer()
    if timer then
      timer:start(1000 * 60 * 5, 1000 * 60 * 5, vim.schedule_wrap(function()
        close_inactive_buffers()
      end))
    end
    
    -- Commands to manually control buffer cleanup
    vim.api.nvim_create_user_command("BufferCloseInactive", function()
      close_inactive_buffers()
    end, { desc = "Close buffers that haven't been used for a while" })
    
    vim.api.nvim_create_user_command("BufferCloseOldest", function()
      close_oldest_buffer()
    end, { desc = "Close the oldest buffer" })
  end,
}