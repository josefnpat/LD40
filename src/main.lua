-- Thanks @bartbes! fixes cygwin buffer
io.stdout:setvbuf("no")

function love.graphics.getWidth() return 1280/2 end
function love.graphics.getHeight() return 720/2 end

states = {
  game = require "states.game",
  menu = require "states.menu",
  splash = require "states.splash",
  win = require "states.win",
  lose = require "states.lose",
  controls = require "states.controls",
  credits = require "states.credits",
}

libs = {
  gamestate = require "gamestate",
  splash = require "splash",
  shp = require "shp",
}

sfx = {
  awaywithyou = love.audio.newSource("assets/sfx/awaywithyou.ogg","static"),
  bacon = love.audio.newSource("assets/sfx/bacon.ogg","static"),
  welcome = love.audio.newSource("assets/sfx/welcome.ogg","static"),
  yes = love.audio.newSource("assets/sfx/yes.ogg","static"),
  omnomnom = love.audio.newSource("assets/sfx/omnomnom.ogg","static"),
  win = love.audio.newSource("assets/sfx/win.ogg","static"),
  lose = love.audio.newSource("assets/sfx/lose.ogg","static"),
  sizzle = love.audio.newSource("assets/sfx/sizzle.ogg","static"),
  ding = love.audio.newSource("assets/sfx/ding.ogg","static"),
  fart = love.audio.newSource("assets/sfx/fart.ogg","static"),
  rawr = love.audio.newSource("assets/sfx/rawr.ogg","static"),
}

function sfxplay(sfxname)
  if sfx[sfxname] then
    for i,v in pairs(sfx) do
      v:stop()
    end
    sfx[sfxname]:play()
  else
    print("missing "..sfxname)
  end
end

function love.load()
  libs.gamestate.registerEvents()
  libs.gamestate.switch(states.splash)
  scale = 1
end

function love.draw()
  love.graphics.scale(scale)
end

function love.keypressed(key)
  if key == "`" and love.keyboard.isDown("lshift") then
    debug_mode = not debug_mode
  end
  local update_mode = false
  if key == "-" then
    scale = math.max(1,scale - 1)
    update_mode = true
  end
  if key == "=" then
    scale = scale + 1
    update_mode = true
  end
  if update_mode then
    love.window.setMode(1280/2*scale,720/2*scale)
  end
end
