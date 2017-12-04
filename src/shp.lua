local shp = {}

function shp.new(init)
  init = init or {}
  local self = {}
  self.on = init.on
  self.off = init.off
  self.val = init.val or 1

  self.draw = shp.draw
  self.getWidth = shp.getWidth
  self.getHeight = shp.getHeight

  return self
end

function shp:draw(x,y)
  love.graphics.draw(self.on,x,y)
  local nh = self.off:getHeight()*self.val
  local offset = (1-self.val)*self.off:getHeight()
  local sx,sy,sw,sh = x,y+offset,self.off:getWidth(),self.off:getHeight()
  love.graphics.setScissor(sx*scale,sy*scale,sw*scale,sh*scale)
  love.graphics.draw(self.off,x,y)
  love.graphics.setScissor()
end

function shp:getWidth()
  return self.off:getWidth()
end

function shp:getHeight()
  return self.off:getHeight()
end

return shp
