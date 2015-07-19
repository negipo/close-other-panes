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
        if moveItems
          currentPathes = _.map(currentPane.getItems(), (item) ->
            item.getPath && item.getPath()
          )

          for item, i in pane.getItems()
            unless _.contains(currentPathes, item.getPath && item.getPath())
              pane.moveItemToPane(item, currentPane, i)

        pane.close()
