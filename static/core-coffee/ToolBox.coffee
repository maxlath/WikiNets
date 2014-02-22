# adds a "Show All Nodes" button to load the whole database into the graph
# model
define [], () ->

  class ToolBox extends Backbone.View

    constructor: (@options) ->
      super()

    init: (instances) ->
      @render()
      @graphModel = instances["GraphModel"]
      @dataProvider = instances["local/WikiNetsDataProvider"]
      @selection = instances["NodeSelection"]
      @dataController = instances["local/Neo4jDataController"] 
      #instances["Layout"].addPlugin @el, @options.pluginOrder, 'Explorations', true
      $(@el).attr("class", "toolboxpopout")
      $(@el).appendTo $('#maingraph')

      $(@el).hide()

      # $(@tooltip).hide()

      @graphView = instances["GraphView"]
      @listView = instances["local/ListView"]

    render: ->
      $container = $("<div id=\"show-all-container\">").appendTo(@$el)

      $('#listviewButton').click(() =>
        $(@listView.el).show()
        $('#listviewButton').css("background", "url(\"images/icons/blue/list_nested_24x21.png\")")
        $(@graphView.el).hide()
        $('#graphviewButton').css("background", "url(\"images/icons/gray_dark/share_24x24.png\")")
        )

      $('#graphviewButton').click(() =>
        $(@listView.el).hide()
        $('#listviewButton').css("background", "url(\"images/icons/gray_dark/list_nested_24x21.png\")")
        $(@graphView.el).show()
        $('#graphviewButton').css("background", "url(\"images/icons/blue/share_24x24.png\")")
        )

      $('#minimapButton').click(() =>
        $('#slidersPopOut').hide()
        $('#minimapPopOut').toggle()
        $(@el).hide()
        )

      $('#slidersButton').click(() =>
        $('#slidersPopOut').toggle()
        $('#minimapPopOut').hide()
        $(@el).hide()
        )

      $('#moreoptionsButton').click(() =>
        $('#slidersPopOut').hide()
        $('#minimapPopOut').hide()
        $(@el).toggle()        
        )



      $showAllButton = $("<input type=\"button\" id=\"showAllButton\" value=\"Show All\"></input>").appendTo $container
      $showAllButton.click(() =>
        @dataProvider.getEverything(@loadAllNodes)
        )

      $clearAllButton = $("<input type=\"button\" id=\"clearAllButton\" value=\"Clear All\"></input>").appendTo $container
      $clearAllButton.click(() =>
        @graphModel.filterNodes (node) -> false
        )

      $expandSelectionButton = $("<input type=\"button\" id=\"expandSelectionButton\" value=\"Expand Selection\"></input>").appendTo $container
      $expandSelectionButton.click(() =>
        @expandSelection()
        )

      $selectAllButton = $("<input type=\"button\" id=\"selectAllButton\" value=\"Select All\"></input>").appendTo $container
      $selectAllButton.click(() =>
        @selection.selectAll()
        )

      $deselectAllButton = $("<input type=\"button\" id=\"deselectAllButton\" value=\"Deselect All\"></input>").appendTo $container
      $deselectAllButton.click(() =>
        @selection.deselectAll()
        )

      $clearSelectedButton = $("<input type=\"button\" id=\"clearSelectedButton\" value=\"Clear Selection\"></input>").appendTo $container
      $clearSelectedButton.click(() =>
        @selection.removeSelection()
        )

      $chooseSelectButton = $("<input type=\"button\" id=\"chooseSelectButton\" value=\"Clear Unselected\"></input>").appendTo $container
      $chooseSelectButton.click(() =>
        @selection.removeSelectionCompliment()
        )

      $unpinAllButton = $("<input type=\"button\" id=\"unpinAllButton\" value=\"Un-pin Layout\"></input>").appendTo $container
      $unpinAllButton.click(() =>
        node.fixed = false for node in @graphModel.getNodes()
        )

      $unpinAllButton = $("<input type=\"button\" id=\"unpinAllButton\" value=\"Pin Layout\"></input>").appendTo $container
      $unpinAllButton.click(() =>
        node.fixed = true for node in @graphModel.getNodes()
        )

      $unpinSelectedButton = $("<input type=\"button\" id=\"unpinSelectedButton\" value=\"Un-Pin Selected\"></input>").appendTo $container
      $unpinSelectedButton.click(() =>
        node.fixed = false for node in @selection.getSelectedNodes()
        )

      $pinSelectedButton = $("<input type=\"button\" id=\"unpinSelectedButton\" value=\"Pin Selected\"></input>").appendTo $container
      $pinSelectedButton.click(() =>
        node.fixed = true for node in @selection.getSelectedNodes()
        )

      $showLearningButton = $("<input type=\"button\" id=\"showLearningButton\" value=\"Learning\"></input>").appendTo $container
      $showLearningButton.click(() =>
        @searchNodes({Theme:"Learning"})
        )

      $showStudentLifeButton = $("<input type=\"button\" id=\"showStudentLifeButton\" value=\"Student Life\"></input>").appendTo $container
      $showStudentLifeButton.click(() =>
        @searchNodes({Theme:"Student Life"})
        )
            
      $showResearchButton = $("<input type=\"button\" id=\"showResearchButton\" value=\"Research\"></input>").appendTo $container
      $showResearchButton.click(() =>
        @searchNodes({Theme:"Research"})
        )

      $textImportSelection = $("<br><input type=\"file\" id=\"fileinput\"/>").appendTo $container
      $textImportSelection.change(readTextFile)
      # textImportSelection.addEventListener("change", readTextFile, false)
      
      # $sizeByMenu = $("")
      # $.get "/get_all_node_keys", (data)=>
        
      # $

    #TOOLTIPS
      $('#maingraph').append("<div id=\"tooltip\" class=\"tooltiphover\" style=\"display:none\"></div>")

      mouseX = 0
      mouseY = 0
      $(document).mousemove( (e) =>
        widthDigits = $('#maingraph').css("width").length
        heightDigits = $('#maingraph').css("height").length
        mouseX = $('#maingraph').css("width").substring(0,widthDigits-2)-e.pageX 
        mouseY = $('#maingraph').css("height").substring(0,heightDigits-2)-e.pageY
      )

      $('#slidersButton').hover(() =>
        $("#tooltip").empty()
        $("<p style=\"font-size:10px\"><b>SLIDERS:</b> <br> <i>currently allows adjustment of spacing of the nodes</i></p>").appendTo $("#tooltip")
        $("#tooltip").css("right",mouseX-40)
        $("#tooltip").css("bottom", 63)
        # $("#tooltip").css("bottom",mouseY+30)
        $("#tooltip").toggle()
        )

      $('#minimapButton').hover(() =>
        $("#tooltip").empty()
        $("<p style=\"font-size:10px\"><b>MINIMAP:</b> <br> <i>a closeup view of the most recently selected node</i></p>").appendTo $("#tooltip")
        $("#tooltip").css("right",mouseX-40)
        $("#tooltip").css("bottom", 63)
        # $("#tooltip").css("bottom",mouseY+30)
        $("#tooltip").toggle()
        )

      $('#moreoptionsButton').hover(() =>
        $("#tooltip").empty()
        $("<p style=\"font-size:10px\"><b>MORE OPTIONS:</b> <br> <i>additional buttons with different functionality</i></p>").appendTo $("#tooltip")
        $("#tooltip").css("right",mouseX-40)
        $("#tooltip").css("bottom", 63)
        # $("#tooltip").css("bottom",mouseY+30)
        $("#tooltip").toggle()
        )      

      $textImportSelection.mouseover(() =>
        $("#tooltip").empty()
        $("<p style=\"font-size:10px\"><b>CSV Text File Import:</b> <br> <i>Convert your excel spreadsheet to CSV and import. <br> top row must be property names. <br> cells should not contain ','</i></p>").appendTo $("#tooltip")
        $("#tooltip").css("right",mouseX-40)
        $("#tooltip").css("bottom",mouseY+13)
        $("#tooltip").show()
        )
      $textImportSelection.mouseleave(() =>
        $("#tooltip").hide()
        )



    loadAllNodes: (nodes) =>
      @graphModel.putNode node for node in nodes


    expandSelection: () =>
      @dataProvider.getLinkedNodes @selection.getSelectedNodes(), (nodes) =>
          _.each nodes, (node) =>
            @graphModel.putNode node if @dataProvider.nodeFilter node

    searchNodes: (searchQuery) =>
      $.post "/search_nodes", searchQuery, (nodes) =>
        console.log "made it here: " + searchQuery[0]
        for node in nodes
          @graphModel.putNode(node)
          @selection.toggleSelection(node)


    readTextFile = (evt) =>
      file = evt.target.files[0]
      if file
        fReader = new FileReader()
        fReader.onload = (textData) =>
          contents = textData.target.result.split("\n")
          
          #properties are taken as the first row with values in it
          properties = new Array()
          properties = contents[0].split(",")

          #removes property rows with no data
          while properties.length is contents[0].length + 1
            contents.shift()
            properties = contents[0].split(",")

          totalQuery=[]
          i = 1
          while i < contents.length
            tempValues = new Array()
            tempValues = contents[i].split(",")
            unless tempValues.length is contents[i].length + 1
              individualQuery = {}
              j = 0
              while j < properties.length
                unless properties[j] is ""
                  properties[j] = properties[j].replace(" ", "_")
                  individualQuery[properties[j]] = tempValues[j].replace(/'/g,"\\'")
                j++
              # individualQuery = individualQuery.substring(0, individualQuery.length - 2) + "}"
              # totalQuery = totalQuery + individualQuery
              totalQuery.push(individualQuery)
              # @dataController.nodeAdd(individualQuery)
            i++
          # console.log totalQuery
          i=0
          while i<totalQuery.length
            console.log totalQuery[i]
            i++
        fReader.readAsText file
      else
        alert "Failed to load file"
      return



