Player = GameObject:extend()


function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.score, self.dy, self.dx = 0, 0, 0
    self.ddx, self.ddy = 0,0
    self.upKey, self.downKey, self.leftKey, self.rightKey = 'w','s','a','d'
    input:bind(self.upKey, self.upKey)
    input:bind(self.downKey, self.downKey)
    input:bind(self.leftKey, self.leftKey)
    input:bind(self.rightKey, self.rightKey)

end
function Player:update(dt)
  
    
    self:playerInput(dt)
    local goalX = self.area.game_objects[collisionObject].x + self.area.game_objects[collisionObject].w / 4
    local goalY = self.area.game_objects[collisionObject].y + self.area.game_objects[collisionObject].h / 4
    self.angle = math.atan2(goalY - self.y, goalX - self.x)
    self.cos = math.cos(self.angle)
    self.sin = math.sin(self.angle)
    self.ndx, self.ndy = self.dx * self.cos, self.dx * self.sin
    
    
    Player.super.update(self, dt)
end
function Player:playerInput(dt)
    if input:pressed(self.upKey) then self.dy = self.dy - 1000 end
    if input:released(self.upKey) then self.dy = self.dy + 1000 end
    if input:pressed(self.downKey) then self.dy = self.dy + 1000 end
    if input:released(self.downKey) then self.dy = self.dy - 1000 end
    if input:pressed(self.leftKey) then self.dx = self.dx - 1000 end
    if input:released(self.leftKey) then self.dx = self.dx + 1000 end
    if input:pressed(self.rightKey) then self.dx = self.dx + 1000 end
    if input:released(self.rightKey) then self.dx = self.dx - 1000 end
    self.dx = self.dx * math.cos(math.atan2(self.dy,self.dx))
    self.dy = self.dy * math.sin(math.atan2(self.dy,self.dx))
    
end
function Player:draw()
    Player.super.draw(self)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
function movePlayer(player, dt)
  
  player.dx = player.dx + dt * player.ddx
  self.x = self.x * math.cos(math.atan2(self.dy,self.dx))
  self.y = self.y * math.sin(math.atan2(self.dy,self.dx))
  local goalX, goalY = player.x + player.dx * dt, player.y + player.dy * dt
  --!local actualX, actualY, cols, len = world:move(player, goalX, goalY,playerFilter)
  player.x = goalX
  player.y = goalY
  --!player.x, player.y = actualX, actualY
  -- deal with the collisions
  --!for i=1,len do
    --!print('collided with ' .. tostring(cols[i].other))
  --!end
end

local playerFilter = function(other)
  local kind = other.name
  if     kind == "topWall"   then return 'cross'
  elseif other.isWall   then return 'slide'
  elseif other.isExit   then return 'touch'
  elseif other.isSpring then return 'bounce'
  end
  -- else return nil
end