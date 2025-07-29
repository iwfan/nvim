local telescope = require "telescope"
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values
local utils = require "telescope.utils"
local Path = require "plenary.path"

-- 默认排除的目录和文件
local DEFAULT_EXCLUDES = {
  ".git",
  ".idea",
  "node_modules",
  "dist",
  "out",
  ".next",
  ".cache",
}

-- 尝试获取最佳可用的查找命令
local function get_find_command()
  local find_commands = {
    { "fd", "--type=file" },
    { "fdfind", "--type=file" },
    { "rg", "--files" },
    { "find", ".", "-type", "f" },
  }

  for _, cmd in ipairs(find_commands) do
    if vim.fn.executable(cmd[1]) == 1 then
      return cmd
    end
  end

  -- 如果都不可用，返回默认的find命令
  return find_commands[4]
end

-- 处理路径，确保跨平台兼容
local function normalize_path(path)
  if path == nil then
    return nil
  end

  if vim.fn.has "win32" == 1 then
    -- Windows 路径规范化
    path = path:gsub("\\", "/")
  end

  return path
end

-- 检查文件是否在当前工作目录中
local function is_in_cwd(file, cwd)
  cwd = normalize_path(cwd or vim.loop.cwd())
  file = normalize_path(file)

  -- 确保两个路径都以斜杠结尾进行比较
  if not cwd:match "/$" then
    cwd = cwd .. "/"
  end

  return file:find(cwd, 1, true) == 1
end

-- 处理别名选项
local function apply_cwd_only_aliases(opts)
  opts = opts or {}
  local has_cwd_only = opts.cwd_only ~= nil
  local has_only_cwd = opts.only_cwd ~= nil

  if has_only_cwd and not has_cwd_only then
    -- 内部使用 cwd_only
    opts.cwd_only = opts.only_cwd
    opts.only_cwd = nil
  end

  return opts
end

-- 获取oldfiles列表，优化性能
local function oldfiles_list(opts)
  opts = apply_cwd_only_aliases(opts)
  opts.include_current_session = vim.F.if_nil(opts.include_current_session, true)

  local current_buffer = vim.api.nvim_get_current_buf()
  local current_file = normalize_path(vim.api.nvim_buf_get_name(current_buffer))
  local cwd = normalize_path(vim.loop.cwd())
  local results = {}
  local file_set = {} -- 使用集合来避免重复

  -- 获取当前会话的缓冲区
  if opts.include_current_session then
    -- 使用更高效的 nvim_list_bufs 替代 execute + split
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      -- 检查缓冲区是否已加载且是真实文件
      if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buftype") == "" then
        local file = normalize_path(vim.api.nvim_buf_get_name(buf))

        -- 只添加存在且不是当前缓冲区的文件
        if file ~= "" and vim.loop.fs_stat(file) and buf ~= current_buffer then
          -- 检查是否在当前工作目录
          if is_in_cwd(file, cwd) then
            if not file_set[file] then
              file_set[file] = true
              table.insert(results, file)
            end
          end
        end
      end
    end
  end

  -- 添加oldfiles，避免重复
  for _, file in ipairs(vim.v.oldfiles) do
    file = normalize_path(file)
    if not file_set[file] and file ~= current_file and vim.loop.fs_stat(file) then
      -- 检查是否在当前工作目录
      if is_in_cwd(file, cwd) then
        file_set[file] = true
        table.insert(results, file)
      end
    end
  end

  return results
end

