{CompositeDisposable} = require 'atom'

module.exports =
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
    for pane in panes
      unless pane is currentPane
        pane.close()
