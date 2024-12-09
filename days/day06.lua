Day06 = {}

function Day06:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.completed = true
  return o
end

function Day06:init()
  self.answer1 = 0
  self.answer2 = 0

  self.map = {}
  self.obstacles = {}
  self.characterPos = {}
  self.characterStartingPos = {}
  self.characterStartingDir = {["xDIR"] = 0, ["yDIR"] = -1}
  self.characterDir = {["xDIR"] = 0, ["yDIR"] = -1}
  self.movements = {}
  self.junctions = {}
  self.movementsCount = 0

  local file = io.open("data/day6input.txt", 'r')

  if file then
    y = 0
    for line in file:lines() do
      y = y + 1
      table.insert(self.map, {})
      for x = 1, #line do
        local c = line:sub(x, x)
        table.insert(self.map[#self.map], c) 
        if c == "^" then
          self.characterPos = {["x"] = x, ["y"] = y}
          self.characterStartingPos = {["x"] = x, ["y"] = y}
        end
        if c == "#" then
          local obstacle = {["x"] = x, ["y"] = y}
          table.insert(self.obstacles, obstacle)
        end
      end
    end
    file:close()
  else
    print('unable to open file')
  end

  self:runGuard(self.obstacles, false)

  self.movements = self:removeDuplicates(self.movements)

  self.answer1 = #self.movements-1

  table.remove(self.movements, #self.movements);

  self.placementOptions = self:removeStartingPos(self.movements)

  self.successfullblockers = {}

  self.placementOptionsSPLIT = {}

  local count = 0
  for k, v in pairs(self.placementOptions) do
    if count == 0 then table.insert(self.placementOptionsSPLIT, {}) end
    table.insert(self.placementOptionsSPLIT[#self.placementOptionsSPLIT], v)
    if count > 300 then
      table.insert(self.placementOptionsSPLIT, {})
      count = 0
    end
    count = count + 1
  end

  -- 67 + 90 + 87 + 90 + 104 + 110 + 125 + 150 + 106 + 148 + 147 + 140 + 154 + 171 + 138 + 189 + 203 + 193 + 70 = 2482 (too high)
  -- 33 + 46 + 60 + 60 + 66  + 74  + 89  + 122 + 66  + 121 + 124 + 117 + 131 + 144 + 107 + 164 + 192 + 175 + 48 = 1939 (just right)

  for k, v in pairs(self.placementOptionsSPLIT) do
    if k == 19 then print(self:tryAlternateReality(v)) end
  end
end

function Day06:tryAlternateReality(placements)
  local successfull = {}
  print(#placements)
  local count = 0
  local total = #placements

  for k, v in pairs(placements) do
  -- local v = self.placementOptions[18]
    local objects = {}
    objects = self:addObstaclesToList(objects)
    table.insert(objects, {["x"] = v["x"], ["y"] = v["y"]})
    self.characterPos = self.characterStartingPos
    self.characterDir = self.characterStartingDir
    self.junctions = {}
    print("trying "..count.."/"..total.." is: "..v["x"].." "..v["y"])
    count = count + 1
    if self:runGuard(objects, true) then
      print("success")
      table.insert(successfull, v)
    end
  end

  return(#successfull)
end

function Day06:runGuard(obstacles, checkForLoop)
  local count = 0
  while not self:outOfBounds(self.characterPos) do
    count = count + 1
    local previousPos = self.characterPos
    local nextPos = {["x"] = (self.characterPos["x"]+self.characterDir["xDIR"]), ["y"] = (self.characterPos["y"]+self.characterDir["yDIR"])}
    if not self:hitObstacle(nextPos, obstacles) then
      self.characterPos = nextPos
      table.insert(self.movements, self.characterPos)
    else
      self.charDirX = self.characterDir["xDIR"]
      self.charDirY = self.characterDir["yDIR"]
      if tonumber(self.charDirX) == 0 and tonumber(self.charDirY) == -1 then
        self.characterDir = {["xDIR"] = 1, ["yDIR"] = 0}
      elseif tonumber(self.charDirX) == 1 and tonumber(self.charDirY) == 0 then
        self.characterDir = {["xDIR"] = 0, ["yDIR"] = 1}
      elseif tonumber(self.charDirX) == 0 and tonumber(self.charDirY) == 1 then
        self.characterDir = {["xDIR"] = -1, ["yDIR"] = 0}
      elseif tonumber(self.charDirX) == -1 and tonumber(self.charDirY) == 0 then
        self.characterDir = {["xDIR"] = 0, ["yDIR"] = -1}
      end
      table.insert(self.junctions, previousPos["x"].." "..previousPos["y"]..nextPos["x"]..nextPos["y"]) 
    end

    if checkForLoop and self:checkJunctionsForLoop(self.junctions) then return true end
    -- if checkForLoop and count > 1000 then return true end
  end
  return false
end

function Day06:checkJunctionsForLoop(list)
  local size = 1
  while size < (#list / 3) do
    local segments = {}
    for seg = 1, 2 do
      segments[seg] = {}
      for i = 1, size do
        local index = #list-((seg-1)*size)-(i-1)
        table.insert(segments[seg], list[index])
      end
    end

    if self:arrayEqual(segments[1], segments[2]) then
      print("looping!!")
      return true
    end
    size = size + 1
  end
  return false
end

function Day06:arrayEqual(a1, a2)
  -- Check length, or else the loop isn't valid
  if #a1 ~= #a2 then
    return false
  end
  for i, v in ipairs(a1) do
    if v ~= a2[i] then
      return false
    end
  end
  return true
end


function Day06:addObstaclesToList(list)
  for k, v in pairs(self.obstacles) do
    table.insert(list, v)
  end
  return list
end

function Day06:outOfBounds(pos)
  if pos["x"] > #self.map[1] then return true end
  if pos["x"] < 0 then return true end
  if pos["y"] > #self.map then return true end
  if pos["y"] < 0 then return true end
  return false
end

function Day06:hitObstacle(pos, obstacles)
  for k, v in pairs(obstacles) do
    local posX = pos["x"]
    local posY = pos["y"]
    if tonumber(v["x"]) == tonumber(posX) and tonumber(v["y"]) == tonumber(posY) then
      return true
    end
  end
  return false
end

function Day06:removeDuplicates(list)
  tmpList = {}
  for k, v in pairs(list) do
    if not self:contains(tmpList, v) then
      table.insert(tmpList, v)
    end
  end
  return tmpList
end

function Day06:removeStartingPos(list)
  local newList = {}
  for index, value in ipairs(list) do
    local valX = value["x"]
    local valY = value["y"]
    local startX = self.characterStartingPos["x"]
    local startY = self.characterStartingPos["y"]
    if tonumber(valX) == tonumber(startX) and tonumber(valY) == tonumber(startY) then
      -- nothing
    else
      table.insert(newList, value)
    end
  end
  return newList
end

function Day06:contains(list, val)
  for index, value in ipairs(list) do
    local valX = val["x"]
    local valY = val["y"]
    local valueX = value["x"]
    local valueY = value["y"]
    if tonumber(valX) == tonumber(valueX) and tonumber(valY) == tonumber(valueY) then
      return true
    end
  end
  return false
end

function Day06:dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. self:dump(v) .. ', '
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function Day06:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
