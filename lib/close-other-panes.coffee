{CompositeDisposable} = require 'atom'
_  = require 'underscore-plus'

module.exports =
  config:
    moveItems:
      description: 'Move items into current pane when closing other panes.'
      type: 'boolean'
      default: true

  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'close-other-panes:close-other-panes': => @closeOtherPanes()

  deactivate: ->
    @subscriptions.dispose()

  closeOtherPanes: ->
    currentPane = atom.workspace.getActivePane()
    panes = atom.workspace.getPanes()
    moveItems = atom.config.get('close-other-panes.moveItems')

    for pane in panes
      unless pane is currentPane
        currentItems = currentPane.getItems()
        if moveItems
          for item, i in pane.getItems()
            unless _.contains(currentItems, item)
              pane.moveItemToPane(item, currentPane, i)
        pane.close()
