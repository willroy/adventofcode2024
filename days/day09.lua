Day09 = {}

function Day09:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Day09:init()
  self.answer1 = 0
  self.answer2 = 0

  self.diskmap = {}

  local file = io.open("data/day9input.txt", 'r')

  if file then
    for line in file:lines() do
      table.insert(self.diskmap, line)
    end
    file:close()
  else
    print('unable to open file')
  end

  self.expanded_diskmap = {}

  local odd = true
  local evenCount = 0
  for i = 1, #self.diskmap[1] do
    local c = self.diskmap[1]:sub(i, i)

    for a = 1, tonumber(c) do
      if odd then
        table.insert(self.expanded_diskmap, i-evenCount-1)
      else
        table.insert(self.expanded_diskmap, ".")
      end
    end

    if not odd then evenCount = evenCount + 1 end
    odd = not odd
  end

  self.compressed_diskmap = {}

  self.num_count = 0
  for k, v in pairs(self.expanded_diskmap) do
    if not (v == ".") then
      self.num_count = self.num_count + 1
    end
  end

  for k, v in pairs(self.expanded_diskmap) do
    local lastNumIndex = 0
    for i = #self.expanded_diskmap, 1, -1 do
      local c = self.expanded_diskmap[i]
      if not (c == ".") then
        lastNumIndex = i
        break
      end
    end
    if self.num_count <= #self.compressed_diskmap then
      table.insert(self.compressed_diskmap, ".")
    else
      if v == "." then
        table.insert(self.compressed_diskmap, self.expanded_diskmap[lastNumIndex])
        self.expanded_diskmap[lastNumIndex] = "."
      else
        table.insert(self.compressed_diskmap, v)
      end
    end
  end

  for k, v in pairs(self.compressed_diskmap) do
    if not (v == ".") then
      local checksum = (k-1) * tonumber(v)
      self.answer1 = self.answer1 + checksum
    end
  end

  print(self.answer1)
end

function Day09:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
