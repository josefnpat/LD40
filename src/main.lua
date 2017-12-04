-- Thanks @bartbes! fixes cygwin buffer
io.stdout:setvbuf("no")

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
end

function love.keypressed(key)
  if key == "`" and love.keyboard.isDown("lshift") then
    debug_mode = not debug_mode
  end
end
