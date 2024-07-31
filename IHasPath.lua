IHasPath = {}

function IHasPath:new(max_velocity)
  local new = setmetatable({},  {__index = self})
  new.path = {}
  new.max_velocity = max_velocity
  return new
end

function IHasPath:target_coords()
  local target = self.path[1]
  if target.type then
    return target:getPosition()
  else
    return target[1], target[2]
  end
end

function IHasPath:reach_target()
  local x,y = self.body:getPosition()
  if self.path[1] == nil then return true end
  local tx,ty = self:target_coords()
  local dx, dy = tx-x, ty-y
  local D = dx*dx + dy*dy
  if D < 10 then return true end
  for _,fixture in ipairs(self.body:getFixtures()) do
    if fixture:testPoint(tx, ty) then
      return true 
    end
  end
  return false
end

function IHasPath:update_direction(dt)
  if self.path[1] == nil then
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

function IHasPath:update(dt)
  if self:reach_target() then
    table.remove(self.path, 1)
    self:update_direction(dt)
  end
end
