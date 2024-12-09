Day08 = {}

function Day08:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.completed = true
  return o
end

function Day08:init()
  self.answer1 = 0
  self.answer2 = 0

  self.locations = {}

  self.maxX = 0
  self.maxY = 0

  local file = io.open("data/day8input.txt", 'r')

  -- compile a list of locations by character index

  if file then
    local y = 0 
    for line in file:lines() do
      if y == 0 then self.maxX = #line end
      y = y + 1
      self.maxY = y
      for x = 1, #line do
        local c = line:sub(x,x)
        if c:match("%a+") or type(tonumber(c)) == "number" then
          if self.locations[c] == nil then self.locations[c] = {} end
          table.insert(self.locations[c], {x, y}) 
        end
      end
    end
    file:close()
  else
    print('unable to open file')
  end

  for k, v in pairs(self.locations) do
    print(k..":")
    for k2, v2 in pairs(v) do
      io.write(v2[1]..","..v2[2].." ")
    end
    print()
    print()
  end

  -- compile a list of possible antinode positions based on x y differences 

  self.antinodeLocations1 = {}
  self.antinodeLocations2 = {}

  for k, v in pairs(self.locations) do

    -- get all combinations for letter / num

    local combinations = {}
    for k2, v2 in pairs(v) do
      local current = v2
      for k3, v3 in pairs(v) do
        if k3 > k2 then
          table.insert(combinations, {current, v3})
        end
      end
    end

    -- go through combinations and compare pos to get difference

    for k2, v2 in pairs(combinations) do
      local x1 = v2[1][1]
      local y1 = v2[1][2]
      local x2 = v2[2][1]
      local y2 = v2[2][2]
      local difference = {-(x1-x2), -(y1-y2)}

      -- now difference is found, get the two antinode positions

      local antinode_x1 = x1 - difference[1]
      local antinode_y1 = y1 - difference[2]
      local antinode_x2 = x2 + difference[1]
      local antinode_y2 = y2 + difference[2]

      -- append antinodes to self.antinodeLocations1 as long as they are not out of bounds

      if antinode_x1 > 0 and antinode_y1 > 0 and antinode_x1 < self.maxX and antinode_y1 <= self.maxY then
        table.insert(self.antinodeLocations1, {antinode_x1, antinode_y1})
      end
      if antinode_x2 > 0 and antinode_y2 > 0 and antinode_x2 < self.maxX and antinode_y2 <= self.maxY then
        table.insert(self.antinodeLocations1, {antinode_x2, antinode_y2})
      end

      -- while latest antinode in't out of bounds, keep adding on in with same difference

      table.insert(self.antinodeLocations2, {x1, y1})
      table.insert(self.antinodeLocations2, {x2, y2})

      while antinode_x1 > 0 and antinode_y1 > 0 and antinode_x1 < self.maxX and antinode_y1 <= self.maxY do
        table.insert(self.antinodeLocations2, {antinode_x1, antinode_y1})
        print(k.." antinode "..antinode_x1..","..antinode_y1.." accepted")

        antinode_x1 = antinode_x1 - difference[1]
        antinode_y1 = antinode_y1 - difference[2]
      end

      while antinode_x2 > 0 and antinode_y2 > 0 and antinode_x2 < self.maxX and antinode_y2 <= self.maxY do
        table.insert(self.antinodeLocations2, {antinode_x2, antinode_y2})
        print(k.." antinode "..antinode_x2..","..antinode_y2.." accepted")

        antinode_x2 = antinode_x2 + difference[1]
        antinode_y2 = antinode_y2 + difference[2]
      end
    end
  end

  -- filter out duplicate antinode locations

  local tmpAntinodes = self.antinodeLocations1
  self.antinodeLocations1 = {}
  for k, v in pairs(tmpAntinodes) do
    local foundAlready = false
    for k2, v2 in pairs(self.antinodeLocations1) do
      if v2[1] == v[1] and v2[2] == v[2] then foundAlready = true end
    end
    if not foundAlready then table.insert(self.antinodeLocations1, v) end
  end

  print(#self.antinodeLocations1)

  self.answer1 = #self.antinodeLocations1

  -- filter out duplicate antinode locations 2

  local tmpAntinodes = self.antinodeLocations2
  self.antinodeLocations2 = {}
  for k, v in pairs(tmpAntinodes) do
    local foundAlready = false
    for k2, v2 in pairs(self.antinodeLocations2) do
      if v2[1] == v[1] and v2[2] == v[2] then foundAlready = true end
    end
    if not foundAlready then table.insert(self.antinodeLocations2, v) end
  end

  print(#self.antinodeLocations2)

  self.answer2 = #self.antinodeLocations2
end

function Day08:draw()
  -- 255 was too high
  -- 253 was too low
  -- 252 was too low
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
