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
    debug = false                                                   --change flag for debug rendering of Polygons
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}

    balls = {}     
    legs = {}

    paused = false                                                  --Game Pause  *not currently implemented in update
    fullscreen = true                                               --fullscreen mode

    love.window.setTitle('Physics Playscape')
    love.window.setFullscreen(true, "desktop")

    world = love.physics.newWorld(0,GRAVITY,true)                   --world contains all relevant bodies/fixtures in physics simulation

    ball = Ball(2560/2 - 200, 1440/2, 50, 'dynamic',GLOBAL_RESTITUTION,world)
    ball2 = Ball(2560/2 - 500, 1440/2, 50, 'dynamic',GLOBAL_RESTITUTION,world)
    center = Ball(2560/2, 1440/2, 50, 'static',GLOBAL_RESTITUTION,world)
    joint = love.physics.newRevoluteJoint(ball:getBody(),center:getBody(),center:getX(),center:getY(), true)
    joint2 = love.physics.newRevoluteJoint(ball2:getBody(),center:getBody(),center:getX(),center:getY(), true)
    ball:getBody():applyLinearImpulse(0,10000)
    ball2:getBody():applyLinearImpulse(0,15000)

     ball3 = Ball(2560/2 - 700, 1440/2, 50, 'static',GLOBAL_RESTITUTION,world)
   
   
    table.insert(balls, ball)
    table.insert(balls,ball2)
    table.insert(balls,center)

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
    if love.mouse.wasPressed(2) then                                    --every right click generates a new leg
        leg = Leg(love.mouse.getX(),love.mouse.getY(),200, 50,'dynamic',GLOBAL_RESTITUTION,world)
        leg:getBody():setAngle(45 * DEGREES_TO_RADIANS)
        leg:getBody():setSleepingAllowed(true)                         --use of sleep is preferred as it reduces load when objects come to rest
        table.insert(legs, leg)
    end

    if love.mouse.wasPressed(1) then                          
        ball:getBody():applyLinearImpulse(1000,0,ball:getX(),ball:getY())
    end

    if debug then
        debug()
    end

    love.keyboard.keysPressed = {}                                  --clear all the keypresses after update has run
    love.mouse.keysPressed ={}
    love.mouse.keysReleased = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then                                         --where escape from game and pause can happen
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

    for k, fixture in pairs(legs) do 
        x, y = fixture:getBody():getLocalCenter()                   --get center postion of body
        xo, yo = fixture:getBody():getPosition()                    --get position of body (in this case top left corner  *I THINK*)
        angle = fixture:getBody():getAngle()                        --get angle of rotation of body
        love.graphics.push()                                        --push draw setup to stack
        love.graphics.translate(x + xo, y + yo)                     -- add the center position to the x,y position and translate
        love.graphics.rotate(angle)                                 --rotate the draw function
        love.graphics.rectangle('line', x - 100, y - 25, 200,50)    --draw rectangle accounting for offset from center
        love.graphics.pop()                                         --return draw to original state
    end
end

function isBallGrabbed(circle)                                      --detects if mouse position is within a circle object
    x = circle:getX()
    y = circle:getY()

    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()

    if x - 100 < mouseX and x + 100 > mouseX                        -- +/-50 to account for the radius of the circle
            and y - 100 < mouseY and y + 100 > mouseX then
        return true
    end

    return false
end

function debug()
    for _, body in pairs(world:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()
       
            if shape:typeOf("CircleShape") then
              love.graphics.setColor(1,0,1,1)
              local cx, cy = body:getWorldPoints(shape:getPoint())
              love.graphics.circle('line', cx, cy, 50)
              --love.graphics.circle('line', 10, 10, 50)
                --local cx, cy = body:getWorldPoints(shape:getPoint())
                --love.graphics.circle("fill", cx, cy, shape:getRadius())
            elseif shape:typeOf("PolygonShape") then
                love.graphics.setColor(1,0,1,1)
                love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
            else
                love.graphics.setColor(1,0,1,1)
                love.graphics.line(body:getWorldPoints(shape:getPoints()))
            end
        end
    end
end
