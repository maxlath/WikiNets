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

#TOOLTIPS
      $('#maingraph').append("<div id=\"tooltip\" class=\"tooltiphover\" style=\"display:none\"></div>")

      mouseX = 0
      mouseY = 0
      $(document).mousemove( (e) =>
        widthDigits = $('#maingraph').css("width").length
        # heightDigits = $('#maingraph').css("height").length
        mouseX = $('#maingraph').css("width").substring(0,widthDigits-2)-e.pageX 
        # mouseY = $('#maingraph').css("height").substring(0,heightDigits-2)-e.pageY
      )

      $('#slidersButton').hover(() =>
        $("#tooltip").empty()
        $("<p style=\"font-size:10px\"><b>SLIDERS:</b> <br> <i>currently allows adjustment of spacing of the nodes</i></p>").appendTo $("#tooltip")
        $("#tooltip").css("right",mouseX-30)
        # $("#tooltip").css("bottom",mouseY+30)
        $("#tooltip").toggle()
        )

      $('#minimapButton').hover(() =>
        $("#tooltip").empty()
        $("<p style=\"font-size:10px\"><b>MINIMAP:</b> <br> <i>a closeup view of the most recently selected node</i></p>").appendTo $("#tooltip")
        $("#tooltip").css("right",mouseX-30)
        # $("#tooltip").css("bottom",mouseY+30)
        $("#tooltip").toggle()
        )

      $('#moreoptionsButton').hover(() =>
        $("#tooltip").empty()
        $("<p style=\"font-size:10px\"><b>MORE OPTIONS:</b> <br> <i>additional buttons with different functionality</i></p>").appendTo $("#tooltip")
        $("#tooltip").css("right",mouseX-30)
        # $("#tooltip").css("bottom",mouseY+30)
        $("#tooltip").toggle()
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
