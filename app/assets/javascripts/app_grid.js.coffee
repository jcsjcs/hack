# Class used to create a Slick Grid
class window.AppGrid
  thisView   = undefined
  thisGridId = undefined
  constructor: (gridid, columns, data, config) ->
    thisGridId = gridid
    @config = config
    @columns = columns
    $.each @columns, (i, val) ->
      if val.formatter == "DestroyChoiceLinkFormatter"
        val.formatter = DestroyChoiceLinkFormatter
      if val.formatter == "ShowLinkTextFormatter"
        val.formatter = ShowLinkTextFormatter
      if val.formatter == "HackAttendanceFormatter"
        val.formatter = HackAttendanceFormatter
      if val.formatter == "BooleanFormatter"
        val.formatter = BooleanFormatter
      if val.formatter == "RenewLinkFormatter"
        val.formatter = RenewLinkFormatter
      if val.formatter == "PayLinkFormatter"
        val.formatter = PayLinkFormatter
      if val.formatter == "slickActionCollectionFormatter"
        val.formatter = slickActionCollectionFormatter
      if val.formatter == "YearMonthFormatter"
        val.formatter = YearMonthFormatter

      if val.formatter == "YesNo"
        val.formatter = Slick.Formatters.YesNo
      if val.formatter == "Checkmark"
        val.formatter = Slick.Formatters.Checkmark
      if val.formatter == "PercentComplete"
        val.formatter = Slick.Formatters.PercentComplete
      if val.formatter == "PercentCompleteBar"
        val.formatter = Slick.Formatters.PercentCompleteBar


    @options =
      editable: true
      enableCellNavigation: true
      enableColumnReorder: false # load JQ UI sort...
      autoEdit: false
      enableTextSelectionOnCells: true
      syncColumnCellResize: true
      multiColumnSort: true

    if @config.show_column
      splice_pos = @columns.length - (@config.show_pos || 0)
      @columns.splice splice_pos, 0,
        id: "show"
        name: "Show"
        field: "show"
        formatter: ShowLinkFormatter
        unfiltered: true

    if @config.edit_column
      splice_pos = @columns.length - (@config.edit_pos || 0)
      @columns.splice splice_pos, 0,
        id: "edit"
        name: "Edit"
        field: "edit"
        formatter: EditLinkFormatter
        unfiltered: true

    if @config.destroy_column
      splice_pos = @columns.length - (@config.destroy_pos || 0)
      @columns.splice splice_pos, 0,
        id: "destroy"
        name: "Destroy"
        field: "destroy"
        formatter: DestroyLinkFormatter
        unfiltered: true

    @columns.unshift
      id: "rowNumber"
      name: ""
      field: "rn"
      formatter: RowNumberFormatter
      behavior: "select"
      width: 50
      cannotTriggerInsert: true
      resizable: false
      unselectable: true
      sortable: false
      unfiltered: true
      cssClass: "cell-selection ui-state-default jqGrid-rownum slk_cell_right_align"

    @searchString = ""

    self = @ # Tie this to self for reference within functions

    myFilter = (item, args) ->
      cols = []
      return true  if self.grid is `undefined`
      $.each self.grid.getColumns(), (i, val) ->
        cols.push val  unless val.unfiltered

      value = true
      searchHit = false
      
      i = 0
      while i < cols.length
        col = cols[i]
        filterValues = col.filterValues
        if (filterValues && filterValues.length > 0)
          value = value & _.contains(filterValues, item[col.field])
        i++

      if value && self.searchString isnt ""
        i = 0

        while i < cols.length
          col = cols[i]
          searchHit = true  if String(item[col.field]).toLowerCase().indexOf(self.searchString.toLowerCase()) isnt -1
          i++
        return searchHit
      return value

    @dataView = new Slick.Data.DataView()
    thisView  = @dataView

    if data is undefined
      dataPath = 'members/grid_data'
      resDV = @dataView
      $.getJSON(dataPath, (rows, textStatus, jqXHR) ->
        # if rows.length > 0
        #   if rows[0].id = "undefined"
        #     $(rows).each (index) ->
        #       rows[index].newAttribute = "id"
        #       rows[index]["id"] = index

        data = rows

        dataView = resDV
        dataView.beginUpdate()
        dataView.setItems data
        dataView.setFilter myFilter
        # @dataView.setFilterArgs
        #   percentCompleteThreshold: percentCompleteThreshold
        #   searchString: searchString

        # @dataView.setFilter myFilter
        dataView.endUpdate()

        # loading.gif - on top of membersGrid...
        loading = document.createElement("img")
        loading.setAttribute("src", '/assets/medium_loading.gif')
        loading.id = "#{thisGridId}Loading"
        loading.style.position = 'absolute'
        loading.style.top      = "#{($("##{thisGridId}").height() / 2) - 40}px"
        loading.style.left     = "#{($("##{thisGridId}").width()  / 2) - 40}px"
        loading.style.zIndex = 999
        document.getElementById(thisGridId).appendChild(loading)

        setTimeout(continueLoading, 5)
        #dataView.syncGridSelection grid, true
      ).error (jqXHR, textStatus, errorThrown) ->
        if jqXHR.readyState < 4 # Ignore non-errors (page being unloaded etc.)
          return true
        alert "error: " + errorThrown
    else
    @dataView.beginUpdate()
    @dataView.setItems data
    @dataView.setFilter myFilter
    @dataView.endUpdate()
    @grid = new Slick.Grid("##{gridid}", @dataView, @columns, @options)
    @grid.setSelectionModel new Slick.RowSelectionModel(selectActiveRow: false)
    @dataView.onRowCountChanged.subscribe (e, args) ->
      self.grid.updateRowCount()
      self.grid.render()

    @dataView.onRowsChanged.subscribe (e, args) ->
      self.grid.invalidateRows args.rows
      self.grid.render()

    columnpicker = new Slick.Controls.ColumnPicker(@columns, @grid, @options)

    filterPlugin = new Ext.Plugins.HeaderFilter({sortAvailable: false})

    # This event is fired when a filter is selected
    filterPlugin.onFilterApplied.subscribe((e,args) ->
      thisView.refresh()
      self.grid.resetActiveCell()
      # showStatusCounts('#{@grid_id}')
    )

    @grid.registerPlugin(filterPlugin)

    gridSorter = (sortCols, dataView) ->
      dataView.sort ((row1, row2) ->
        i = 0
        l = sortCols.length

        while i < l
          field = sortCols[i].sortCol.field
          sign = (if sortCols[i].sortAsc then 1 else -1)
          x = row1[field]
          y = row2[field]
          result = ((if x < y then -1 else ((if x > y then 1 else 0)))) * sign
          return result  unless result is 0
          i++
        0
      ), true

    @grid.onSort.subscribe (e, args) ->
      gridSorter(args.sortCols, self.dataView)

    @dataView.getItemMetadata = (row) ->
      item = self.dataView.getItem(row)
      return null  if item is undefined
      
      # Get value from row_colour & return as cssClass
      return cssClasses: item.row_colour  if item.row_colour isnt ""
      {}


    # $("##{gridid}").data('slickgrid', @grid)           # Store a ref to the grid
    $("##{gridid}").data('slickgridView', @dataView)     # Store a ref to the dataView

  # -- End of Constructor --

  continueLoading = () ->
    dataPath = 'members/grid_data'
    $.getJSON(dataPath, (rows, textStatus, jqXHR) ->
      dataView = thisView
      dataView.beginUpdate()
      $(rows).each (index) ->
        dataView.addItem(rows[index])
      dataView.endUpdate()
      if rows.length == 0
        document.getElementById("#{thisGridId}Loading").style.display = 'none'
        # document.getElementById("membersGridLoading").style.display = 'none'
      else
        setTimeout(continueLoading, 5)
    ).error (jqXHR, textStatus, errorThrown) ->
      if jqXHR.readyState < 4 # Ignore non-errors (page being unloaded etc.)
        return true
      alert "error: " + errorThrown # Unless user has navigated to a new page....
  searchStringChanged: (str) ->
    @searchString = str
    @dataView.refresh()

  makeSearchEvents: (gridObj, searchId) ->
    $("##{searchId}").keyup (e) ->
      return  if e.which is 27
      gridObj.searchStringChanged(@value)

    $("##{searchId}").on "search", ->
      if @value is ""
        gridObj.searchStringChanged(@value)

  # GetGridForId = (gridid) ->
  #   $("##{gridid}").data('slickgrid')

  YearMonthFormatter = (row, cell, value, columnDef, dataContext) ->
    ar = value.split('-')
    mths = ['January', 'February', 'March', 'April', 'May','June','July','August','September','October','November','December']
    index = Number(ar[1])-1
    "#{ar[0]}: #{mths[index]}"

  RowNumberFormatter = (row, cell, value, columnDef, dataContext) ->
    row + 1 + " "

  BooleanFormatter = (row, cell, value, columnDef, dataContext) ->
    return if value is ''
    if(value == 't' || value == 'true' || value == 'y' || value =='Y' || value == 1)
      "<i class=\"fi-check\"></i>"
    else
      "<i class=\"fi-x\"></i>"

  EditLinkFormatter = (row, cell, value, columnDef, dataContext) ->
    "<a href=\"#{@config.editUrl}/" + dataContext.id + "/edit\">edit</a>"

  ShowLinkFormatter = (row, cell, value, columnDef, dataContext) ->
    "<a href=\"#{@config.editUrl}/" + dataContext.id + "\">show</a>"

  ShowLinkTextFormatter = (row, cell, value, columnDef, dataContext) ->
    "<a href=\"#{@config.editUrl}/" + dataContext.id + "\">#{value}</a>"

  DestroyLinkFormatter = (row, cell, value, columnDef, dataContext) ->
    "<a data-confirm=\"Are you sure?\" data-method=\"delete\" href=\"#{@config.editUrl}/" + dataContext.id + "\" rel=\"nofollow\">destroy</a>"

  DestroyChoiceLinkFormatter = (row, cell, value, columnDef, dataContext) ->
    if 'Y' == value
      "<a data-confirm=\"Are you sure?\" data-method=\"delete\" href=\"#{@config.editUrl}/" + dataContext.id + "\" rel=\"nofollow\">destroy</a>"
    else
      "&nbsp;"
  HackAttendanceFormatter = (row, cell, value, columnDef, dataContext) ->
    "<span style=\"width:3em;display:inline-block;text-align:right;padding-right:0.5em;\">#{value}</span> <a href=\"hack_meets/" + dataContext.id + "/attendance\">Change</a>"

  # ActionCollection:
  # Formatter for Action Collection.
  # Presents a button which when clicked launches a contextMenu.
  slickActionCollectionFormatter = (row, cell, value, columnDef, dataContext) ->
    return ""  if value is ""
    "<button class=\"slickGridContextMenu\" data-row=\"" + row + "\">list</button>"

