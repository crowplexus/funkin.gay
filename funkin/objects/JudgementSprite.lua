local JudgementSprite = require("jigw.objects.Sprite"):extend()

function JudgementSprite:new(x,y,tex)
  JudgementSprite.super.new(x,y,tex)
  self.velocity = Vector2(0,0)
  self.acceleration = 0
end

return JudgementSprite