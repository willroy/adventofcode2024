Day07 = {}

function Day07:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.completed = true
  return o
end

function Day07:init()
  self.answer1 = 0
  self.answer2 = 0

  self.answers = {}
  self.operations = {}

  local file = io.open("data/day7input.txt", 'r')

  if file then
    for line in file:lines() do
      local answer = self:split(line, ":")[1]
      local operation = self:split(line, ":")[2]
      operation = self:split(operation, " ")

      table.insert(self.answers, answer)
      table.insert(self.operations, operation)
    end
    file:close()
  else
    print('unable to open file')
  end

  for k, v in pairs(self.operations) do
    local combinations = self:generateOperatorCombinations(#v-1)
    local answer = 0
    for k2, combination in pairs(combinations) do
      for k3, op in pairs(v) do
        if k3 == 1 then answer = op end
        if k3 > 1 then
          local char = combination:sub(k3-1, k3-1)
          if char == "+" then answer = answer + v[k3] end
          if char == "*" then answer = answer * v[k3] end
          if char == "|" then answer = tonumber(tostring(answer)..tostring(v[k3])) end
        end
      end
      if tonumber(answer) == tonumber(self.answers[k]) then self.answer1 = self.answer1 + tonumber(self.answers[k]) break end
      answer = 0
    end
  end

  print(string.format("%.0f",self.answer1))
end

function Day07:split(s, sep)
    local fields = {}
    
    local sep = sep or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)
    
    return fields
end

function Day07:generateOperatorCombinations(stringLength)
  local columns = {}

  local charRange = {"+", "*", "|"}

  local workbench = {}
  local results = {}
  local charpowers = self:getCharPower(stringLength, charRange)
  for x = 1, stringLength do
    while #workbench < 3^stringLength do
      for i = 1, #charRange do
        for z = 1, charpowers[x] do
          table.insert(workbench, charRange[i])
        end
      end
    end
    table.insert(results, workbench)
    workbench = {}
  end

  local combinations = {}

  for k, v in pairs(results) do
    for k2, v2 in pairs(v) do
      if combinations[k2] == nil then combinations[k2] = "" end
      combinations[k2] = combinations[k2] .. v2
    end
  end

  return combinations
end

function Day07:getCharPower(stringLength, charRange)
  charpowers = {}
  for x = 1, stringLength do
    table.insert(charpowers, 3^(stringLength - x))
  end
  return charpowers
end 

function Day07:dump(o)
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

function Day07:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
