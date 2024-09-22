function crystal_nova(owner, tx, ty)
  local r = 50
  for i,obj in pairs(objects) do
    if obj.hero == nil then break end
    local bx,by = obj.body:getPosition()
    local dx,dy = bx-tx, by-ty
    if dx*dx + dy*dy < r*r then
      obj.hero.max_velocity = obj.hero.max_velocity * 0.5
      print(obj)
    end
  end
  local proj = Projectile:new(tx, ty, 'point')
  proj:set_target(tx+3,ty+3)
  proj.max_velocity = 100
  proj.sprite = love.graphics.newImage('assets/particles/plasma_burst.png')
  spawn(proj)
end

require 'Hero'

Hero_Blue = Hero:new()

function Hero_Blue:new(x, y)
  local new = setmetatable({}, {__index = self})
  new:set_physics(x, y)
  new.sprite = love.graphics.newImage('assets/blue.png')
  new.color = {0.2,0.2,1}
  new.attack_range = 200
  new.abilities = {
    q = crystal_nova
  }
  return new
end