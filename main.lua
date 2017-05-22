--! main.lua
--! This is my test function to test things
Object = require "libraries/classic/classic"
Input = require "libraries/BYTEPATH/Input"
Timer = require "libraries/BYTEPATH/enhancedTimer"
Bump = require 'libraries/kikito/bump'
local Gamera = require 'libraries/kikito/gamera'
require "utils/utils"

function love.load()
   --! loads all the files in given folders
   love.graphics.setDefaultFilter( 'nearest', 'nearest' )
   loadfolder("objects")
   loadfolder("rooms")
   current_room = nil
   input = Input()
   timer = Timer()
   
   --!love.window.setMode(384, 256, {fullscreen = false})
   love.window.setMode(1600, 900, {fullscreen = false})
   screenHeight = love.graphics.getHeight()
   screenWidth  = love.graphics.getWidth()
   nativeWidth = 1536
   nativeHeight = 1024
   block = 128
   --!main_canvas = love.graphics.newCanvas(1600, 900)
   --!main_canvas:setFilter('nearest', 'nearest')
   pewpew = love.audio.newSource("audioAssets/pew.wav", "static")
   Tileset = love.graphics.newImage('imgAssets/dungeon_sheet.png')
   newFont = love.graphics.newFont("imgAssets/newFont.ttf",20)
   
   
   cam = Gamera.new(0, 0, nativeWidth,nativeHeight)
   local scaly = (screenWidth-nativeWidth*(screenHeight/nativeHeight))/2
   cam:setWindow(scaly,0,1350,900)
   cam:setScale(.5)
   print(cam:getScale())
   --[[
   input:bind("1", function() gotoRoom("Circle",400,300,100) end)
   input:bind("2", function() gotoRoom("Polygon",400,300,100) end)
   input:bind("3", function() gotoRoom("Rectangle",400,300,100,100) end)
   ]]--
   
   current_room = Game()
end
function love.update(dt)
    if current_room then current_room:update(dt) end
    timer:update(dt)
end
function love.draw()
  cam:draw(function(l,t,w,h)
      --[[
        love.graphics.setCanvas(main_canvas)
  love.graphics.clear() 
  love.graphics.setCanvas()
  love.graphics.draw(main_canvas, (screenWidth-nativeWidth*(screenHeight/nativeHeight))/2, 0, 0, screenHeight/nativeHeight, screenHeight/nativeHeight)
  ]]--
    if current_room then current_room:draw() end
    end)
end
function gotoRoom(room_type, ...)
    current_room = _G[room_type](...)
end
