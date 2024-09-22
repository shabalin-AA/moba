require 'projectile'
require 'has_target'

Hero = HasTarget:new(10000, 'any')

function Hero:new()
  local new = setmetatable({}, {__index = self})
  new.body = nil
  new.sprite = nil
  new.color = {1,1,1}
  new.attack_range = 0
  return new
end

function Hero:update(dt)
  self:update_HasTarget(dt)
  if self.attack_projectile and self.target == nil then
    self:release_attack()
  end
  self.body:setAngularVelocity(0)
end

function Hero:draw()
  love.graphics.setColor(self.color)
  local x,y = self.body:getPosition()
  local r = self.r
  love.graphics.circle('line', x, y, r)
  if self.target then
    local tx,ty = self:target_coords()
    love.graphics.line(x, y, tx, ty)
  end
  local w,h = self.sprite:getPixelDimensions()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(self.sprite, x-w/2, y-h+r)
end

Hero.attack_projectile = nil

function Hero:attack(tx,ty)
  local x,y = self.body:getPosition()
  self.attack_projectile = Projectile:new(x, y, 'body')
  self.attack_projectile:set_target(tx,ty)
  local d = distance(x,y,tx,ty)
  if d <= self.attack_range then 
    self:release_attack()
  else
    local px = (tx-x)/d * (d-self.attack_range+self.r*2) + x
    local py = (ty-y)/d * (d-self.attack_range+self.r*2) + y
    self:set_target(px,py)
    self.attack_projectile.body:setPosition(px,py)
  end
end

Hero.attack_cooldown = 0.05
Hero.last_attack_t = os.clock()

function Hero:release_attack()
  local t = os.clock()
  if t - self.last_attack_t < self.attack_cooldown then return end
  spawn(self.attack_projectile)
  self.attack_projectile = nil
  self.last_attack_t = os.clock()
end

function Hero:set_physics(x, y)
  local body = love.physics.newBody(world, x, y, 'dynamic')
  self.r = 7
  local shape = love.physics.newCircleShape(self.r)
  local fixture = love.physics.newFixture(body, shape)
  self.body = body
end
