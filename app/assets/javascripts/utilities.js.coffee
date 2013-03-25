class window.Collection
  constructor: (items) ->
    @items = items || []

  findById: (id) ->
    id = parseInt(id, 10)
    for item in @items
      return item if item.id == id

  removeById: (id) ->
    @items = (item for item in @items when item.id != id)

  remove: (thisItem) ->
    @items = (item for item in @items when item != thisItem)

  add: (item) ->
    @items.push item

  empty: ->
    @items = []