-- 主函数
local enhanced_find_files = function(opts)
  opts = opts or {}

  -- 合并用户排除项和默认排除项
  local excludes = {}
  if opts.excludes then
    excludes = vim.tbl_extend("force", DEFAULT_EXCLUDES, opts.excludes)
  else
    excludes = DEFAULT_EXCLUDES
  end

  -- 获取oldfiles列表
  local results = oldfiles_list(opts)

  -- 创建picker
  pickers
    .new(opts, {
      prompt_title = opts.prompt_title or "Enhanced Find Files",
      results_title = opts.results_title or "Files",
      finder = finders.new_table {
        results = results,
        entry_maker = opts.entry_maker or make_entry.gen_from_file(opts),
      },
      previewer = conf.file_previewer(opts),
      sorter = conf.file_sorter(opts),
      on_input_filter_cb = function(prompt)
        -- 空搜索时显示oldfiles
        if prompt == nil or prompt == "" then
          return {
            prompt = prompt,
            updated_finder = finders.new_table {
              results = results,
              entry_maker = opts.entry_maker or make_entry.gen_from_file(opts),
            },
          }
        end

        -- 有搜索内容时，使用文件查找命令
        local find_command = get_find_command()
        local command = find_command[1]

        -- 扩展命令参数
        if command == "fd" or command == "fdfind" then
          table.insert(find_command, "--hidden")

          -- 添加排除项
          for _, exclude in ipairs(excludes) do
            table.insert(find_command, "--exclude")
            table.insert(find_command, exclude)
          end

          -- 应用用户选项
          if opts.no_ignore then
            table.insert(find_command, "--no-ignore")
          end
          if opts.no_ignore_parent then
            table.insert(find_command, "--no-ignore-parent")
          end
          if opts.follow then
            table.insert(find_command, "-L")
          end

          -- 处理搜索路径
          if opts.search_file then
            table.insert(find_command, opts.search_file)
          end
        elseif command == "rg" then
          table.insert(find_command, "--hidden")

          -- 添加排除项
          for _, exclude in ipairs(excludes) do
            table.insert(find_command, "--glob")
            table.insert(find_command, "!" .. exclude)
          end

          -- 应用用户选项
          if opts.no_ignore then
            table.insert(find_command, "--no-ignore")
          end
          if opts.follow then
            table.insert(find_command, "-L")
          end

          -- 处理搜索文件
          if opts.search_file then
            table.insert(find_command, "-g")
            table.insert(find_command, "*" .. opts.search_file .. "*")
          end
        elseif command == "find" then
          -- 基本的find命令，不支持所有选项，但确保基本功能
          table.insert(find_command, "-not")
          table.insert(find_command, "(")

          for i, exclude in ipairs(excludes) do
            if i > 1 then
              table.insert(find_command, "-o")
            end
            table.insert(find_command, "-path")
            table.insert(find_command, "*/" .. exclude .. "/*")
          end

          table.insert(find_command, ")")

          if prompt ~= "" then
            table.insert(find_command, "-name")
            table.insert(find_command, "*" .. prompt .. "*")
          end
        end

        -- 处理搜索目录
        if opts.search_dirs then
          -- 移除之前可能添加的默认"."
          if command ~= "find" and find_command[#find_command] == "." then
            table.remove(find_command)
          end

          for _, path in ipairs(opts.search_dirs) do
            table.insert(find_command, vim.fn.expand(path))
          end
        elseif command ~= "find" and not vim.tbl_contains(find_command, ".") then
          -- 确保有一个搜索路径，除非是find命令
          table.insert(find_command, ".")
        end

        -- 处理工作目录
        if opts.cwd then
          opts.cwd = vim.fn.expand(opts.cwd)
        end

        -- 设置entry_maker
        opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

        -- 创建新的finder
        return {
          prompt = prompt,
          updated_finder = finders.new_oneshot_job(find_command, opts),
        }
      end,
    })
    :find()
end

-- 注册扩展
return telescope.register_extension {
  setup = function(ext_config)
    -- 允许通过setup函数配置默认选项
    ext_config = ext_config or {}

    -- 可以在这里设置全局默认选项
    if ext_config.excludes then
      DEFAULT_EXCLUDES = vim.tbl_extend("force", DEFAULT_EXCLUDES, ext_config.excludes)
    end
  end,

  exports = {
    enhanced_find_files = enhanced_find_files,
  },
}
