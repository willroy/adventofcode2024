Day1 = {}

function Day1:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Day1:init()
  self.answer1 = 0
  self.answer2 = 0

  self.input = {}

  local file = io.open("data/day1input.txt", 'r')

  if file then
    for line in file:lines() do
      table.insert(self.input, line)
    end
    file:close()
  else
    print('unable to open file')
  end

  local col1List = {}
  local col2List = {}

  for k, line in pairs(self.input) do
    local count = 0
    for line in string.gmatch(line, "[^%s]+") do
      if count == 0 then
        table.insert(col1List, line)
      else
        table.insert(col2List, line)
      end
      count = count + 1
    end
  end

  table.sort(col1List)
  table.sort(col2List)

  local differences = {}

  for k, v in pairs(col1List) do
    local diff = 0
    if v > col2List[k] then diff = (v-col2List[k])
    else diff = (col2List[k]-v) end
    table.insert(differences, diff)
  end

  for k, v in pairs(differences) do
    self.answer1 = self.answer1 + v
  end

  local occurences = {}

  for k, v in pairs(col1List) do
    local count = 0
    for k2, v2 in pairs(col2List) do
      if v2 == v then count = count + 1 end
    end
    table.insert(occurences, count)
  end

  local totals = {}

  for k, v in pairs(col1List) do
    local total = v*occurences[k]
    table.insert(totals, total)
  end

  for k, v in pairs(totals) do
    self.answer2 = self.answer2 + v
  end

end

function Day1:draw()
  love.graphics.print(tostring(self.answer1), 100, 100)
  love.graphics.print(tostring(self.answer2), 100, 200)
end