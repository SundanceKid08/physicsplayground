
Ball = Class{}

function Ball:init(x, y, r, state, restitution, world)
    self.scored = false
    self.ballBody = love.physics.newBody(world, x, y, state)      
    self.ballShape = love.physics.newCircleShape(r)
    self.ballFixture =love.physics.newFixture(self.ballBody, self.ballShape)
    self.ballFixture:setRestitution(restitution)
end

function Ball:getBody()
    return self.ballBody
end

function Ball:getShape()
    return self.ballShape
end

function Ball:getFixture()
    return self.ballFixture
end

function Ball:getX()
    return self.ballBody:getX()
end

function Ball:getY()
    return self.ballBody:getY()
end

function Ball:isScored()
    return self.scored
end

function Ball:setScored(scored)
    self.scored = scored
end