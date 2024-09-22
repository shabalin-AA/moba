Player = {}

function Player:new(hero)
  local new = setmetatable({}, {__index = self})
  new.hero = hero:new(100, 100)
  new.body = new.hero.body
  return new
end

function Player:update(dt)
  self.hero:update(dt)
end

function Player:draw() 
   self.hero:draw()
end

function Player:mousepressed(mx, my, button)
  if button == 1 then
    mx,my = world_coords(mx,my)
    self.hero:attack(mx,my)
  elseif button == 2 then
    mx,my = world_coords(mx, my)
    self.hero:set_target(mx,my)
    self.hero:update_direction(dt)
  end
end

function Player:keypressed(key)
  local mx,my = love.mouse.getPosition()
  mx,my = world_coords(mx,my)
  local ability = self.hero.abilities[key]
  if ability then
    ability(self, mx, my)
  end
end