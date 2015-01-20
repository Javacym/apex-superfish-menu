{CompositeDisposable, $} = require 'atom'

window.$ or= window.jQuery || $
AtomSuperfishMenuView = require './atom-superfish-menu-view'

module.exports = AtomSuperfishMenu =
  atomSuperfishMenuView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomSuperfishMenuView = new AtomSuperfishMenuView(state.atomSuperfishMenuViewState)
    #@modalPanel = atom.workspace.addModalPanel(item: @atomSuperfishMenuView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    @originalMenuUpdate = atom.menu.update
    atom.menu.update = @updateMenu.bind @

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-superfish-menu:toggle': => @toggle()

  updateMenu: ->
    # update the template
    @originalMenuUpdate.call atom.menu
    @atomSuperfishMenuView.updateMenu()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomSuperfishMenuView.destroy()
    atom.menu.update = @originalMenuUpdate

  serialize: ->
    atomSuperfishMenuViewState: @atomSuperfishMenuView.serialize()

  toggle: ->
    console.log 'AtomSuperfishMenu was toggled!'
