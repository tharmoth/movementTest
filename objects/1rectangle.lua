Rectangle = GameObject:extend()
function Rectangle:new(area, x, y, opts)
    Rectangle.super.new(self, area, x, y, opts)
    self.speedx = speedx or 0
    self.speedy = speedy or 0
end
function Rectangle:update(dt)
    Rectangle.super.update(self, dt)
    self.x = self.x + self.speedx * dt
    self.y = self.y + self.speedy * dt
end
function Rectangle:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end