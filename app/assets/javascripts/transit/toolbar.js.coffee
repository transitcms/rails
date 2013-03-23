$ = @Transit.$

class @Transit.Toolbar extends Spine.Controller
  managerBar: null
  managers: []
  
  constructor:->
    @$el = $('#transit_toolbar')
    @managerBar = @$('#transit_managers')
    @hide()
    
    Transit.one('ready', @show)
    
    # hide or show the toolbar for previews
    Transit.on("preview:start", @hide) 
    Transit.on("preview:end", @show) 
    
    @setupManagers()
    
  
  addManager:(options, context)->
    button = $(document.createElement('a')).text( options.label )
    button.prepend("<i class='icon-#{options.icon}'></i> ")
    context.append( $('<li />').append(button) )
    @
    
  hide:=> @$el.hide()
  
  setupManagers:()->
    @managerBar.empty()
    @managers = []
    
    for klass, opts in Transit.options.managers
      object = Transit.utils.findClass(window, klass)
      if object is undefined
        Transit.logger.error("The object #{klass} could not be found.")
        continue
        
      man = new object(opts)
      @managers << man
      @addManager( { icon: man.icon, label: man.label }, @managerBar )
  
  show:=> @$el.show()