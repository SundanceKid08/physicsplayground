--[[
    Created by: Michael Blanchard 2018
    xyz
]]
Class = require 'src/class'
require 'src/Ball'


function love.load()
    math.randomseed(os.time())
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}

    GLOBAL_RESTITUTION = 0.9

    balls = {}
    fixtures = {}
    shapes = {}
    count = 0
    paused = false
    fullscreen = true
    love.window.setTitle('Physics Playscape')
    love.window.setFullscreen(true, "desktop")

    world = love.physics.newWorld(0,0,true)  --world contains all relevant bodies/fixtures in physics simulation

    ball1 = Ball(2560/3, 1440/2, 50, 'dynamic',GLOBAL_RESTITUTION,world)
    ball2 = Ball(2560/2, 1440/2, 50, 'dynamic',GLOBAL_RESTITUTION,world)
    joint = love.physics.newDistanceJoint(ball1:getBody(), ball2:getBody(), ball1:getX(), ball1:getY(), ball2:getX(), ball2:getY(), true)

    table.insert(balls, ball1)
    table.insert(balls, ball2)

    
    
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

    if love.mouse.wasPressed(2) then                           --every right click generates a new ball
        count = count + 1
        ballBodyNew = love.physics.newBody(world, love.mouse.getX(), love.mouse.getY(),'dynamic')      
        ballShapeNew = love.physics.newCircleShape(50)
        ballFixtureNew =love.physics.newFixture(ballBodyNew,ballShapeNew)
        ballFixtureNew:setRestitution(1)
        table.insert(balls, ballFixtureNew)
    end

    if love.mouse.isDown(1) then                               --if left mouse is down grab a ball and move it around with the mouse
        for f, fixture in pairs(balls) do
            if isBallGrabbed(fixture:getBody()) then
                fixture:getBody():setX(love.mouse.getX())
                fixture:getBody():setY(love.mouse.getY())
            end
        end
    end



    love.keyboard.keysPressed = {}   --clear all the keypresses after update has run
    love.mouse.keysPressed ={}
    love.mouse.keysReleased = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then                       --where escape from game and pause can happen
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
        love.graphics.setColor(math.random(1,255),math.random(1,255),math.random(1,255), 255)
        x, y = fixture:getBody():getPosition()
        love.graphics.circle('line', x, y, 50)
    end
    love.graphics.setColor(math.random(255),math.random(255),math.random(255),255)
    text = love.graphics.newText(love.graphics.getFont(),tostring(count))
    love.graphics.draw(text, 50, 50)
end

function isBallGrabbed(circle)   --detects if mouse position is within a circle object
    x = circle:getX()
    y = circle:getY()

    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()

    if x - 50 < mouseX and x + 50 > mouseX                -- +/-50 to account for the radius of the circle
            and y - 50 < mouseY and y + 50 > mouseX then
        return true
    end

    return false
end