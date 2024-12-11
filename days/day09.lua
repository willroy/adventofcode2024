Day09 = {}

function Day09:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.completed = true
  return o
end

function Day09:init()
  self.answer1 = 0
  self.answer2 = 0

  self.diskmap = {}

  local file = io.open("data/day09input.txt", 'r')

  if file then
    for line in file:lines() do
      table.insert(self.diskmap, line)
    end
    file:close()
  else
    print('unable to open file')
  end

  self.expanded_diskmap1 = {}
  self.expanded_diskmap2 = {}

  -- build up initial diskmap list

  local odd = true
  local evenCount = 0
  for i = 1, #self.diskmap[1] do
    local c = self.diskmap[1]:sub(i, i)

    for a = 1, tonumber(c) do
      if odd then
        table.insert(self.expanded_diskmap1, i - evenCount - 1)
        table.insert(self.expanded_diskmap2, i - evenCount - 1)
      else
        table.insert(self.expanded_diskmap1, ".")
        table.insert(self.expanded_diskmap2, ".")
      end
    end

    if not odd then evenCount = evenCount + 1 end
    odd = not odd
  end

  self.compressed_diskmap = {}

  self.num_count = 0
  for k, v in pairs(self.expanded_diskmap1) do
    if not (v == ".") then
      self.num_count = self.num_count + 1
    end
  end

  -- answer 1 compression

  for k, v in pairs(self.expanded_diskmap1) do
    local lastNumIndex = 0
    for i = #self.expanded_diskmap1, 1, -1 do
      local c = self.expanded_diskmap1[i]
      if not (c == ".") then
        lastNumIndex = i
        break
      end
    end
    if self.num_count <= #self.compressed_diskmap then
      table.insert(self.compressed_diskmap, ".")
    else
      if v == "." then
        table.insert(self.compressed_diskmap, self.expanded_diskmap1[lastNumIndex])
        self.expanded_diskmap1[lastNumIndex] = "."
      else
        table.insert(self.compressed_diskmap, v)
      end
    end
  end

  for k, v in pairs(self.compressed_diskmap) do
    if not (v == ".") then
      local checksum = (k - 1) * tonumber(v)
      self.answer1 = self.answer1 + checksum
    end
  end

  -- answer 2 compression

  -- get indexes and size of each file

  local fileTracker = {}
  for k, v in pairs(self.expanded_diskmap2) do
    if not (v == ".") then
      if fileTracker[v] == nil then fileTracker[v] = { k, 0 } end
      fileTracker[v][2] = fileTracker[v][2] + 1
    end
  end

  -- resort diskmap, look for space for each id in the fileTracker and swap if found

  for i = #fileTracker, 1, -1 do
    local file = fileTracker[i]
    local targetIndex = self:findSpace(self.expanded_diskmap2, file[2])
    if targetIndex > 0 and targetIndex < file[1] then
      for a = file[1], file[1] + file[2] - 1 do self.expanded_diskmap2[a] = "." end
      for a = targetIndex, targetIndex + file[2] - 1 do self.expanded_diskmap2[a] = tostring(i) end
    end
  end

  -- calculate checksum for answer2

  for k, v in pairs(self.expanded_diskmap2) do
    if not (v == ".") then
      local checksum = (k - 1) * tonumber(v)
      self.answer2 = self.answer2 + checksum
    end
  end
end

function Day09:findSpace(list, size)
  local spaceTracker = 0
  for k, v in pairs(list) do
    if v == "." then
      spaceTracker = spaceTracker + 1
    else
      spaceTracker = 0
    end
    if spaceTracker == size then
      return k - (spaceTracker - 1)
    end
  end
  return -1
end

function Day09:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
