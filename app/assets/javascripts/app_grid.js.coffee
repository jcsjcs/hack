#AppGrid.new 'meetGrid', columns, data, config
class window.AppGrid
  constructor: (@gridid, columns, data, config) ->
    @config = config
    @columns = columns
    jQuery.each @columns, (i, val) ->
      if val.formatter == "ShowLinkTextFormatter"
        val.formatter = ShowLinkTextFormatter
      if val.formatter == "HackAttendanceFormatter"
        val.formatter = HackAttendanceFormatter

    @options =
      editable: true
      enableCellNavigation: true
      enableColumnReorder: false # load JQ UI sort...
      autoEdit: false
      enableTextSelectionOnCells: true
      syncColumnCellResize: true
    if @config.show_column
      @columns.push
        id: "show"
        name: "Show"
        field: "show"
        formatter: ShowLinkFormatter
        unfiltered: true

    if @config.edit_column
      @columns.push
        id: "edit"
        name: "Edit"
        field: "edit"
        formatter: EditLinkFormatter
        unfiltered: true

    if @config.destroy_column
      @columns.push
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
      cssClass: "cell-selection"
      width: 40
      cannotTriggerInsert: true
      resizable: false
      unselectable: true
      sortable: false
      unfiltered: true
      cssClass: "ui-state-default jq@grid-rownum slk_cell_right_align"

    @searchString = ""

    @dataView = new Slick.Data.DataView()
    @dataView.beginUpdate()
    @dataView.setItems data
    @dataView.setFilter myFilter
    @dataView.endUpdate()
    @grid = new Slick.Grid("##{@gridid}", @dataView, @columns, @options)
    @grid.setSelectionModel new Slick.RowSelectionModel(selectActiveRow: false)
    @dataView.onRowCountChanged.subscribe (e, args) ->
      @grid.updateRowCount()
      @grid.render()

    @dataView.onRowsChanged.subscribe (e, args) ->
      @grid.invalidateRows args.rows
      @grid.render()

    columnpicker = new Slick.Controls.ColumnPicker(@columns, @grid, @options)
    #TODO: Tie grid to gridid.data & use to get dataView for refresh...
    $("##{@gridid}txtSearch").keyup (e) ->
      return  if e.which is 27
      @searchString = @value
      @dataView.refresh()

    $("##{@gridid}txtSearch").on "search", ->
      if @value is ""
        @searchString = @value
        @dataView.refresh()

  RowNumberFormatter = (row, cell, value, columnDef, dataContext) ->
    row + 1 + " "

  EditLinkFormatter = (row, cell, value, columnDef, dataContext) ->
    "<a href=\"#{@config.editUrl}/" + dataContext.id + "/edit\">edit</a>"

  ShowLinkFormatter = (row, cell, value, columnDef, dataContext) ->
    "<a href=\"#{@config.editUrl}/" + dataContext.id + "\">show</a>"

  ShowLinkTextFormatter = (row, cell, value, columnDef, dataContext) ->
    "<a href=\"#{@config.editUrl}/" + dataContext.id + "\">#{value}</a>"

  DestroyLinkFormatter = (row, cell, value, columnDef, dataContext) ->
    "<a data-confirm=\"Are you sure?\" data-method=\"delete\" href=\"#{@config.editUrl}/" + dataContext.id + "\" rel=\"nofollow\">destroy</a>"

  HackAttendanceFormatter = (row, cell, value, columnDef, dataContext) ->
    "<span style=\"width:3em;display:inline-block;text-align:right;padding-right:0.5em;\">#{value}</span> <a href=\"hack_meets/" + dataContext.id + "attendance\">Change</a>"

  myFilter = (item, args) ->
    cols = []
    return true  if @grid is `undefined`
    jQuery.each @grid.getColumns(), (i, val) ->
      cols.push val  unless val.unfiltered

    searchHit = false
    
    if @searchString isnt ""
      i = 0

      while i < cols.length
        col = cols[i]
        searchHit = true  if String(item[col.field]).toLowerCase().indexOf(@searchString.toLowerCase()) isnt -1
        i++
      return searchHit
    true

# @grid = undefined
# data = [
#   title: "Mr"
#   initials: "J"
#   first_name: "John"
#   surname: "Piets"
#   tel_home: "1010101"
#   tel_office: ""
#   tel_cell: ""
#   email: "john@johnson.com"
#   email_ok: true
#   email_issues: ""
#   non_hacker: false
#   comments: ""
#   contact_via: null
#   group_with: null
#   hack_attendances_count: 1
#   id: 1
# ,
#   title: "Mr"
#   initials: "P"
#   first_name: "Peter"
#   surname: "Rabbit"
#   tel_home: "102910"
#   tel_office: "2002009"
#   tel_cell: ""
#   email: "fred@fred.com"
#   email_ok: true
#   email_issues: ""
#   non_hacker: false
#   comments: "Some such stuff\r\nNoted."
#   contact_via: null
#   group_with: null
#   hack_attendances_count: 1
#   id: 2
# ]


#enableColumnReorder: true, needs jq ui sortable
#multiColumnSort: true
# columns = [
#   id: "title"
#   name: "Title"
#   field: "title"
# ,
#   id: "initials"
#   name: "Initials"
#   field: "initials"
# ,
#   id: "first_name"
#   name: "First name"
#   field: "first_name"
# ,
#   id: "surname"
#   name: "Surname"
#   field: "surname"
# ,
#   id: "tel_home"
#   name: "Tel home"
#   field: "tel_home"
# ,
#   id: "tel_office"
#   name: "Tel office"
#   field: "tel_office"
# ,
#   id: "tel_cell"
#   name: "Tel cell"
#   field: "tel_cell"
# ,
#   id: "email"
#   name: "Email"
#   field: "email"
# ,
#   id: "email_ok"
#   name: "Email ok"
#   field: "email_ok"
# ,
#   id: "email_issues"
#   name: "Email issues"
#   field: "email_issues"
# ,
#   id: "non_hacker"
#   name: "Non hacker"
#   field: "non_hacker"
# ,
#   id: "comments"
#   name: "Comments"
#   field: "comments"
# ,
#   id: "contact_via"
#   name: "Contact via"
#   field: "contact_via"
# ,
#   id: "group_with"
#   name: "Group with"
#   field: "group_with"
# ,
#   id: "hack_attendances_count"
#   name: "Hack attendances count"
#   field: "hack_attendances_count"
# ]
#selectedIds = []
#$ ->
  
  # initialize the model
  
  #    var filterPlugin = new Ext.Plugins.HeaderFilter({sortAvailable: false});
  
  # wire up model events to drive the @grid
  
  # Wire up the search textbox to apply the filter to the model
  
  # Ignore Esc - handled by HTML5 onSearch event below
  
  # Check for click of [x] to clear search box...
  
  # clear on [x] clicked in search box or ESC pressed
  #@dataView = new Slick.Data.DataView(inlineFilters: true)

