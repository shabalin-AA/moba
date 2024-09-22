require 'has_target'

Projectile = HasTarget:new(30000)

function Projectile:new(x, y, target_type)
  local new = setmetatable({}, {__index = self})
  new.target = nil
  new.target_type = target_type
  local body = love.physics.newBody(world, x, y, 'dynamic')
  local shape = love.physics.newCircleShape(x, y, 3)
  local fixture = love.physics.newFixture(body, shape)
  new.body = body
  new.sprite = love.graphics.newImage('assets/fire.png')
  return new
end

function Projectile:update(dt)
  self:update_HasTarget(dt)
  if self.body and self.target == nil then
    destroy(self)
    return
  end
  self.body:setAngularVelocity(0)
end

function Projectile:draw()
  if self.target == nil then return end
  local x,y = self.body:getPosition()
  local r = self.body:getFixtures()[1]:getShape():getRadius()
  love.graphics.setColor(1,0,0)
  --love.graphics.circle('line', x, y, r)
  local tx, ty = self:target_coords()
  if self.target then 
    love.graphics.circle('line', tx, ty, r)
  end
  local w,h = self.sprite:getPixelDimensions()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(self.sprite, x-w/2, y-h/2)
end