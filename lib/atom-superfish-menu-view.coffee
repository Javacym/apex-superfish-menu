$ = require('atom').$;
require('./superfish')($, window)

module.exports =
class AtomSuperfishMenuView
  constructor: (serializeState) ->
    # Create root element
    @element = $(document.createElement('ul'))
    @element.addClass('atom-superfish-menu')
    @element.addClass('sf-menu')

    atom.superfish or= {}
    atom.superfish.$ = $
    atom.superfish.view = @
    atom.superfish.element = @element

    @element.css { 'display': 'none' }

    # test
    atom.superfish.items = []

    @options = {}

    @createMenu()
    $('body').prepend @getElement()
    @getElement().superfish(@options)
    @element.css { 'display': 'block' }

  updateMenu: ->
    if @element
      @element.remove()

    @element = $(document.createElement('ul'))
    @element.addClass('atom-superfish-menu')
    @element.addClass('sf-menu')

    atom.superfish.items = []

    @element.css { 'display': 'none' }
    @createMenu()

    $('body').prepend @getElement()
    @getElement().superfish(@options)
    @element.css { 'display': 'block' }


  createMenu: ->
    @element.empty()
    for item in atom.menu.template
      if not item or not item.submenu then continue
      menuEl = $ document.createElement('li')
      labelEl = $ document.createElement('a')
      labelEl.text (item.label+'').replace("&", "").replace("Atom", "Apex")
      labelEl.attr 'href', '#'
      submenuEl = $ document.createElement('ul')
      menuEl.append labelEl
      menuEl.append submenuEl
      @createSubmenus(item.submenu, submenuEl)
      menuEl.addClass labelEl.text().toLowerCase()+'-menu'
      @element.append menuEl

  createSubmenus: (items, el) ->
    if not items then return
    for item in items
      atom.superfish.items.push item

      menuEl = $ document.createElement('li')

      if typeof(item.enabled) != null and item.enabled == false
        continue

      if item.type and item.type == 'seperator'
        menuEl.addClass 'sf-menu-seperator'
        el.append menuEl
        continue

      labelEl = $ document.createElement('a')
      label = item.label+''
      if item.label
        label = label.replace("&", "").replace("Atom", "Apex")
        labelEl.text label
        labelEl.attr 'href', '#'
        menuEl.append labelEl
        if item.command then labelEl.attr 'atom-command', item.command
        labelEl.click (e) ->
          name = $(@).attr('atom-command')
          $(@).parent().parent().hide()

          if not atom.commands.registeredCommands[name] then return
          obj = atom.commands.selectorBasedListenersByCommandName[name]
          if obj and obj?.length != 0
            obj = obj[0]
            result = document.querySelector(obj.selector).dispatchEvent new CustomEvent(name, { bubbles: true })
          else
            e = e || {}
            atom.commands.dispatch(document.querySelector('atom-workspace') || document.body, name, e)
            console.log name

      if item.submenu
        submenuEl = $ document.createElement('ul')
        menuEl.append submenuEl
        @createSubmenus item.submenu, submenuEl

      el.append menuEl



  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
