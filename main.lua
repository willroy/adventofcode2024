local day1REQ = require("src/day1")
local day2REQ = require("src/day2")

local loaded = Day2:new()

function love.load()
  love.window.setTitle("countdown_app")
  love.window.setMode(800, 800, {vsync=1, borderless=true})
  love.graphics.setBackgroundColor(0,0,0)
  local font = love.graphics.setNewFont(16)
  love.graphics.setFont(font)
  io.stdout:setvbuf("no")

  loaded:init()
end

function love.update(dt)
end

function love.draw()
  loaded:draw()
end

function love.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
end

function love.keypressed(key, code)
  if key == "escape" then
    love.event.push("quit")
  end
end

function love.wheelmoved(x, y)
  loaded:wheelmoved(x, y)
end

function love.conf(t)
  t.console = true
end