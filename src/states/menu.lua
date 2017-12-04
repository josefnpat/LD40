local menu = {}

function menu:init()

  local music = love.audio.newSource(
    "assets/TheUse_-_40_-_Polovetsian_Dance_Crazy_Circus_Music.mp3","stream")
  music:setLooping(true)
  music:setVolume(0.5)
  music:play()

  self.font = love.graphics.newFont("assets/fonts/OpenSansCondensed-Bold.ttf",30)
  self.color = {225,119,119}
  self.mid = love.graphics.newImage("assets/menu.png")
  self.bg = love.graphics.newImage("assets/background.png")
  self.bacon = love.graphics.newImage("assets/bacon_menu.png")
end

function menu:enter()
  sfxplay("welcome")
  self.options = {
    {lbl="START",exe=function() libs.gamestate.switch(states.game) end},
    {lbl="CONTROLS",exe=function() libs.gamestate.switch(states.controls) end},
    {lbl="CREDITS",exe=function() libs.gamestate.switch(states.credits) end},
  }
  self.current = 1
end

function menu:getOptionArea(i)
  return 290,136-24+i*(34+8),150,34
end

function menu:draw()
  love.graphics.draw(self.bg)
  love.graphics.draw(self.mid)
  love.graphics.setFont(self.font)
  for i,v in pairs(self.options) do
    love.graphics.setColor(self.color)
    local x,y,w,h = self:getOptionArea(i)
    if debug_mode then
      love.graphics.rectangle("line",x,y,w,h)
    end
    love.graphics.print(v.lbl,x,y)
    love.graphics.setColor(255,255,255)
    if self.current == i then
      love.graphics.draw(self.bacon,x-self.bacon:getWidth(),y)
    end
  end
end

function menu:update(dt)
end

function menu:keypressed(key)
  if key == "w" or key == "up" then
    self.current = self.current -1
    if self.current < 1 then
      self.current = #self.options
    end
  end
  if key == "s" or key == "down" then
    self.current = self.current + 1
    if self.current > #self.options then
      self.current = 1
    end
  end
  if key == "space" or key == "return" then
    self.options[self.current].exe()
  end
end

return menu
