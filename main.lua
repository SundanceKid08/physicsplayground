--[[
    Created by: Michael Blanchard and Lee Gushurst 2018
    xyz
]]

Class = require 'src/class'

require 'src/Ball'
require 'src/Leg'
require 'src/constants'


function love.load()
    math.randomseed(os.time())
    love.window.setMode(2560,1440)
    debug = true                                                --change flag for debug rendering of Polygons
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
    timer = 0
    balls = {}     
    legs = {}
    joints = {}
    score = 0
    paused = false                                                  --Game Pause  *not currently implemented in update
    fullscreen = true                                               --fullscreen mode

    love.window.setTitle('Physics Playscape')
    love.window.setFullscreen(true, "desktop")

    world = love.physics.newWorld(0,GRAVITY,true)   --world contains all relevant bodies/fixtures in physics simulation

    goal = Leg(WINDOW_WIDTH * 2, WINDOW_HEIGHT/2, 200, 500,'static',0,world)
    
    

    torso = Leg(0, WINDOW_HEIGHT/2, 200, 500,'static',0,world)


    thigh = Leg(WINDOW_WIDTH/2,WINDOW_HEIGHT/2,200,50,'static',0,world)
    thigh:getBody():setAngle(0 * DEGREES_TO_RADIANS)
    xt, yt = thigh:getBody():getWorldCenter()
    calf = Leg(xt + 60,yt + 100,200,50,'dynamic',0,world)
    calf:getBody():setAngle(90 * DEGREES_TO_RADIANS)
    knee = love.physics.newRevoluteJoint(thigh:getBody(),calf:getBody(),xt + 75,yt,false)
    knee:setLimitsEnabled(true)
    knee:setLimits(285* DEGREES_TO_RADIANS, 360* DEGREES_TO_RADIANS)    
    xc, yc = calf:getBody():getWorldCenter()
    --foot = Leg(xc,yc, 30, 60, 'dynamic', 0,  world)
    --ankle = love.physics.newWeldJoint(calf:getBody(), foot:getBody(), xc + 100, yc, false)
    --foot:getBody():setAngle(90 * DEGREES_TO_RADIANS)
    table.insert(legs, goal)
    table.insert(legs, torso)
    table.insert(legs, thigh)
    table.insert(legs, calf)
    --table.insert(legs, foot)
    table.insert(joints, knee)
    table.insert(joints, ankle)

end

function love.update(dt)
    world:update(dt)
    
    
    
    if love.mouse.isDown(2) then                                   --every right click generates a new leg
        calf:getBody():applyLinearImpulse(-1000, 500)
    end

    if love.mouse.isDown(1) then                          
       calf:getBody():applyLinearImpulse(1000,0)
    end

    if debug then
        buggy()
    end

    if timer > 7 then
        newBall = Ball(thigh:getX() + 150, thigh:getY() - 300, 50, 'dynamic', GLOBAL_RESTITUTION, world)
        newBall:getFixture():setFilterData(1,1,1)                       --set ball to category 1 fixture
        table.insert(balls, newBall)
        goal:getFixture():setMask(1)                                 --set goal to not collide with cat 1 fixtures
        timer = 0
    end

    timer = timer + dt

    for k, ball in pairs(balls) do
        if goal:getFixture():testPoint(ball:getBody():getPosition()) and not ball:isScored() then
            ball:setScored(true)
            score = score + 1
        end
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
        love.graphics.rectangle('line', x - 100, y - 25, fixture:getWidth(),fixture:getHeight())    --draw rectangle accounting for offset from center
        love.graphics.pop()                                         --return draw to original state
    end
    text = love.graphics.newText(love.graphics.getFont(), 'score = ' .. tostring(score))
    love.graphics.draw(text,100,100)
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

function buggy()
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
