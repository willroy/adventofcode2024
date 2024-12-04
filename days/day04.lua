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

  self.occurences = 0
  self.horizontal1 = ""
  self.horizontal2 = ""
  self.verticalDown = ""
  self.verticalUp = ""
  self.diagonalSE = ""
  self.diagonalSW = ""
  self.diagonalNE = ""
  self.diagonalNW = ""

  for k, line in pairs(self.input) do
    for i = 1, #line do
      local c = line:sub(i, i)

      -- horizontals

      if #line >= (i + 3) then
        local char2 = line:sub(i + 1, i + 1)
        local char3 = line:sub(i + 2, i + 2)
        local char4 = line:sub(i + 3, i + 3)

        self.horizontal1 = c .. char2 .. char3 .. char4
      end

      if (i - 3) > 0 then
        local char2 = line:sub(i - 1, i - 1)
        local char3 = line:sub(i - 2, i - 2)
        local char4 = line:sub(i - 3, i - 3)

        self.horizontal2 = c .. char2 .. char3 .. char4
      end

      -- verticals

      if #self.input >= (k + 3) then
        local char2 = self.input[k + 1]:sub(i, i)
        local char3 = self.input[k + 2]:sub(i, i)
        local char4 = self.input[k + 3]:sub(i, i)

        self.verticalDown = c .. char2 .. char3 .. char4
      end

      if (k - 3) > 0 then
        local char2 = self.input[k - 1]:sub(i, i)
        local char3 = self.input[k - 2]:sub(i, i)
        local char4 = self.input[k - 3]:sub(i, i)

        self.verticalUp = c .. char2 .. char3 .. char4
      end

      -- diagonals

      if #self.input >= k + 3 and i + 3 <= #self.input[k + 3] then
        local char2 = self.input[k + 1]:sub(i + 1, i + 1)
        local char3 = self.input[k + 2]:sub(i + 2, i + 2)
        local char4 = self.input[k + 3]:sub(i + 3, i + 3)

        self.diagonalSE = c .. char2 .. char3 .. char4
      end

      if #self.input >= k + 3 and i - 3 > 0 then
        local char2 = self.input[k + 1]:sub(i - 1, i - 1)
        local char3 = self.input[k + 2]:sub(i - 2, i - 2)
        local char4 = self.input[k + 3]:sub(i - 3, i - 3)

        self.diagonalSW = c .. char2 .. char3 .. char4
      end

      if k - 3 > 0 and i + 3 <= #self.input[k - 3] then
        local char2 = self.input[k - 1]:sub(i + 1, i + 1)
        local char3 = self.input[k - 2]:sub(i + 2, i + 2)
        local char4 = self.input[k - 3]:sub(i + 3, i + 3)

        self.diagonalNE = c .. char2 .. char3 .. char4
      end

      if k - 3 > 0 and i - 3 > 0 then
        local char2 = self.input[k - 1]:sub(i - 1, i - 1)
        local char3 = self.input[k - 2]:sub(i - 2, i - 2)
        local char4 = self.input[k - 3]:sub(i - 3, i - 3)

        self.diagonalNW = c .. char2 .. char3 .. char4
      end

      -- count occurences

      if self.horizontal1 == "XMAS" then
        self.occurences = self.occurences + 1
        print("self.horizontal1 " .. self.horizontal1 .. " at " .. k .. ", " .. i)
      end
      if self.horizontal2 == "XMAS" then
        self.occurences = self.occurences + 1
        print("self.horizontal2 " .. self.horizontal2 .. " at " .. k .. ", " .. i)
      end
      if self.verticalDown == "XMAS" then
        self.occurences = self.occurences + 1
        print("self.verticalDown " .. self.verticalDown .. " at " .. k .. ", " .. i)
      end
      if self.verticalUp == "XMAS" then
        self.occurences = self.occurences + 1
        print("self.verticalUp " .. self.verticalUp .. " at " .. k .. ", " .. i)
      end
      if self.diagonalSE == "XMAS" then
        self.occurences = self.occurences + 1
        print("self.diagonalSE " .. self.diagonalSE .. " at " .. k .. ", " .. i)
      end
      if self.diagonalSW == "XMAS" then
        self.occurences = self.occurences + 1
        print("self.diagonalSW " .. self.diagonalSW .. " at " .. k .. ", " .. i)
      end
      if self.diagonalNE == "XMAS" then
        self.occurences = self.occurences + 1
        print("self.diagonalNE " .. self.diagonalNE .. " at " .. k .. ", " .. i)
      end
      if self.diagonalNW == "XMAS" then
        self.occurences = self.occurences + 1
        print("self.diagonalNW " .. self.diagonalNW .. " at " .. k .. ", " .. i)
      end
    end
  end

  self.answer1 = ((self.occurences / 2) * 2)

  for k, line in pairs(self.input) do
    for i = 1, #line do
      local c = line:sub(i, i)

      -- x-mas

      local haveSpaceToRight = #line >= (i + 2)
      local haveSpaceDown = #self.input >= (k + 2)

      if haveSpaceToRight and haveSpaceDown then
        local topRightToDownLeftChars =
            line:sub(i + 2, i + 2) ..
            self.input[k + 1]:sub(i + 2 - 1, i + 2 - 1) ..
            self.input[k + 2]:sub(i + 2 - 2, i + 2 - 2)

        local topLeftToDownRightChars =
            c ..
            self.input[k + 1]:sub(i + 1, i + 1) ..
            self.input[k + 2]:sub(i + 2, i + 2)

        if (topRightToDownLeftChars == "MAS" or topRightToDownLeftChars == "SAM") and (topLeftToDownRightChars == "MAS" or topLeftToDownRightChars == "SAM") then
          self.answer2 = self.answer2 + 1
        end
      end
    end
  end
end

function Day04:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
