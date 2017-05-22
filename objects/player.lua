Player = GameObject:extend()
function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    --! Initalize movement veriables for math porpaces
    self.dy, self.dx = 0, 0
    self.ddx, self.ddy = 0, 0
    
    --! Initalize move with acceleration veriables
    self.acclx, self.accly = 1000, 1000
    self.dcelx, self.dcely = 5000, 5000
    self.dxMax, self.dyMax = 700,  700
    
    --! Initalize movement keys and bind them to fuctions
    self.upKey, self.downKey, self.leftKey, self.rightKey = 'w','s','a','d'
    input:bind(self.upKey, self.upKey)
    input:bind(self.downKey, self.downKey)
    input:bind(self.leftKey, self.leftKey)
    input:bind(self.rightKey, self.rightKey)
    
    -- Initalize shoot keys and bind them to fuctions
    self.upKeyShoot, self.downKeyShoot, self.leftKeyShoot, self.rightKeyShoot = 'up','down','left','right'
    input:bind(self.upKeyShoot, self.upKeyShoot)
    input:bind(self.downKeyShoot, self.downKeyShoot)
    input:bind(self.leftKeyShoot, self.leftKeyShoot)
    input:bind(self.rightKeyShoot, self.rightKeyShoot)

    --! initalize shooting logic veriables
    self.shootButtonsPressed = {"none"}
    self.pressedTime = 0
end
function Player:update(dt)
    self:playerInput(dt)
    self:normalizeMovement(dt)
    self:moveCollision(self,dt)
    cam:setPosition(self.x, self.y)
    Player.super.update(self, dt)
end
function Player:draw()
    love.graphics.setColor( 200, 200, 200)
    love.graphics.rectangle("fill", self.x,self.y, self.w, self.h)
    love.graphics.setColor( 255, 255, 255)
end
function Player:playerInput(dt)
  playerMoveWithAccl(self,dt)
  self:shoot()
end
function playerMoveWithAccl(self,dt)
  -- Move up and down with acceleration
  if input:down(self.downKey) and not input:down(self.upKey) then 
    --! if moving left in y
    if self.dy < 0 then
      --! set y accel in the direction opposite moving
      self.ddy = self.dcely * -1
    --!elseif(math.abs(self.dy) < math.abs(self.dx)) then
    --!self.dy = math.abs(self.dx)
    --! self.area:addGameObject('Rectangle',  self.x,       self.y,   {name = 'ack',    w = 10, h = 10})
    elseif(self.dy < self.dyMax) then
      --! if not moving at max speed accelerate
      self.ddy =  self.accly
    else
      --! else stop accelerating
      self.ddy = 0
    end
    
  elseif input:down(self.upKey) and not input:down(self.downKey) then 
    if self.dy > 0 then
      self.ddy = self.dcely * -self.dy/math.abs(self.dy)
    elseif(self.dy > -self.dyMax) then
      self.ddy = -self.accly
      
    else
      self.ddy = 0
    end
  else
    self.ddy = self.dcely * -self.dy/math.abs(self.dy) 
    if math.abs(self.dy) < 50 then
      self.ddy = 0 self.dy = 0
    end
  end

  -- Move left and right with acceleration
  if input:down(self.rightKey) and not input:down(self.leftKey) then 
    if self.dx < 0 then
      self.ddx = self.dcelx * -self.dx/math.abs(self.dx)
    elseif(self.dx < self.dxMax) then
      self.ddx =  self.acclx
    else
      self.ddx = 0
    end
  elseif input:down(self.leftKey) and not input:down(self.rightKey) then 
    if self.dx > 0 then
      self.ddx = self.dcelx * -self.dx/math.abs(self.dx)
    elseif(self.dx > -self.dxMax) then
      self.ddx = -self.acclx
    else
      self.ddx = 0
    end
  else
    self.ddx = self.dcelx * -self.dx/math.abs(self.dx) 
    if math.abs(self.dx) < 50 then
      self.ddx = 0 self.dx = 0
    end
  end
  -- Move update velocity based on accleration
  self.dx, self.dy = self.dx + self.ddx * dt, self.dy + self.ddy * dt
end
--! so i hear you like sphagetti a la fo
function Player:shoot()
  local x,y = self:getCenter()
  if input:pressed(self.upKeyShoot)     then table.insert(self.shootButtonsPressed,self.upKeyShoot) end
  if input:pressed(self.downKeyShoot)   then table.insert(self.shootButtonsPressed,self.downKeyShoot)  end
  if input:pressed(self.leftKeyShoot)   then table.insert(self.shootButtonsPressed,self.leftKeyShoot)  end
  if input:pressed(self.rightKeyShoot)  then table.insert(self.shootButtonsPressed,self.rightKeyShoot)  end
  if input:released(self.upKeyShoot)    then removeByName(self.shootButtonsPressed,self.upKeyShoot) end
  if input:released(self.downKeyShoot)  then removeByName(self.shootButtonsPressed,self.downKeyShoot) end
  if input:released(self.leftKeyShoot)  then removeByName(self.shootButtonsPressed,self.leftKeyShoot) end
  if input:released(self.rightKeyShoot) then removeByName(self.shootButtonsPressed,self.rightKeyShoot) end
  local lastButton = self.shootButtonsPressed[#self.shootButtonsPressed]
  local currentTime = love.timer.getTime()
  if self.pressedTime + .3 < currentTime then
    
    if lastButton == self.upKeyShoot then
      self.area:addGameObject('Bullet', x, y, {name = 'Bullet', w = 10, h = 20, dy = -500, isCollidable = true})
      self.pressedTime = love.timer.getTime()
      pewpew:play()
    elseif lastButton == self.downKeyShoot then
      self.area:addGameObject('Bullet', x, y, {name = 'Bullet', w = 10, h = 20, dy = 500, isCollidable = true})
      self.pressedTime = love.timer.getTime()
      pewpew:play()
    elseif lastButton == self.rightKeyShoot then
      self.area:addGameObject('Bullet', x, y, {name = 'Bullet', w = 20, h = 10, dx = 500, isCollidable = true})
      self.pressedTime = love.timer.getTime()
      pewpew:play()
    elseif lastButton == self.leftKeyShoot then
      self.area:addGameObject('Bullet', x, y, {name = 'Bullet', w = 20, h = 10, dx = -500, isCollidable = true})
      self.pressedTime = love.timer.getTime()
      pewpew:play()
    end
  end
end
function Player:normalizeMovement(dt)
  if self.dx ~= 0 and self.dy ~= 0 then
  local goalX = self.x + self.dx * dt
  local goalY = self.y + self.dy * dt
  self.angle = math.atan2(goalY - self.y, goalX - self.x)
  self.cos = math.cos(self.angle)
  self.sin = math.sin(self.angle)
  self.ndx, self.ndy = self.dx * math.abs(self.cos), self.dy * math.abs(self.sin)
  else
    self.ndx, self.ndy = self.dx , self.dy
  end
end
function Player:moveCollision(object, dt)
  local goalX, goalY = self.x + self.ndx * dt, self.y + self.ndy * dt
  local actualX, actualY, cols, len = world:move(self, goalX, goalY, self.filter)
  self.x, self.y = actualX, actualY
  for i=1,len do
    --!print('collided with ' .. tostring(cols[i].other))
  end
end
function Player:filter(other)
  local kind = 0
  if type(other) == "table" then
    kind = other.name
  else
    kind = other
  end
  if     kind == "Bullet" then return 'cross' end
  return 'slide'
end
function removeByName(remTable, name)
  for i, item in ipairs(remTable) do
    if remTable[i] == name then
      table.remove(remTable,i)
    end
  end
end