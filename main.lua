--[[
    Created by: Michael Blanchard 2018
]]



function love.load()

   

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keyReleased = {}

    paused = false
    fullscreen = true
    love.window.setTitle('Physics Playscape')
    love.window.setFullscreen(true, "desktop")
    world = love.physics.newWorld(1,1,true)
    floorBody = love.physics.newBody(world, 0, 0, 'static')
    floorShape = love.physics.newPolygonShape(0,1390,0,1440,2560,1440,2560,1390)
    floorFixture = love.physics.newFixture(floorBody, floorShape, 1)
end

function love.update(dt)
    if not paused then
        love.mouse.keysPressed = {}  --clear keys pressed each update
        love.mouse.keysPressed ={}
        love.mouse.keysReleased = {}
    end
end

function love.keypressed(key)
    if key == 'p' then               --PAUSE
        paused = not paused
    end

    if key == 'escape' then             
        love.event.quit()
    end
    
    love.keyboard.keysPressed[key] = true
end


function love.mousepressed(x, y, key)
    love.mouse.keysPressed[key] = true    
end

function love.mousereleased(x, y, key)
    love.mouse.keysReleased[key] = true 
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.mouse.wasReleased(key)
    return love.mouse.keysReleased[key]
end

function love.draw()

    love.graphics.rectangle('line',0,0,50,50)
    x, y = floorBody:getPosition()
    love.graphics.rectangle('line',x,y, 2560,50)
    love.graphics.rectangle('line',2510,1390,50,50)
end