require 'Hero'

Hero_Blue = Hero:new()

function Hero_Blue:new(world, x, y)
  local new = setmetatable({}, {__index = self})
  new:set_physics(world, x, y)
  new.sprite = love.graphics.newImage('assets/blue.png')
  new.color = {0.2,0.2,1}
  return new
end