Text = GameObject:extend()
function Text:new(area, x, y, opts)
    Text.super.new(self, area, x, y, opts)
    self.h = newFont:getHeight(self.words)
    self.w = newFont:getWidth(self.words)
    if self.center then self.x = self.x-self.h/2 end
end
function Text:update(dt)
    Text.super.update(self, dt)
end
function Text:draw()
    love.graphics.print( self.words, self.x, self.y)
end