Day11 = {}

function Day11:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.completed = true
  return o
end

function Day11:init()
  self.answer1 = 0
  self.answer2 = 0

  self.stones1 = {}
  self.stones2 = {}

  local file = io.open("data/day11input.txt", 'r')

  if file then
    for line in file:lines() do
      for n in string.gmatch(line, "[^%s]+") do
        table.insert(self.stones1, tonumber(n))
        table.insert(self.stones2, tonumber(n))
      end
    end
    file:close()
  else
    print('unable to open file')
  end

  print(string.format("%.0f", self:part1(25)))
  print(string.format("%.0f", self:part2(75)))
end

function Day11:part2(blinkCount)
  local stonesDict = {}

  for k, v in pairs(self.stones2) do
    if stonesDict[v] == nil then stonesDict[v] = 0 end
    stonesDict[v] = stonesDict[v] + 1
  end

  for i = 1, blinkCount do
    newStonesDict = {}
    for k, v in pairs(stonesDict) do newStonesDict[k] = v end

    local addedValues = {}

    for k, v in pairs(stonesDict) do
      if v > 0 then
        if k == 0 then
          if newStonesDict[1] == nil then newStonesDict[1] = 0 end
          newStonesDict[1] = newStonesDict[1] + v
          if addedValues[1] == nil then addedValues[1] = 0 end
          addedValues[1] = addedValues[1] + v
          newStonesDict[k] = 0
          if not (addedValues[k] == nil) and addedValues[k] > 0 then newStonesDict[k] = addedValues[k] end
        elseif #tostring(k) % 2 == 0 then
          local split1 = tonumber(string.sub(tostring(k), 1, #tostring(k) / 2))
          local split2 = tonumber(string.sub(tostring(k), (#tostring(k) / 2) + 1, #tostring(k)))
          if newStonesDict[split1] == nil then newStonesDict[split1] = 0 end
          if newStonesDict[split2] == nil then newStonesDict[split2] = 0 end
          newStonesDict[split1] = newStonesDict[split1] + v
          newStonesDict[split2] = newStonesDict[split2] + v
          if addedValues[split1] == nil then addedValues[split1] = 0 end
          addedValues[split1] = addedValues[split1] + v
          if addedValues[split2] == nil then addedValues[split2] = 0 end
          addedValues[split2] = addedValues[split2] + v
          newStonesDict[k] = 0
          if not (addedValues[k] == nil) and addedValues[k] > 0 then newStonesDict[k] = addedValues[k] end
        else
          local newKey = k * 2024
          if newStonesDict[newKey] == nil then newStonesDict[newKey] = 0 end
          newStonesDict[newKey] = newStonesDict[newKey] + v
          if addedValues[newKey] == nil then addedValues[newKey] = 0 end
          addedValues[newKey] = addedValues[newKey] + v
          newStonesDict[k] = 0
          if not (addedValues[k] == nil) and addedValues[k] > 0 then newStonesDict[k] = addedValues[k] end
        end
      end
    end

    stonesDict = {}
    for k, v in pairs(newStonesDict) do stonesDict[k] = v end
  end

  local total = 0

  for k, v in pairs(stonesDict) do
    total = total + v
  end

  return total
end

function Day11:part1(blinkCount)
  if blinkCount > 25 then
    print("this method is too slow for greater than 25 blinks")
    return 0
  end
  for i = 1, blinkCount do
    local newStones = {}
    for k = 1, #self.stones1 do
      local stoneToAdd1 = self.stones1[k]
      local stoneToAdd2 = nil

      if stoneToAdd1 == 0 then
        stoneToAdd1 = 1
      elseif #tostring(stoneToAdd1) % 2 == 0 then
        stoneToAdd1 = tonumber(string.sub(tostring(stoneToAdd1), 1, #tostring(stoneToAdd1) / 2))
        stoneToAdd2 = tonumber(string.sub(tostring(stoneToAdd1), (#tostring(stoneToAdd1) / 2) + 1, #tostring(stoneToAdd1)))
      else
        stoneToAdd1 = stoneToAdd1 * 2024
      end

      table.insert(newStones, stoneToAdd1)
      if not (stoneToAdd2 == nil) then
        table.insert(newStones, stoneToAdd2)
      end
    end
    self.stones1 = newStones
    -- self:showMemory()
  end
  return #self.stones1
end

function Day11:showMemory()
  collectgarbage("collect")
  collectgarbage("collect")
  print(collectgarbage 'count' * 1024)
end

function Day11:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
