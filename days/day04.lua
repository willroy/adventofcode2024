Day04 = {}

function Day04:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Day04:init()
  self.answer1 = 0
  self.answer2 = 0

  self.input = {}

  local file = io.open("data/day4input.txt", 'r')

  if file then
    for line in file:lines() do
      table.insert(self.input, line)
    end
    file:close()
  else
    print('unable to open file')
  end

  local occurences = 0
  local horizontal1 = ""
  local horizontal2 = ""
  local vertical1 = ""
  local vertical2 = ""
  local diagonalSE = ""
  local diagonalSW = ""
  local diagonalNE = ""
  local diagonalNW = ""

  for k, line in pairs(self.input) do
    for i = 1, #line do
      local c = line:sub(i,i)

      if #line >= i+3 then
        horizontal1 = c..line:sub(i,i+1)..line:sub(i,i+2)..line:sub(i,i+3)
      end
      if i-3 > 0 then
        horizontal2 = c..line:sub(i-1,i)..line:sub(i-2,i)..line:sub(i-3,i)
      end
      if #self.input >= k+3 then
        vertical1 = c..(self.input[k+1]:sub(i,i))..(self.input[k+2]:sub(i,i))..(self.input[k+3]:sub(i,i))
      end
      if k-3 > 0 then
        vertical2 = c..(self.input[k-1]:sub(i,i))..(self.input[k-2]:sub(i,i))..(self.input[k-3]:sub(i,i))
      end

      if #self.input >= k+3 and i+3 <= #self.input[k+3] then
        diagonalSE = c..(self.input[k+1]:sub(i+1,i+1))..(self.input[k+2]:sub(i+2,i+2))..(self.input[k+3]:sub(i+3,i+3))
      end
      if #self.input >= k+3 and i-3 > 0 then
        diagonalSW = c..(self.input[k+1]:sub(i-1,i-1))..(self.input[k+2]:sub(i-2,i-2))..(self.input[k+3]:sub(i-3,i-3))
      end
      if k-3 > 0 and i+3 <= #self.input[k-3] then
        diagonalNE = c..(self.input[k-1]:sub(i+1,i+1))..(self.input[k-2]:sub(i+2,i+2))..(self.input[k-3]:sub(i+3,i+3))
      end
      if k-3 > 0 and i-3 > 0 then
        diagonalNW = c..(self.input[k-1]:sub(i-1,i-1))..(self.input[k-2]:sub(i-2,i-2))..(self.input[k-3]:sub(i-3,i-3))
      end

      if horizontal1 == "XMAS" then
        occurences = occurences + 1
        print("horizontal1 "..horizontal1.." at "..k..", "..i)
      end
      if horizontal2 == "XMAS" then
        occurences = occurences + 1
        print("horizontal2 "..horizontal2.." at "..k..", "..i)
      end
      if vertical1 == "XMAS" then
        occurences = occurences + 1
        print("vertical1 "..vertical1.." at "..k..", "..i)
      end
      if vertical2 == "XMAS" then
        occurences = occurences + 1
        print("vertical2 "..vertical2.." at "..k..", "..i)
      end
      if diagonalSE == "XMAS" then
        occurences = occurences + 1
        print("diagonalSE "..diagonalSE.." at "..k..", "..i)
      end
      if diagonalSW == "XMAS" then
        occurences = occurences + 1
        print("diagonalSW "..diagonalSW.." at "..k..", "..i)
      end
      if diagonalNE == "XMAS" then
        occurences = occurences + 1
        print("diagonalNE "..diagonalNE.." at "..k..", "..i)
      end
      if diagonalNW == "XMAS" then
        occurences = occurences + 1
        print("diagonalNW "..diagonalNW.." at "..k..", "..i)
      end
    end
  end

  print(occurences/2)
end

function Day04:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
