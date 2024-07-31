function clamp(x, min, max)
  if x > max then return max end
  if x < min then return min end
  return x
end

require 'player'
require 'tree'

local world

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

players = {}
walls = {}
projectiles = {}

function destroy_object(t)
  local destroy = function(tab, k, v)
    if v == t then 
      v.body:destroy()
      tab[k] = nil
      return
    end
  end
  for k,v in pairs(projectiles) do
    destroy(projectiles, k, v)
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
  table.insert(players, Player:new(world, 10, 10))
  table.insert(walls, Tree:new(world, 200, 200))
  table.insert(walls, Tree:new(world, 300, 200))
  table.insert(walls, Tree:new(world, 400, 200))
  table.insert(walls, Tree:new(world, 500, 200))
end

function love.update(dt)
  world:update(dt)
  for k,v in pairs(players) do
    if v.update then v:update(dt) end
  end
  for k,v in pairs(walls) do
    if v.update then v:update(dt) end
  end
  for k,v in pairs(projectiles) do
    if v.update then v:update(dt) end
  end
end

local floor_sprite = love.graphics.newImage('assets/floor.png')
local floor_w, floor_h = floor_sprite:getPixelDimensions()
function love.draw()
  local w,h = WORLD_W, WORLD_H
  local px, py = players[1].hero.body:getPosition()
  WORLD_X = clamp(w/2 - px*SCALE, -w, 0)
  WORLD_Y = clamp(h/2 - py*SCALE, -h, 0)
  love.graphics.translate(WORLD_X, WORLD_Y)
  love.graphics.scale(SCALE, SCALE)
  for i=0, h, floor_h do
    for j=0, w, floor_w do
      love.graphics.draw(floor_sprite, j, i)
    end
  end
  for k,v in pairs(players) do
    if v.draw then v:draw() end
  end
  for k,v in pairs(walls) do
    if v.draw then v:draw() end
  end
  for k,v in pairs(projectiles) do
    if v.draw then v:draw() end
  end
end

function love.mousemoved(x, y, dx, dy)
  for k,v in pairs(walls) do
    if v.mousemoved then v:mousemoved(x, y, dx, dy) end
  end
end

function love.mousepressed(x, y, button)
  for k,v in pairs(players) do
    v:mousepressed(x, y, button)
  end
end
