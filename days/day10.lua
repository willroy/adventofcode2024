Day10 = {}

function Day10:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Day10:init()
  self.answer1 = 0
  self.answer2 = 0

  self.map = {}
  self.trailheads = {}

  local file = io.open("data/day10input.txt", 'r')

  if file then
    local y = 0
    for line in file:lines() do
      y = y + 1
      for x = 1, #line do
        local c = line:sub(x,x)
        if self.map[y] == nil then self.map[y] = {} end
        table.insert(self.map[y], c)
        if c == "0" then table.insert(self.trailheads, {x, y}) end
      end
    end
    file:close()
  else
    print('unable to open file')
  end

  for k, v in pairs(self.trailheads) do
    local nines = self:mapPathSearch(v, {})
    self.answer2 = self.answer2 + #nines
    nines = self:removeDuplicates(nines)
    self.answer1 = self.answer1 + #nines
  end

  print(self.answer1)
  print(self.answer2)
end

function Day10:mapPathSearch(pos, nines)
  local nines = nines
  local current = self.map[pos[2]][pos[1]]

  if current == "9" then
    table.insert(nines, {pos[1],pos[2]})
    return nines
  end

  local up = nil
  local down = nil 
  local left = nil 
  local right = nil 

  if not (self.map[pos[2]-1] == nil) then up = self.map[pos[2]-1][pos[1]] end 
  if not (self.map[pos[2]+1] == nil) then down = self.map[pos[2]+1][pos[1]] end
  if not (self.map[pos[2]][pos[1]-1] == nil) then left = self.map[pos[2]][pos[1]-1] end
  if not (self.map[pos[2]][pos[1]+1] == nil) then right = self.map[pos[2]][pos[1]+1] end

  if not (up == nil) and tonumber(up) == tonumber(current)+1 then nines = self:mapPathSearch({pos[1], pos[2]-1}, nines) end
  if not (down == nil) and tonumber(down) == tonumber(current)+1 then nines = self:mapPathSearch({pos[1], pos[2]+1}, nines) end
  if not (left == nil) and tonumber(left) == tonumber(current)+1 then nines = self:mapPathSearch({pos[1]-1, pos[2]}, nines) end
  if not (right == nil) and tonumber(right) == tonumber(current)+1 then nines = self:mapPathSearch({pos[1]+1, pos[2]}, nines) end

  return nines
end

function Day10:removeDuplicates(list)
  tmpList = {}
  for k, v in pairs(list) do
    if not self:contains(tmpList, v) then
      table.insert(tmpList, v)
    end
  end
  return tmpList
end

function Day10:contains(list, val)
  for index, value in ipairs(list) do
    if tonumber(val[1]) == tonumber(value[1]) and tonumber(val[2]) == tonumber(value[2]) then
      return true
    end
  end
  return false
end

function Day10:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
