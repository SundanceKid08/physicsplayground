Leg = Class{}

function Leg:init(x, y, width, height, state, restitution, world)
    self.width = width
    self.height = height
    self.legBody = love.physics.newBody(world, x, y, state)      
    self.legShape = love.physics.newRectangleShape(self.width, self.height)
    self.legFixture =love.physics.newFixture(self.legBody, self.legShape)
    self.legFixture:setRestitution(restitution)
end

function Leg:getBody()
    return self.legBody
end

function Leg:getShape()
    return self.legShape
end

function Leg:getFixture()
    return self.legFixture
end

function Leg:getX()
    return self.legBody:getX()
end

function Leg:getY()
    return self.legBody:getY()
end

function Leg:getWidth()
    return self.width
end

function Leg:getHeight()
    return self.height
end


