require 'Hero'

Hero_Red = Hero:new()

function Hero_Red:new(world, x, y)
  local new = setmetatable({}, {__index = self})
  new:set_physics(world, x, y)
  new.sprite = love.graphics.newImage('assets/red.png')
  new.color = {1,0.2,0.2}
  new.attack_range = 100
  return new
end