# Process an Action type link.
slickProcessAction = (body) ->
  if body.prompt_text isnt ""
    return false  unless confirm(body.prompt_text)
  if body.cls.indexOf("popupjs") > -1 # Load page in a UI dialog
    jmtPopupDialog body.opts["data-dlg-width"], body.opts["data-dlg-height"], body.opts["data-dlg-title"], body.text, body.href
  else
    if body.method && body.method == 'delete' # Handle a delete request by using Rails' built-in handler.
      $.rails.handleMethod($('<a href="'+body.href+'" data-method="delete" rel="nofollow" data-confirm="Are you sure?">Delete</a>'))
    else
      window.location.href = body.href

slickProcessLinkWindow = (body) ->
  open_window_link body.href

# Build menu items for ActionCollection.
build_ac_context_sub_menu = (linkConfig, level) ->
  items = {}
  ky = "" + level
  linkConfig.forEach (element, i) ->
    k = level.slice()
    k.push i
    items[k.join("|")] = "---------"  if element.type is "separator"
    if element.type is "action"
      items[k.join("|")] =
        name: element.body.text
        icon: element.body.icon
    if element.type is "text"
      items[k.join("|")] =
        name: element.body
        disabled: true
    if element.type is "link_window"
      items[k.join("|")] =
        name: element.body.text
        icon: element.body.icon
    if element.type is "sub_menu"
      items[k.join("|")] =
        name: element.caption
        items: build_ac_context_sub_menu(element.body, k)
  items

