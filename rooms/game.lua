Game = GameObject:extend()

function Game:new()
    self.timer = timer
    self.area = Area()
    input:bind("escape", function() gotoRoom("Menu") end)
    input:bind("space", function() self.area:addGameObject('Enemy',  love.math.random(128,1000),love.math.random(128,1000),   {name = 'Enemy',    w = 64, h = 64, isCollidable = true  }) end)
    self.area:addGameObject('Player',  1000,       500,   {name = 'Player',    w = 128, h = 128, isCollidable = true})
    --!self.area:addGameObject('Rectangle',  50,       50,   {name = 'topWall2',    w = nativeWidth, h = block, isCollidable = true  })
    self.area:addGameObject('Enemy',  300,       300,   {name = 'Enemy',    w = 64, h = 64, isCollidable = true  })
    
    
    --! add boundry box topwall bottomwall leftwall rightwall
    self.area:addGameObject("GameObject", 0,                 0,                  {name = 'wall',       w = nativeWidth, h = block, isCollidable = true})
    self.area:addGameObject("GameObject", 0,                 nativeHeight-block, {name = 'wall', w = nativeWidth, h = block, isCollidable = true})
    self.area:addGameObject("GameObject", 0,                 0,                  {name = 'wall',   w = block,       h = nativeHeight, isCollidable = true})
    self.area:addGameObject("GameObject", nativeWidth-block, 0,                  {name = 'wall',  w = block,       h = nativeHeight, isCollidable = true})

    loadMap()
end

function Game:update(dt)
    self.area:update(dt)

end

function Game:draw()
  for columnIndex,column in ipairs(TileTable) do
    for rowIndex,char in ipairs(column) do
      local x,y = (columnIndex-1)*TileW, (rowIndex-1)*TileH
      love.graphics.draw(Tileset, Quads[char], x, y)
    end
  end
    self.area:draw()
end

function loadMap()
  TileW, TileH = 64,64
  
  Tileset = love.graphics.newImage('imgAssets/test2.png')
  
  local quadInfo = { 
    { ' ',  1 * block/2, 2 * block/2 }, -- grass 
    { '@',  1 * block/2, 0 * block/2 }, -- box
    { '#',  1 * block/2, 1 * block/2 }, -- box
    { '^',  0 * block/2, 2 * block/2 }, -- boxTop
    { '!',  2 * block/2, 2 * block/2 }, -- boxTop
    { '*',  2 * block/2, 3 * block/2 },  -- flowers
    { 'A',  0 * block/2, 0 * block/2 },  -- flowers
    { 'a',  0 * block/2, 1 * block/2 },  -- flowers
    { 'B',  2 * block/2, 0 * block/2 },  -- flowers
    { 'b',  2 * block/2, 1 * block/2 },  -- flowers
    { 'C',  0 * block/2, 3 * block/2 },  -- flowers
    { 'D',  2 * block/2, 3 * block/2 },  -- flowers
    { '%',  1 * block/2, 3 * block/2 },  -- flowers
    { '$',  0 * block/2, 4 * block/2 },  -- flowers
  }
  
    local tileString = [[
$A@@@@@@@@@@@@@@@@@@@@B$
$a####################b$
$^                    !$
$^                    !$
$^                    !$
$^                    !$
$^                    !$
$^                    !$
$^                    !$
$^                    !$
$^                    !$
$^                    !$
$^                    !$
$^                    !$
$C%%%%%%%%%%%%%%%%%%%%D$
$$$$$$$$$$$$$$$$$$$$$$$$
]]

----------------------------------------------------------------------------------------
--                                      Separator                                     --
----------------------------------------------------------------------------------------
  local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()
  
  Quads = {}
  for _,info in ipairs(quadInfo) do
    -- info[1] = character, info[2] = x, info[3] = y
    Quads[info[1]] = love.graphics.newQuad(info[2], info[3], TileW, TileH, tilesetW, tilesetH)
  end

  TileTable = {}
  
  local width = #(tileString:match("[^\n]+"))
  
  for x = 1,width,1 do TileTable[x] = {} end

  local x,y = 1,1
  for row in tileString:gmatch("[^\n]+") do
    x = 1
    for character in row:gmatch(".") do
      TileTable[x][y] = character
      x = x + 1
    end
    y=y+1
  end
end