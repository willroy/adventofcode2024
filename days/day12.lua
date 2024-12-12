Day12 = {}

function Day12:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Day12:init()
  self.answer1 = 0
  self.answer2 = 0

  self.map = {}
  self.regionStarters = {}


  self.characterLimiter = 6

  local file = io.open("data/day12input.txt", 'r')

  if file then
    local y = 0
    for line in file:lines() do
      y = y + 1
      for x = 1, #line do
        if x == self.characterLimiter then break end
        local c = line:sub(x,x)
        if self.map[y] == nil then self.map[y] = {} end
        table.insert(self.map[y], c)
      end
    end
    file:close()
  else
    print('unable to open file')
  end

  for k, v in pairs(self.map) do
    for k2, v2 in pairs(v) do
      table.insert(self.regionStarters, {k, k2})
    end 
  end

  -- for each region starter, use region finder to build up the rest of the region

  self.regions = {}

  for k, v in pairs(self.regionStarters) do
    local runFinder = (self.regions[k] == nil)
    if not (self.regions[k] == nil) then
      for k2, v2 in pairs(self.regions[k]) do
        for k3, v3 in pairs(v3) do
          if v3[1] == v[1] and v3[2] == v[2] then
            runFinder = true
          end
        end
      end
    end 
    if runFinder then
      local region = {}
      local perimeter = 0
      region, perimeter = self:regionFinder(v, region, perimeter)
      print(k..": "..#region.." "..perimeter)
      if self.regions[k] == nil then self.regions[k] = {} end
      table.insert(self.regions[k], region)
    end
  end
end

function Day12:regionFinder(pos, region, perimeter)
  local region = region
  local perimeter = perimeter
  local current = self.map[pos[1]][pos[2]]

  if ( self:contains(region, {pos[1], pos[2]}) ) then return region, perimeter end
  if ( not ( self:contains(region, {pos[1], pos[2]}) ) ) then table.insert(region, {pos[1], pos[2]}) end

  local up = nil
  local down = nil
  local left = nil
  local right = nil
  local matchesCurrentUp = nil
  local matchesCurrentDown = nil
  local matchesCurrentLeft = nil
  local matchesCurrentRight = nil
  local regionContainsUp = nil
  local regionContainsDown = nil
  local regionContainsLeft = nil
  local regionContainsRight = nil

  if not (self.map[pos[1]-1] == nil) then up = self.map[pos[1]-1][pos[2]] end 
  if not (self.map[pos[1]+1] == nil) then down = self.map[pos[1]+1][pos[2]] end
  if not (self.map[pos[1]][pos[2]-1] == nil) then left = self.map[pos[1]][pos[2]-1] end
  if not (self.map[pos[1]][pos[2]+1] == nil) then right = self.map[pos[1]][pos[2]+1] end

  if not (up == nil) then
    matchesCurrentUp = up == current
    regionContainsUp = self:contains(region, {pos[1]-1, pos[2]})
  end

  if not (down == nil) then
    matchesCurrentDown = down == current
    regionContainsDown = self:contains(region, {pos[1]+1, pos[2]})
  end

  if not (left == nil) then
    matchesCurrentLeft = left == current
    regionContainsLeft = self:contains(region, {pos[1], pos[2]-1})
  end

  if not (right == nil) then
    matchesCurrentRight = right == current
    regionContainsRight = self:contains(region, {pos[1], pos[2]+1})
  end

  if up == nil then perimeter = perimeter + 1 end
  if down == nil then perimeter = perimeter + 1 end
  if left == nil then perimeter = perimeter + 1 end
  if right == nil then perimeter = perimeter + 1 end

  if not (up == nil) and not matchesCurrentUp then perimeter = perimeter + 1 end
  if not (down == nil) and not matchesCurrentDown then perimeter = perimeter + 1 end
  if not (left == nil) and not matchesCurrentLeft then perimeter = perimeter + 1 end
  if not (right == nil) and not matchesCurrentRight then perimeter = perimeter + 1 end

  if not (up == nil) and matchesCurrentUp and not regionContainsUp then region, perimeter = self:regionFinder({pos[1]-1, pos[2]}, region, perimeter) end
  if not (down == nil) and matchesCurrentDown and not regionContainsDown then region, perimeter = self:regionFinder({pos[1]+1, pos[2]}, region, perimeter) end
  if not (left == nil) and matchesCurrentLeft and not regionContainsLeft then region, perimeter = self:regionFinder({pos[1], pos[2]-1}, region, perimeter) end
  if not (right == nil) and matchesCurrentRight and not regionContainsRight then region, perimeter = self:regionFinder({pos[1], pos[2]+1}, region, perimeter) end

  return region, perimeter
end

function Day12:contains(list, val)
  for index, value in ipairs(list) do
    if tonumber(val[1]) == tonumber(value[1]) and tonumber(val[2]) == tonumber(value[2]) then
      return true
    end
  end
  return false
end

function Day12:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
