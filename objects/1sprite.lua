Sprite = GameObject:extend()
function Sprite:new(area, x, y, opts)
    Sprite.super.new(self, area, x, y, opts)
    --!self.speedx = speedx or 0
    --!self.speedy = speedy or 0
end
function Sprite:update(dt)
    Sprite.super.update(self, dt)
    --!self.x = self.x + self.speedx * dt
    --!self.y = self.y + self.speedy * dt
end
function Sprite:draw()
   love.graphics.draw(Tileset, self.tile, self.x, self.y)
end