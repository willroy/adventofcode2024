local day01REQ = require("days/day01")
local day02REQ = require("days/day02")
local day03REQ = require("days/day03")
local day04REQ = require("days/day04")
local day05REQ = require("days/day05")
local day06REQ = require("days/day06")
local day06REQ = require("days/day06")
local day07REQ = require("days/day07")
local day08REQ = require("days/day08")
local day09REQ = require("days/day09")
local day10REQ = require("days/day10")
local day11REQ = require("days/day11")
local day12REQ = require("days/day12")
local day13REQ = require("days/day13")
local day14REQ = require("days/day14")
local day15REQ = require("days/day15")
local day16REQ = require("days/day16")
local day17REQ = require("days/day17")
local day18REQ = require("days/day18")
local day19REQ = require("days/day19")
local day20REQ = require("days/day20")
local day21REQ = require("days/day21")
local day22REQ = require("days/day22")
local day23REQ = require("days/day23")
local day24REQ = require("days/day24")
local day25REQ = require("days/day25")

local references = {
  ["day1"] = Day01:new(),
  ["day2"] = Day02:new(),
  ["day3"] = Day03:new(),
  ["day4"] = Day04:new(),
  ["day5"] = Day05:new(),
  ["day6"] = Day06:new(),
  ["day7"] = Day07:new(),
  ["day8"] = Day08:new(),
  ["day9"] = Day09:new(),
  ["day10"] = Day10:new(),
  ["day11"] = Day11:new(),
  ["day12"] = Day12:new(),
  ["day13"] = Day13:new(),
  ["day14"] = Day14:new(),
  ["day15"] = Day15:new(),
  ["day16"] = Day16:new(),
  ["day17"] = Day17:new(),
  ["day18"] = Day18:new(),
  ["day19"] = Day19:new(),
  ["day20"] = Day20:new(),
  ["day21"] = Day21:new(),
  ["day22"] = Day22:new(),
  ["day23"] = Day23:new(),
  ["day24"] = Day24:new(),
  ["day25"] = Day25:new()
}

function love.load()
  love.window.setTitle("countdown_app")
  love.window.setMode(800, 800, { vsync = 1, borderless = true, display = 2 })
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
  local font = love.graphics.setNewFont(16)
  love.graphics.setFont(font)
  io.stdout:setvbuf("no")
end

function love.update(dt)
end

function love.draw()
  local mouseX, mouseY = love.mouse.getPosition()

  love.graphics.setColor(0.2, 0.2, 0.2)
  for x = 1, 5 do
    for y = 1, 5 do
      if mouseX > 25 + (x * 110) and mouseX < 125 + (x * 110) and mouseY > (y * 110) and mouseY < 100 + (y * 110) then
        if (references["day" .. tostring((y - 1) * 5 + x)].completed) then
          love.graphics.setColor(0.4, 0.7, 0.4)
        elseif (references["day" .. tostring((y - 1) * 5 + x)].halfcompleted) then
          love.graphics.setColor(0.4, 0.7, 0.4, 0.5)
        else
          love.graphics.setColor(0.3, 0.3, 0.3)
        end
      else
        if (references["day" .. tostring((y - 1) * 5 + x)].completed) then
          love.graphics.setColor(0.4, 0.6, 0.4)
        elseif (references["day" .. tostring((y - 1) * 5 + x)].halfcompleted) then
          love.graphics.setColor(0.4, 0.6, 0.4, 0.5)
        else
          love.graphics.setColor(0.2, 0.2, 0.2)
        end
      end
      love.graphics.rectangle("fill", 25 + (x * 110), (y * 110), 100, 100)
      love.graphics.setColor(0.8, 0.8, 0.8)
      love.graphics.print(tostring((y - 1) * 5 + x), 64 + (x * 110), 40 + (y * 110))
    end
  end

  love.graphics.setColor(0.8, 0.8, 0.8)
  if loaded ~= nil then
    love.graphics.print(tostring("answer 1: " .. loaded.answer1), 200, 40)
    love.graphics.print(tostring("answer 2: " .. loaded.answer2), 400, 40)
  end
  love.graphics.setColor(0, 0, 0)
end

function love.mousepressed(mouseX, mouseY, button, istouch)
  for x = 1, 5 do
    for y = 1, 5 do
      if mouseX > 25 + (x * 110) and mouseX < 125 + (x * 110) and mouseY > (y * 110) and mouseY < 100 + (y * 110) then
        loaded = references["day" .. tostring((y - 1) * 5 + x)]
        loaded:init()
      end
    end
  end
end

function love.mousereleased(x, y, button, istouch)
end

function love.keypressed(key, code)
  if key == "o" then
    local mouseX, mouseY = love.mouse.getPosition()

    for x = 1, 5 do
      for y = 1, 5 do
        if mouseX > 25 + (x * 110) and mouseX < 125 + (x * 110) and mouseY > (y * 110) and mouseY < 100 + (y * 110) then
          local day = (y - 1) * 5 + x
          if day < 10 then
            os.execute("zed days/day0" .. tostring(day) .. ".lua")
            return
          else
            os.execute("zed days/day" .. tostring(day) .. ".lua")
            return
          end
        end
      end
    end

    os.execute("zed main.lua")
  end
  if key == "escape" then
    love.event.push("quit")
  end
end

function love.wheelmoved(x, y)
end

function love.conf(t)
  t.console = true
end
