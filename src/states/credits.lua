local credits = {}

function credits:init()
  self.img = love.graphics.newImage("assets/credits.png")
end

function credits:draw()
  love.graphics.draw(self.img)
end

function credits:keypressed(key)
  if key == "space" or key == "return" then
    libs.gamestate.switch(states.menu)
  end
end

return credits
