---@diagnostic disable: lowercase-global

function onPlayerHit(event)
  -- event.player
  -- event.note.type
  -- event.note.column
  -- event.note.time
  event.player.health = event.player.health - 0.875
  return event
end

function onPlayerMiss(event)
  event:interrupt()
  return event
end
