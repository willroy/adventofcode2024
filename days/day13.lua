Day13 = {}

function Day13:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Day13:init()
  self.answer1 = 0
  self.answer2 = 0

  self.games = {}

  local file = io.open("data/day13input.txt", 'r')

  if file then
    local buttonALine = true
    local buttonBLine = false
    local prizeLine = false
    local emptyLine = false
    local gameCount = 1
    for line in file:lines() do
      local currentNum = ""
      for i = 1, #line do
        local c = line:sub(i, i)
        if type(tonumber(c)) == "number" then
          currentNum = currentNum..c
        end
        if (not (type(tonumber(c)) == "number") and not (currentNum == "")) or i == #line then
          if self.games[gameCount] == nil then self.games[gameCount] = {} end
          table.insert(self.games[gameCount], tonumber(currentNum)) 
          currentNum = ""
        end
      end
      if buttonALine then buttonALine = false buttonBLine = true
      elseif buttonBLine then buttonBLine = false prizeLine = true
      elseif prizeLine then prizeLine = false emptyLine = true
      elseif emptyLine then emptyLine = false buttonALine = true gameCount = gameCount + 1 end
    end
    file:close()
  else
    print('unable to open file')
  end

  for k, v in pairs(self.games) do
    local winningCombinations = {}
    for i = 1, 100 do
      for a = 1, 100 do
        if v[1]*i + v[3]*a == v[5] then
          if v[2]*i + v[4]*a == v[6] then
            table.insert(winningCombinations, {i, a})
          end
        end
      end
    end
    if #winningCombinations > 0 then
      local winningCombination = winningCombinations[1]
      for k2, v2 in pairs(winningCombinations) do
        if (v2[1]*3 + v2[2]*1) < winningCombination[1]*3 + winningCombination[2]*1 then
          winningCombination = v2
        end
      end
      print("game ".. k..": A "..winningCombination[1].." times and B "..winningCombination[2].." times is a win")
      self.answer1 = self.answer1 + (winningCombination[1]*3 + winningCombination[2]*1)
    end
  end

  print(self.answer1)
end

function Day13:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
