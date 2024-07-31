require 'hero_red'
require 'hero_blue'

Player = {}

function Player:new(world)
  local new = setmetatable({}, {__index = self})
  new.hero = Hero_Red:new(world, 100, 100)
  return new
end

function Player:update(dt)
  if love.mouse.isDown(2) then
    local mx,my = love.mouse.getPosition()
    mx,my = world_coords(mx, my)
    self.hero:set_target(mx,my)
    self.hero:update_direction(dt)
  end
  self.hero:update(dt)
end

function Player:draw()
  self.hero:draw()
end

function Player:mousepressed(mx, my, button)
  if button == 1 then
    mx,my = world_coords(mx,my)
    self.hero:attack(mx,my)
  end
end