# Class used to create a Slick Grid
class window.AppGrid
  constructor: (gridid, columns, data, config) ->
    @config = config
    @columns = columns
    $.each @columns, (i, val) ->
      if val.formatter == "ShowLinkTextFormatter"
        val.formatter = ShowLinkTextFormatter
      if val.formatter == "HackAttendanceFormatter"
        val.formatter = HackAttendanceFormatter
      if val.formatter == "BooleanFormatter"
        val.formatter = BooleanFormatter

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
      cssClass: "ui-state-default jqGrid-rownum slk_cell_right_align"

    @searchString = ""

    self = @ # Tie this to self for reference within functions

    myFilter = (item, args) ->
      cols = []
      return true  if self.grid is `undefined`
      $.each self.grid.getColumns(), (i, val) ->
        cols.push val  unless val.unfiltered

      searchHit = false
      
      if self.searchString isnt ""
        i = 0

        while i < cols.length
          col = cols[i]
          searchHit = true  if String(item[col.field]).toLowerCase().indexOf(self.searchString.toLowerCase()) isnt -1
          i++
        return searchHit
      true

    @dataView = new Slick.Data.DataView()
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

    # $("##{gridid}").data('slickgrid', @grid)           # Store a ref to the grid

  # -- End of Constructor --

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

  RowNumberFormatter = (row, cell, value, columnDef, dataContext) ->
    row + 1 + " "

  BooleanFormatter = (row, cell, value, columnDef, dataContext) ->
    return if value is ''
    if(value || value == 't' || value == 'true' || value == 'y' || value == 1)
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

  HackAttendanceFormatter = (row, cell, value, columnDef, dataContext) ->
    "<span style=\"width:3em;display:inline-block;text-align:right;padding-right:0.5em;\">#{value}</span> <a href=\"hack_meets/" + dataContext.id + "/attendance\">Change</a>"

