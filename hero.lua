require 'projectile'
require 'has_target'

Hero = IHasTarget:new(10000, 'any')

function Hero:new()
  local new = setmetatable({}, {__index = self})
  new.body = nil
  new.sprite = nil
  new.color = {1,1,1}
  return new
end

function Hero:update(dt)
  self:update_IHasTarget(dt)
  self.body:setAngularVelocity(0)
end

function Hero:draw()
  love.graphics.setColor(self.color)
  local x,y = self.body:getPosition()
  local r = self.body:getFixtures()[1]:getShape():getRadius()
  love.graphics.circle('line', x, y, r)
  if self.target then
    local tx,ty = self:target_coords()
    love.graphics.line(x, y, tx, ty)
  end
  local w,h = self.sprite:getPixelDimensions()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(self.sprite, x-w/2, y-h+r/2)
end

function Hero:attack(tx,ty)
  local x,y = self.body:getPosition()
  local p = Projectile:new(self.body:getWorld(), x, y, 'body')
  p:set_target(tx,ty)
  for i=1,#projectiles+1 do
    if projectiles[i] == nil then 
      projectiles[i] = p 
      break
    end
  end
end

function Hero:set_physics(world, x, y)
  local body = love.physics.newBody(world, x, y, 'dynamic')
  local shape = love.physics.newCircleShape(10)
  local fixture = love.physics.newFixture(body, shape)
  self.body = body
end