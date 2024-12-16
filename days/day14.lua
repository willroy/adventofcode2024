Day14 = {}

function Day14:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.halfcompleted = true
  return o
end

function Day14:init()
  self.answer1 = 0
  self.answer2 = 0

  self.robots = {}
  self.border = {101,103}

  local file = io.open("data/day14input.txt", 'r')

  if file then
    for line in file:lines() do
      local lineSplit = {}
      for num in string.gmatch(line, "%-?%d+") do
        table.insert(lineSplit, tonumber(num))
      end
      table.insert(self.robots, lineSplit)
    end
    file:close()
  else
    print('unable to open file')
  end

  self.robotFinalPositions = {}

  for k, robot in pairs(self.robots) do
    pos = {robot[1], robot[2]}
    newPos = {0,0}
    velocity = {robot[3], robot[4]}
    timer = 100

    for t = 1, timer do
      local xStart = 1
      if velocity[1] < 0 then xStart = -1 end
      if velocity[1] < 0 then 
        for x = xStart, velocity[1], -1 do
          if pos[1] + x < 0 then newPos[1] = pos[1] + self.border[1] + x
          else newPos[1] = pos[1] + x end
        end 
      else
        for x = xStart, velocity[1] do
          if pos[1] + x >= self.border[1] then newPos[1] = pos[1] - self.border[1] + x
          else newPos[1] = pos[1] + x end
        end
      end

      local yStart = 1
      if velocity[2] < 0 then yStart = -1 end
      if velocity[2] < 0 then 
        for y = yStart, velocity[2], -1 do
          if pos[2] + y < 0 then newPos[2] = pos[2] + self.border[2] + y
          else newPos[2] = pos[2] + y end
        end 
      else
        for y = yStart, velocity[2] do
          if pos[2] + y >= self.border[2] then newPos[2] = pos[2] - self.border[2] + y
          else newPos[2] = pos[2] + y end
        end
      end

      pos[1] = newPos[1]
      pos[2] = newPos[2]
    end
    table.insert(self.robotFinalPositions, newPos)
  end

  local halfX = (self.border[1]-1)/2
  local halfY = (self.border[2]-1)/2
  local quadrant1 = {{0,0}, {halfX-1, halfY-1}}
  local quadrant2 = {{halfX+1,0}, {self.border[1]-1, halfY-1}}
  local quadrant3 = {{0,halfY+1}, {halfX-1, self.border[2]-1}}
  local quadrant4 = {{halfX+1,halfY+1}, {self.border[1]-1, self.border[2]-1}}
  local quadrant1Count = 0
  local quadrant2Count = 0
  local quadrant3Count = 0
  local quadrant4Count = 0

  for k, robot in pairs(self.robotFinalPositions) do
    if robot[1] >= quadrant1[1][1] and robot[2] >= quadrant1[1][2] and robot[1] <= quadrant1[2][1] and robot[2] <= quadrant1[2][2] then quadrant1Count = quadrant1Count + 1 end
    if robot[1] >= quadrant2[1][1] and robot[2] >= quadrant2[1][2] and robot[1] <= quadrant2[2][1] and robot[2] <= quadrant2[2][2] then quadrant2Count = quadrant2Count + 1 end
    if robot[1] >= quadrant3[1][1] and robot[2] >= quadrant3[1][2] and robot[1] <= quadrant3[2][1] and robot[2] <= quadrant3[2][2] then quadrant3Count = quadrant3Count + 1 end
    if robot[1] >= quadrant4[1][1] and robot[2] >= quadrant4[1][2] and robot[1] <= quadrant4[2][1] and robot[2] <= quadrant4[2][2] then quadrant4Count = quadrant4Count + 1 end
  end

  self.answer1 = (quadrant1Count * quadrant2Count * quadrant3Count * quadrant4Count)

  print(self.answer1)
end

function Day14:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
