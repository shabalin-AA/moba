function clamp(x, min, max)
  if x > max then return max end
  if x < min then return min end
  return x
end

function distance(x1,y1,x2,y2)
  local dx,dy = x2-x1, y2-y1
  local D = dx*dx + dy*dy
  local d = math.sqrt(D)
  return d
end

require 'hero_red'
require 'hero_blue'
require 'player'
require 'tree'

world = nil
objects = {}
active_player = 1

function body_there(x, y)
  local body = nil
  for _,b in pairs(world:getBodies()) do
    for _,f in pairs(b:getFixtures()) do
      if f:testPoint(x,y) then
        body = b
      end
    end
  end
  return body
end

function spawn(obj)
  for i=1,#objects+1 do
    if objects[i] == nil then 
      objects[i] = obj
      print('spawned '..i)
      break
    end
  end
end

function destroy(obj)
  for k,v in pairs(objects) do
    if v == obj then
      v.body:destroy()
      v.body = nil
      objects[k] = nil
    end
  end
end

SCALE = 3
WORLD_X = 0
WORLD_Y = 0
WORLD_W = 1600
WORLD_H = 900

function world_coords(x, y)
  return (x-WORLD_X)/SCALE, (y-WORLD_Y)/SCALE
end

function love.load()
  love.graphics.setDefaultFilter('nearest')
  love.graphics.setLineStyle('rough')
  world = love.physics.newWorld(0, 0, true)
  love.physics.setMeter(100)
  spawn(Player:new(Hero_Blue))
  spawn(Player:new(Hero_Red))
  spawn(Tree:new(200, 200))
  spawn(Tree:new(300, 200))
  spawn(Tree:new(400, 200))
  spawn(Tree:new(500, 200))
end

function love.update(dt)
  world:update(dt)
  for k,v in pairs(objects) do
    if v.update then v:update(dt) end
  end
end

local floor_sprite = love.graphics.newImage('assets/floor.png')
local floor_w, floor_h = floor_sprite:getPixelDimensions()

function love.draw()
  local w,h = WORLD_W, WORLD_H
  local px, py = objects[active_player].hero.body:getPosition()
  WORLD_X = clamp(w/2 - px*SCALE, -w, 0)
  WORLD_Y = clamp(h/2 - py*SCALE, -h, 0)
  love.graphics.translate(WORLD_X, WORLD_Y)
  love.graphics.scale(SCALE, SCALE)
  for i=0, h, floor_h do
    for j=0, w, floor_w do
      love.graphics.draw(floor_sprite, j, i)
    end
  end
  for k,v in pairs(objects) do
    if v.draw then v:draw() end
  end
end

function love.mousemoved(x, y, dx, dy)
  for k,v in pairs(objects) do
    if v.mousemoved then v:mousemoved(x, y, dx, dy) end
  end
end

function love.mousepressed(x, y, button)
  objects[active_player]:mousepressed(x, y, button)
end

function love.keypressed(key)
  if key == '1' then
    active_player = 1
  elseif key == '2' then
    active_player = 2
  else
    objects[active_player]:keypressed(key)
  end
end