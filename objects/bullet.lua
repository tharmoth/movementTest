Bullet = GameObject:extend()
function Bullet:new(area, x, y, opts)
    Bullet.super.new(self, area, x, y, opts)
    self.dx = self.dx or 0
    self.dy = self.dy or 0
    self.x = self.x - self.w/2 
    self.y = self.y - self.h/2 
end
function Bullet:update(dt)
    moveCollision2(self, dt)
    Bullet.super.update(self, dt)
end
function moveCollision2(object, dt)
  local goalX, goalY = object.x + object.dx * dt, object.y + object.dy * dt
  local actualX, actualY, cols, len = world:move(object, goalX, goalY, object.filter)
  object.x, object.y = actualX, actualY
  
  --!deal with the collisions
  for i=1,len do
    local kind = cols[i].other.name
    if kind == "wall" then object.dead = true
    elseif kind == "Enemy" then
      cols[i].other.health = cols[i].other.health - 1
      object.dead = true
    end
  end
end
function Bullet:draw()
  love.graphics.setColor( 0, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor( 255, 255, 255)
end
function Bullet:filter(other)
  local kind = other.name
  if     kind == "Player" then return 'cross' end
  if     kind == "Bullet" then return 'cross' end
  return 'slide'
  -- else return nil
end