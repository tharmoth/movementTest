Enemy = GameObject:extend()
function Enemy:new(area, x, y, opts)
    Enemy.super.new(self, area, x, y, opts)
    self.dx = self.dx or 0
    self.dy = self.dy or 0
    self.cx, self.cy = self:getCenter()
    self.speed = 100
    self.dx = 100
    self.dy = 100
    self.color = {16,128,0}
    self.health = 3
    --! green = 16,128
    --! orenge = 255 128
     --! red = 255 0
end
function Enemy:update(dt)
    local collisionObject = self.area:getIndex("Player")
    
    
    local goalX = self.area.game_objects[collisionObject].x + self.area.game_objects[collisionObject].w / 4
    local goalY = self.area.game_objects[collisionObject].y + self.area.game_objects[collisionObject].h / 4
    self.angle = math.atan2(goalY - self.y, goalX - self.x)
    self.cos = math.cos(self.angle)
    self.sin = math.sin(self.angle)
    self.ndx, self.ndy = self.dx * self.cos, self.dy * self.sin
    
    moveCollision3(self, dt)
    self:checkHealth()
    --!Enemy.super.update(self, dt)
end
function Enemy:checkHealth()
  if self.health == 3 then
    self.color = {16,128,0}
  elseif self.health == 2 then
    self.color = {255,128,0}
  elseif self.health == 1 then
    self.color = {255,0,0}
  elseif self.health == 0 then
    self.dead = true
  end
end
function moveCollision3(object, dt)
  local goalX = object.x + object.ndx * dt
  local goalY = object.y + object.ndy * dt
  local actualX, actualY, cols, len = world:move(object, goalX, goalY, object.filter)
  object.x, object.y = actualX, actualY
  --!deal with the collisions
  for i=1,len do
    local kind = cols[i].other.name
    --!if kind == "Bullet" then object.health = object.health - 1 end
  end
end
function Enemy:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x,self.y, self.w, self.h)
    love.graphics.setColor( 255, 255, 255)
end
function Enemy:filter(other)
  local kind = 0
  if type(other) == "table" then
    kind = other.name
  else
    kind = other
  end
  
  --!if     kind == "Player" then return 'cross' end
  --!if kind == "Bullet" then return 'cross' end
  return 'slide'
  -- else return nil
end