Day03 = {}

function Day03:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.completed = true
  return o
end

function Day03:init()
  self.answer1 = 0
  self.answer2 = 0
  self.enabledMults1 = {}
  self.enabledMults2 = {}
  self.disabledCount = 0
  self.undisabledCount = 0

  self.input = {}

  local file = io.open("data/day3input.txt", 'r')

  if file then
    self.currentTracked = ""
    self.currentTrackedEnabler = ""
    self.disabled = false
    self.number1 = ""
    self.number2 = ""
      
    for line in file:lines() do
      table.insert(self.input, line)

      for i = 1, #line do
        local c = line:sub(i,i)

        if c == "d" then self.currentTrackedEnabler = self.currentTrackedEnabler..c
        elseif c == "o" and self.currentTrackedEnabler == "d" then self.currentTrackedEnabler = self.currentTrackedEnabler..c
        elseif c == "n" and self.currentTrackedEnabler == "do" then self.currentTrackedEnabler = self.currentTrackedEnabler..c
        elseif c == "'" and self.currentTrackedEnabler == "don" then self.currentTrackedEnabler = self.currentTrackedEnabler..c
        elseif c == "t" and self.currentTrackedEnabler == "don'" then self.currentTrackedEnabler = self.currentTrackedEnabler..c
        elseif c == "(" and self.currentTrackedEnabler == "don't" then self.currentTrackedEnabler = self.currentTrackedEnabler..c
        elseif c == ")" and self.currentTrackedEnabler == "don't(" then
          self.disabled = true
          self.currentTrackedEnabler = ""
          self.disabledCount = self.disabledCount + 1
        elseif c == "(" and self.currentTrackedEnabler == "do" then self.currentTrackedEnabler = self.currentTrackedEnabler..c
        elseif c == ")" and self.currentTrackedEnabler == "do(" then
          self.disabled = false
          self.currentTrackedEnabler = ""
          self.undisabledCount = self.undisabledCount + 1
        else
          self:resetEnabler()
        end

        
        if c == "m" then self.currentTracked = self.currentTracked..c 
        elseif c == "u" and self.currentTracked == "m" then self.currentTracked = self.currentTracked..c 
        elseif c == "l" and self.currentTracked == "mu" then self.currentTracked = self.currentTracked..c 
        elseif c == "(" and self.currentTracked == "mul" then self.currentTracked = self.currentTracked..c 
        elseif self.currentTracked == "mul(" then
          if tonumber(c, 10) then
            self.number1 = self.number1..c
          elseif c == "," then
            self.currentTracked = self.currentTracked..c
          else
            self:reset()
          end
        elseif self.currentTracked == "mul(," then
          if tonumber(c, 10) then
            self.number2 = self.number2..c
          elseif c == ")" then
            if ( self.disabled == false ) then
              table.insert(self.enabledMults2, (tonumber(self.number1) * tonumber(self.number2)))
            end
            table.insert(self.enabledMults1, (tonumber(self.number1) * tonumber(self.number2)))
            self.currentTracked = self.currentTracked..")"
            self:reset()
          else
            self:reset()
          end
        else
            self:reset()
        end
      end
    end

    for k, v in pairs(self.enabledMults1) do
      self.answer1 = self.answer1 + v
    end

    for k, v in pairs(self.enabledMults2) do
      self.answer2 = self.answer2 + v
    end

    for line in file:lines() do
      table.insert(self.input, line)
    end
    file:close()
  else
    print('unable to open file')
  end
end

function Day03:reset()
  self.currentTracked = ""
  self.number1 = 0
  self.number2 = 0
end

function Day03:resetEnabler()
  self.currentTrackedEnabler = ""
end

function Day03:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
