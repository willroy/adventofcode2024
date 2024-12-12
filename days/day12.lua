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

  self.characterLimiter = 141

  local file = io.open("data/day12input.txt", 'r')

  if file then
    local y = 0
    for line in file:lines() do
      y = y + 1
      for x = 1, #line do
        if x == self.characterLimiter then break end
        local c = line:sub(x, x)
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
      if self.regionStarters[v2] == nil then self.regionStarters[v2] = {} end
      table.insert(self.regionStarters[v2], { k, k2 })
    end
  end

  -- for each region starter, use region finder to build up the rest of the region

  self.regions = {}

  for k, v in pairs(self.regionStarters) do
    for k2, v2 in pairs(v) do
      local runFinder = true
      if not (self.regions[k] == nil) then
        for k3, v3 in pairs(self.regions[k]) do
          for k4, v4 in pairs(v3) do
            if v4[1] == v2[1] and v4[2] == v2[2] then
              runFinder = false
            end
          end
        end
      end
      if runFinder then
        local region = {}
        local perimeter = {}
        region, perimeter = self:regionFinder(v2, region, perimeter)
        if self.regions[k] == nil then self.regions[k] = {} end
        table.insert(self.regions[k], region)
        self.answer1 = self.answer1 + (#region * #perimeter)
        
        local newPerimeter = {}
        for k3, v3 in pairs(perimeter) do
          local isntDuplicate, isntAdjacent, isntSameDir = self:checkPermimeterPos(newPerimeter, v3)
          if ( isntDuplicate or ( not isntDuplicate and isntSameDir )) and isntAdjacent then table.insert(newPerimeter, v3) end 
        end
        local newPerimeterCount = tonumber(#newPerimeter)
        if not (newPerimeterCount % 2 == 0) then newPerimeterCount = math.floor(newPerimeterCount/2 + 0.5) * 2 end
        self.answer2 = self.answer2 + (#region * newPerimeterCount)
      end
    end
  end

  print(self.answer1)
  print(self.answer2)
end

function Day12:checkPermimeterPos(perimeter, value)
  local isntDuplicate = true
  local isntAdjacent = true
  local isntSameDir = true
  
  -- check if perimeter is colliding with another and check if its the same dir as another
  
  for k, v in pairs(perimeter) do
    if v[1] == value[1] and v[2] == value[2] and v[3] == value[3] then isntDuplicate = false end
    if v[1] == value[1] then isntSameDir = false end
  end
  
  -- check adjacancy with other perimeters
  
  isntAdjacent = self:checkAdjacency(perimeter, value, self.map)
  
  return isntDuplicate, isntAdjacent, isntSameDir
end

function Day12:checkAdjacency(perimeter, placement, map)
  -- get pos and direction of placement

  local pos = {placement[2], placement[3]}
  local dir = placement[1]
  
  -- get direction based on dir

  if dir == "up" then dirNum = {-1,0} end
  if dir == "down" then dirNum = {1,0} end
  if dir == "left" then dirNum = {0,-1} end
  if dir == "right" then dirNum = {0,1} end
  
  -- get the letter that the perimeter was placed from

  local lPos = {}
  lPos[1] = pos[1]-dirNum[1]
  lPos[2] = pos[2]-dirNum[2]
  local letter = map[lPos[1]][lPos[2]]
  
  -- get check directions based on dir

  if dir == "up" or dir == "down" then dirNum = {{0,-1},{0,1}} end
  if dir == "left" or dir == "right" then dirNum = {{-1,0},{1,0}} end
  
  -- go in direction until map[lPos[1]][lPos[2]] is nil or a different letter to get the range

  for k, d in pairs(dirNum) do
    count = 0
    lPosTmp = {}
    lPosTmp[1], lPosTmp[2] = lPos[1], lPos[2]
    lPosTmp[1], lPosTmp[2] = lPosTmp[1]-d[1], lPosTmp[2]-d[2]

    while not ( map[lPosTmp[1]] == nil ) and not ( map[lPosTmp[1]][lPosTmp[2]] == nil ) and map[lPosTmp[1]][lPosTmp[2]] == letter do
      lPosTmp[1], lPosTmp[2] = lPosTmp[1]-d[1], lPosTmp[2]-d[2]
      count = count + 1
    end
    
    -- check for adjacancy using direction range

    local posTmp = {}
    posTmp[1], posTmp[2] = pos[1], pos[2]
    for i = 1, count do
      posTmp[1], posTmp[2] = posTmp[1]-d[1], posTmp[2]-d[2]
      for k, v in pairs(perimeter) do
        local mapLetter = ""
        if not (map[posTmp[1]] == nil) and not (map[posTmp[1]][posTmp[2]] == nil) and map[posTmp[1]][posTmp[2]] == letter then break end
        if v[2] == posTmp[1] and v[3] == posTmp[2] then return false end
      end
      if not (map[posTmp[1]] == nil) and not (map[posTmp[1]][posTmp[2]] == nil) and map[posTmp[1]][posTmp[2]] == letter then break end
    end
  end
  
  return true
end

function Day12:regionFinder(pos, region, perimeter)
  local current = self.map[pos[1]][pos[2]]

  if (self:contains(region, { pos[1], pos[2] })) then return region, perimeter end
  if (not (self:contains(region, { pos[1], pos[2] }))) then table.insert(region, { pos[1], pos[2] }) end

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

  if not (self.map[pos[1] - 1] == nil) then up = self.map[pos[1] - 1][pos[2]] end
  if not (self.map[pos[1] + 1] == nil) then down = self.map[pos[1] + 1][pos[2]] end
  if not (self.map[pos[1]][pos[2] - 1] == nil) then left = self.map[pos[1]][pos[2] - 1] end
  if not (self.map[pos[1]][pos[2] + 1] == nil) then right = self.map[pos[1]][pos[2] + 1] end

  if not (up == nil) then
    matchesCurrentUp = up == current
    regionContainsUp = self:contains(region, { pos[1] - 1, pos[2] })
  end

  if not (down == nil) then
    matchesCurrentDown = down == current
    regionContainsDown = self:contains(region, { pos[1] + 1, pos[2] })
  end

  if not (left == nil) then
    matchesCurrentLeft = left == current
    regionContainsLeft = self:contains(region, { pos[1], pos[2] - 1 })
  end

  if not (right == nil) then
    matchesCurrentRight = right == current
    regionContainsRight = self:contains(region, { pos[1], pos[2] + 1 })
  end

  if (up == nil) or (not (up == nil) and not matchesCurrentUp) then table.insert(perimeter, { "up", pos[1] - 1, pos[2] }) end
  if (down == nil) or (not (down == nil) and not matchesCurrentDown) then table.insert(perimeter, { "down", pos[1] + 1, pos[2] }) end
  if (left == nil) or (not (left == nil) and not matchesCurrentLeft) then table.insert(perimeter, { "left", pos[1], pos[2] - 1 }) end
  if (right == nil) or (not (right == nil) and not matchesCurrentRight) then table.insert(perimeter, { "right", pos[1], pos[2] + 1 }) end

  if not (up == nil) and matchesCurrentUp and not regionContainsUp then region, perimeter = self:regionFinder({ pos[1] - 1, pos[2] }, region, perimeter) end
  if not (down == nil) and matchesCurrentDown and not regionContainsDown then region, perimeter = self:regionFinder({ pos[1] + 1, pos[2] }, region, perimeter) end
  if not (left == nil) and matchesCurrentLeft and not regionContainsLeft then region, perimeter = self:regionFinder({ pos[1], pos[2] - 1 }, region, perimeter) end
  if not (right == nil) and matchesCurrentRight and not regionContainsRight then region, perimeter = self:regionFinder({ pos[1], pos[2] + 1 }, region, perimeter) end

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
