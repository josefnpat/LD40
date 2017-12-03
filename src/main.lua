states = {
  game = require "states.game",
  splash = require "states.splash",
}


libs = {
  gamestate = require"gamestate",
  splash = require"splash",
}

function love.load()
  libs.gamestate.registerEvents()
  libs.gamestate.switch(states.splash)
end
