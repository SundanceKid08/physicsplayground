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
    world = love.physics.newWorld(10,10,true)
   
    floorBody = love.physics.newBody(world, 0, 1390, 'static')
    floorShape = love.physics.newRectangleShape(2560,1440)
    floorFixture = love.physics.newFixture(floorBody, floorShape, 1)
    ballBody = love.physics.newBody(world, 2560/2, 1440/2,'dynamic')
    ballShape = love.physics.newCircleShape(100)
    ballFixture =love.physics.newFixture(ballBody,ballShape,1)
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

    
    x, y = floorBody:getPosition()
    xb, yb = ballBody:getPosition()
    love.graphics.rectangle('line', x, y, 2560,50)
    love.graphics.circle('line',xb,yb,100)
end