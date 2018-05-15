--[[
    Created by: Michael Blanchard 2018
    xyz
]]



function love.load()
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}

    balls = {}
    fixtures = {}
    shapes = {}
    count = 0
    paused = false
    fullscreen = true
    love.window.setTitle('Physics Playscape')
    love.window.setFullscreen(true, "desktop")

    world = love.physics.newWorld(0,500,true)  --world contains all relevant bodies/fixtures in physics simulation
    
    floorBody = love.physics.newBody(world, 0, 1440, 'static')          --this will be our floor bound
    floorShape = love.physics.newEdgeShape(0,0,2560,0)
    floorFixture = love.physics.newFixture(floorBody, floorShape)

    leftWallBody = love.physics.newBody(world,0,0,'static')
    rightWallBody = love.physics.newBody(world,2560,0,'static')
    wallShape = love.physics.newEdgeShape(0,0,0,1440)
    leftWallFixture = love.physics.newFixture(leftWallBody, wallShape)
    rightWallFixture = love.physics.newFixture(rightWallBody, wallShape)
end

function love.update(dt)
    world:update(dt)

    if love.mouse.wasPressed(1) then
        count = count + 1
        ballBodyNew = love.physics.newBody(world, love.mouse.getX(), love.mouse.getY(),'dynamic')      
        ballShapeNew = love.physics.newCircleShape(50)
        ballFixtureNew =love.physics.newFixture(ballBodyNew,ballShapeNew)
        ballFixtureNew:setRestitution(0.9)
        table.insert(balls, ballFixtureNew)
    end

    love.keyboard.keysPressed = {}  
    love.mouse.keysPressed ={}
    love.mouse.keysReleased = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
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

    for k, fixture in pairs(balls) do 
        x, y = fixture:getBody():getPosition()
        love.graphics.circle('line', x, y, 50)
    end
    
    text = love.graphics.newText(love.graphics.getFont(),tostring(count))
    love.graphics.draw(text, 50, 50)
end