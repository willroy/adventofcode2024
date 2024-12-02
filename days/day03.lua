Day03 = {}

function Day03:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Day03:init()
  self.answer1 = 0
  self.answer2 = 0

  self.input = {}

  local file = io.open("data/day3input.txt", 'r')

  if file then
    for line in file:lines() do
      table.insert(self.input, line)
    end
    file:close()
  else
    print('unable to open file')
  end
end

function Day03:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
