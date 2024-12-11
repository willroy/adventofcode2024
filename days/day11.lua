Day11 = {}

function Day11:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Day11:init()
  self.answer1 = 0
  self.answer2 = 0

  self.stones = {}

  local file = io.open("data/day11input.txt", 'r')

  if file then
    for line in file:lines() do
      for n in string.gmatch(line, "[^%s]+") do
        table.insert(self.stones, tonumber(n))
      end
    end
    file:close()
  else
    print('unable to open file')
  end

  self.blinkCount = 75

  for i = 1, self.blinkCount do
    local newStones = {}
    for k = 1, #self.stones do
      local stoneToAdd1 = self.stones[k]
      local stoneToAdd2 = nil

      if stoneToAdd1 == 0 then
        stoneToAdd1 = 1
      elseif #tostring(stoneToAdd1) % 2 == 0 then
        stoneToAdd1 = tonumber(string.sub(tostring(stoneToAdd1), 1, #tostring(stoneToAdd1)/2))
        stoneToAdd2 = tonumber(string.sub(tostring(stoneToAdd1), (#tostring(stoneToAdd1)/2)+1, #tostring(stoneToAdd1)))
      else
        stoneToAdd1 = stoneToAdd1 * 2024
      end

      table.insert(newStones, stoneToAdd1)
      if not ( stoneToAdd2 == nil ) then 
        table.insert(newStones, stoneToAdd2)
      end
    end
    self.stones = newStones
    self:showMemory()
  end

end

function Day11:showMemory()
  collectgarbage("collect")
  collectgarbage("collect")
  print(collectgarbage'count' * 1024)
end

function Day11:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
