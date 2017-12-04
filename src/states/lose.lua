local lose = {}

function lose:init()
  self.img = love.graphics.newImage("assets/lose.png")
end

function lose:draw()
  love.graphics.draw(self.img)
end

function lose:keypressed(key)
  if key == "space" or key == "return" then
    libs.gamestate.switch(states.menu)
  end
end

return lose
