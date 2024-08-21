local templateEvent = {
  --- Internal Name for the event
  --- @type string
  __name = "my_event",
  --- Display Name, used for formatting
  ---
  --- if unspecified, `__name` will be used in its place.
  --- @type string
  display_name = "My Event",
  --- Event argument list.
  --- @type table<any>
  arguments = {},
}
--- Event preload callback
--- @type function
function templateEvent:preload() end
--- Event trigger callback.
--- @type function
function templateEvent:fire() end
return templateEvent
