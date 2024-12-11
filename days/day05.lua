Day05 = {}

function Day05:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.completed = true
  return o
end

function Day05:init()
  self.answer1 = 0
  self.answer2 = 0

  self.rules = {}
  self.input = {}

  local file = io.open("data/day05input.txt", 'r')

  if file then
    local lineBreak = false
    for line in file:lines() do
      local nums = self:split(line, "|")
      if ( nums[1] == nil or nums[2] == nil ) then table.insert(self.input, line)
      else
        if self.rules[tostring(nums[1])] then
          table.insert(self.rules[tostring(nums[1])], nums[2])
        else
          self.rules[tostring(nums[1])] = {nums[2]}
        end
      end
    end
    file:close()
  else
    print('unable to open file')
  end

  table.remove(self.input, 1)

  local correct = {}
  local incorrect = {}

  for k, v in pairs(self.input) do
    local nums = self:split(v, ",")
    local good = true
    local badIndex = ""

    good, badIndex = self:listValid(nums)

    if good then
      table.insert(correct, self:split(v, ","))
    end
    if not good then
      table.insert(incorrect, self:split(v, ","))
    end
  end

  for k, v in pairs(correct) do
    local middleIndex = 0
    if #v % 2 == 0 then
      middleIndex = #v / 2
    else
      middleIndex = ((#v-1)/2)+1
    end
    self.answer1 = self.answer1 + tonumber(v[middleIndex])
  end

  -- order incorrect

  for k, v in pairs(incorrect) do
    local good, sortedList = self:sortList(v)
    local numberList = {}
    for k2, v2 in pairs(sortedList) do
      table.insert(numberList, tonumber(v2))
    end
    local middleIndex = 0
    if #numberList % 2 == 0 then
      middleIndex = #numberList / 2
    else
      middleIndex = ((#numberList-1)/2)+1
    end
    self.answer2 = self.answer2 + numberList[middleIndex]
  end
end

function Day05:sortList(list)
  local good = true
  local badIndex = ""

  good, badIndex = self:listValid(list)

  if not good then
    local sorted = false
    local sortedList = {}
    sorted, sortedList = self:sortList(self:swap(list, badIndex, badIndex+1))
    if sorted then return sorted, sortedList end
  end
  if good then return true, list end
  return false, {}
end

function Day05:listValid(list)
  for k2, v2 in pairs(list) do
    local nextNum = list[k2+1]
    local nextNumStr = tostring(tonumber(nextNum))

    if #list == k2 then break end

    if self.rules[nextNumStr] ~= nil and self.rules[nextNumStr][1] and tonumber(self.rules[nextNumStr][1]) == tonumber(v2) then
      return false, k2
    end
    if type(self.rules[nextNumStr]) == "table" and self:contains(self.rules[nextNumStr], v2) then
      return false, k2
    end
  end
  return true, ""
end

function Day05:contains(tab, val)
  for index, value in ipairs(tab) do
    if tonumber(value) == tonumber(val) then
      return true
    end
  end

  return false
end

function Day05:swap(table, pos1, pos2)
    local tmp = table[pos1]
    table[pos1] = table[pos2]
    table[pos2] = tmp
    return table
end

function Day05:split(s, sep)
    local fields = {}
    
    local sep = sep or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)
    
    return fields
end

function Day05:draw()
  love.graphics.print(tostring("answer 1: " .. self.answer1), 100, 100)
  love.graphics.print(tostring("answer 2: " .. self.answer2), 100, 200)
end
