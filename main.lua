--[[
    Created by: Michael Blanchard 2018
    xyz
]]

Class = require 'src/class'

require 'src/Ball'
require 'src/Leg'
require 'src/constants'


function love.load()
    math.randomseed(os.time())

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}

    balls = {}
    legs = {}

    paused = false
    fullscreen = true

    love.window.setTitle('Physics Playscape')
    love.window.setFullscreen(true, "desktop")

    world = love.physics.newWorld(0,GRAVITY,true)  --world contains all relevant bodies/fixtures in physics simulation

    ball = Ball(2560/2 + 5, 1440/2 + 5, 50, 'dynamic',GLOBAL_RESTITUTION,world)
    ball:getBody():setMass(10)
   
    table.insert(balls, ball)
  

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
        table.insert(legs, Leg(love.mouse.getX(),love.mouse.getY(),200, 50,'dynamic',GLOBAL_RESTITUTION,world))
    end

    if love.mouse.wasPressed(1) then                          
        ball:getBody():applyLinearImpulse(1000,0,ball:getX(),ball:getY())
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

    for k, fixture in pairs(legs) do 
        love.graphics.setColor(math.random(1,255),math.random(1,255),math.random(1,255), 255)
        x, y = fixture:getBody():getPosition()
        love.graphics.rectangle('line', x, y, 200,50)
    end
end

function isBallGrabbed(circle)   --detects if mouse position is within a circle object
    x = circle:getX()
    y = circle:getY()

    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()

    if x - 100 < mouseX and x + 100 > mouseX                -- +/-50 to account for the radius of the circle
            and y - 100 < mouseY and y + 100 > mouseX then
        return true
    end

    return false
end