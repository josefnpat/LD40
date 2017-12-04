local win = {}

function win:init()
  self.img = love.graphics.newImage("assets/win.png")
end

function win:draw()
  love.graphics.draw(self.img)
end

function win:keypressed(key)
  if key == "space" or key == "return" then
    libs.gamestate.switch(states.menu)
  end
end

return win
