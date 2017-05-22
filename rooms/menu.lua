Menu = Object:extend()

function Menu:new()
    self.timer = timer
    self.area = Area()
    input:bind("escape", function() love.event.quit() end)
    local center = love.graphics.getWidth( ) / 2
    
    --!Build Board
    self.area:addGameObject('Rectangle',  0,       0,   {name = 'topBoarder',    w = 384, h = 32  })
    self.area:addGameObject('Rectangle',  0,       224, {name = 'bottomBoarder', w = 384, h = 32  })
    self.area:addGameObject('Rectangle',  0,       0,   {name = 'leftBoarder',   w = 32,  h = 256 })
    self.area:addGameObject('Rectangle',  352,     0,   {name = 'rightBoarder',  w = 32,  h = 256 })
    self.area:addGameObject('Text',       192,     64, {name = 'Start',  words = 'Start', center = true })
    self.area:addGameObject('Text',       192,     128, {name = 'Quit',   words = 'Quit',   center = true })
    self.area:addGameObject('MenuScroll', 0,       0,   {name = 'MenuScroll',    locations = {'Start','Quit'}, functions = {function() gotoRoom("Game") end, function()love.event.quit() end}})
end
function Menu:update(dt)
    self.area:update(dt)
end

function Menu:draw()
    self.area:draw()
end