Day02 = {}

function Day02:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.completed = true
  return o
end

function Day02:init()
  self.answer1 = 0
  self.answer2 = 0

  self.input = {}

  local file = io.open("data/day2input.txt", 'r')

  if file then
    for line in file:lines() do
      local linesplit = {}
      for x in string.gmatch(line, "[^%s]+") do
        table.insert(linesplit, x)
      end
      table.insert(self.input, linesplit)
    end
    file:close()
  else
    print('unable to open file')
  end

  local reportsSafety1 = {}
  local reportsSafety2 = {}

  for k, v in pairs(self.input) do
    local safe = true
    local lastDir = 0
    local dir = 0
    local lastVal = v[1]

    for k2, v2 in pairs(v) do
      k2 = tonumber(k2)
      v2 = tonumber(v2)
      lastVal = tonumber(lastVal)
      if lastVal > v2 then dir = -1 end
      if lastVal < v2 then dir = 1 end
      if lastVal == v2 and k2 ~= 1 then
        safe = false
        break
      end
      if (lastVal > v2 and ((lastVal - v2) > 3)) or (lastVal < v2 and ((v2 - lastVal) > 3)) then
        safe = false
      end
      lastVal = v2

      if dir ~= 0 and lastDir ~= 0 then
        if lastDir ~= dir then
          safe = false
          break
        end
      end
      lastDir = dir
    end

    for i = 1, #v do
      local tmpTable = {}
      local count = 1
      for k2, v2 in pairs(v) do
        if k2 ~= i then
          tmpTable[count] = v2
          count = count + 1
        end
      end

      local altsafe = true
      local lastDir = 0
      local dir = 0
      local lastVal = tmpTable[1]

      for k2, v2 in pairs(tmpTable) do
        k2 = tonumber(k2)
        v2 = tonumber(v2)
        lastVal = tonumber(lastVal)
        if lastVal > v2 then dir = -1 end
        if lastVal < v2 then dir = 1 end
        if lastVal == v2 and k2 ~= 1 then
          altsafe = false
          break
        end
        if (lastVal > v2 and ((lastVal - v2) > 3)) or (lastVal < v2 and ((v2 - lastVal) > 3)) then
          altsafe = false
        end
        lastVal = v2

        if dir ~= 0 and lastDir ~= 0 then
          if lastDir ~= dir then
            altsafe = false
            break
          end
        end
        lastDir = dir
      end
      if altsafe then
        table.insert(reportsSafety2, true)
        break
      end
    end
    table.insert(reportsSafety1, safe)
  end


  for k, v in pairs(reportsSafety1) do
    if v then self.answer1 = self.answer1 + 1 end
  end

  for k, v in pairs(reportsSafety2) do
    if v then self.answer2 = self.answer2 + 1 end
  end
end
