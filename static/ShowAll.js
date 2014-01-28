// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define([], function() {
    var ShowAll;
    return ShowAll = (function(_super) {
      __extends(ShowAll, _super);

      function ShowAll(options) {
        this.options = options;
        this.loadAllNodes = __bind(this.loadAllNodes, this);
        ShowAll.__super__.constructor.call(this);
      }

      ShowAll.prototype.init = function(instances) {
        this.render();
        this.graphModel = instances["GraphModel"];
        this.dataProvider = instances["local/WikiNetsDataProvider"];
        this.selection = instances["NodeSelection"];
        return instances["Layout"].addPlugin(this.el, this.options.pluginOrder, 'Explorations', true);
      };

      ShowAll.prototype.render = function() {
        var $chooseSelectButton, $clearAllButton, $clearSelectedButton, $deselectAllButton, $selectAllButton, $showAllButton, container,
          _this = this;
        container = $("<div />").addClass("show-all-container").appendTo(this.$el);
        $showAllButton = $("<input type=\"button\" id=\"showAllButton\" value=\"Show All\"></input>").appendTo(container);
        $showAllButton.click(function() {
          return _this.dataProvider.getEverything(_this.loadAllNodes);
        });
        $clearAllButton = $("<input type=\"button\" id=\"clearAllButton\" value=\"Clear All\"></input>").appendTo(container);
        $clearAllButton.click(function() {
          return _this.graphModel.filterNodes(function(node) {
            return false;
          });
        });
        $selectAllButton = $("<input type=\"button\" id=\"selectAllButton\" value=\"Select All\"></input>").appendTo(container);
        $selectAllButton.click(function() {
          return _this.selection.selectAll();
        });
        $deselectAllButton = $("<input type=\"button\" id=\"deselectAllButton\" value=\"Deselect All\"></input>").appendTo(container);
        $deselectAllButton.click(function() {
          return _this.selection.deselectAll();
        });
        $clearSelectedButton = $("<input type=\"button\" id=\"clearSelectedButton\" value=\"Clear Selection\"></input>").appendTo(container);
        $clearSelectedButton.click(function() {
          return _this.selection.removeSelection();
        });
        $chooseSelectButton = $("<input type=\"button\" id=\"chooseSelectButton\" value=\"Choose Selection\"></input>").appendTo(container);
        return $chooseSelectButton.click(function() {
          return _this.selection.removeSelectionCompliment();
        });
      };

      ShowAll.prototype.loadAllNodes = function(nodes) {
        var node, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = nodes.length; _i < _len; _i++) {
          node = nodes[_i];
          _results.push(this.graphModel.putNode(node));
        }
        return _results;
      };

      return ShowAll;

    })(Backbone.View);
  });

}).call(this);
