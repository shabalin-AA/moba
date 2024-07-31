IHasTarget = {}

function IHasTarget:new(max_velocity, target_type)
  local new = setmetatable({},  {__index = self})
  new.target = nil
  new.target_type = target_type
  new.max_velocity = max_velocity
  return new
end

function IHasTarget:set_target(x,y)
  if self.target_type == 'point' then 
    self.target = {x,y}
    return
  end
  if self.target_type == 'body' then 
    self.target = body_there(x,y)
    if self.target == self.body then self.target = nil end
    return
  end
  self.target = body_there(x,y) or {x,y}
  if self.target == self.body then self.target = nil end
end

function IHasTarget:target_coords()
  if self.target.type then
    return self.target:getPosition()
  else
    return self.target[1], self.target[2]
  end
end

function IHasTarget:reach_target(dt)
  if self.target == nil then return true end
  local x,y = self.body:getPosition()
  local tx,ty = self:target_coords()
  local dx, dy = tx-x, ty-y
  local D = dx*dx + dy*dy
  if D < 10 then return true end
  local vx,vy = self.body:getLinearVelocity()
  if dx*vx < 0 or dy*vy < 0 then
    self:update_direction(dt)
  end
  for _,fixture in ipairs(self.body:getFixtures()) do
    if fixture:testPoint(tx, ty) then
      return true 
    end
  end
  return false
end

function IHasTarget:update_direction(dt)
  if self.target == nil then
    self.direction = {0,0}
  else
    local x,y = self.body:getPosition()
    local tx,ty = self:target_coords()
    local dx, dy = tx-x, ty-y
    local D = math.sqrt(dx*dx + dy*dy)
    self.direction = {dx/D, dy/D}
  end
  self.body:setLinearVelocity(
    self.direction[1] * self.max_velocity * dt,
    self.direction[2] * self.max_velocity * dt
  )
end

function IHasTarget:update_IHasTarget(dt)
  if self:reach_target(dt) then
    self.target = nil
  end
  self:update_direction(dt)
end