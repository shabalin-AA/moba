Tree = {}

TREE_HITBOX_RADIUS = 10

function Tree:new(x, y)
  local new = setmetatable({}, {__index = self})
  local body = love.physics.newBody(world, x, y, 'static')
  local shape = love.physics.newCircleShape(TREE_HITBOX_RADIUS)
  local fixture = love.physics.newFixture(body, shape)
  new.body = body
  new.sprite = love.graphics.newImage('assets/pine.png')
  return new
end

function Tree:draw()
  local x,y = self.body:getPosition()
  local r = self.body:getFixtures()[1]:getShape():getRadius()
  love.graphics.setColor(93/255, 47/255, 5/255)
  love.graphics.circle('fill', x, y, r)
  local w,h = self.sprite:getPixelDimensions()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(self.sprite, x-w/2, y-h+r/2)
end

function Tree:mousemoved(x, y, dx, dy)
  if not love.mouse.isDown(1) then return end
  x,y = world_coords(x,y)
  if not self.body:getFixtures()[1]:testPoint(x, y) then return end
  self.body:setPosition(x, y)
end
