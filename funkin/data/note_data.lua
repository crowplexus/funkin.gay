local template_note = {
  --- ...
  --- @type number
  row = 0,
  --- a note's column.
  --- @type number
  column = 0,
  --- a note's kind, if nil or empty, this is a normal note.
  --- @type string
  kind = nil,
  --- Hold Note data, contains size and type.
  ---
  --- e.g: {50.0, "normal"}
  --- @type table<[number,string]>
  hold = {0.0, nil},
  --- Note judgement, given to a note when hitting or missing it.
  --- @type table<any>
  judgement = nil,
}

return template_note