# Return data object (at correct level for submenu).
linkConfigCurrentAt = (linkConfig, levels) ->
  nl = levels
  i = undefined
  currObj = undefined
  nl.shift() # Remove level 0
  currObj = linkConfig[nl.shift()] # Get level 0 object
  i = 0
  while i < nl.length
    currObj = currObj.body[nl[i]]
    i++
  currObj

$(document).ready ->

  # Context menu for ActionCollection in a grid.
  jQuery.contextMenu
    selector: ".slickGridContextMenu"
    trigger: "left"
    build: ($trigger, e) ->

      # this callback is executed every time the menu is to be shown
      # its results are destroyed every time the menu is hidden
      # e is the original contextmenu event, containing e.pageX and e.pageY (amongst other data)
      row = jQuery(e.target).data("row")
      gridView = jQuery(jQuery(e.target).parents(".a_slick_grid")[0]).data("slickgridView")
      rowdata = gridView.getItem(row)
      actionCollection = rowdata.actions
      #linkConfig = jQuery.parseJSON(actionCollection)
      linkConfig = actionCollection
      items = {}
      items = build_ac_context_sub_menu(linkConfig, [0])
      callback: (key, options) ->
        levels = key.split("|")
        currObj = linkConfigCurrentAt(linkConfig, levels)
        slickProcessAction currObj.body  if currObj.type is "action"
      # if(currObj.type === 'link_window') {slickProcessLinkWindow(currObj.body);}
      items: items

