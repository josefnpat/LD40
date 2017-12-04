local controls = {}

function controls:init()
  self.img = love.graphics.newImage("assets/controls.png")
end

function controls:draw()
  love.graphics.draw(self.img)
end

function controls:keypressed(key)
  if key == "space" or key == "return" then
    libs.gamestate.switch(states.menu)
  end
end

return controls
