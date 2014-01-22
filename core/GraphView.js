// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define([], function() {
    var GraphView, LinkFilter, _ref, _ref1;
    LinkFilter = (function(_super) {
      __extends(LinkFilter, _super);

      function LinkFilter() {
        _ref = LinkFilter.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      LinkFilter.prototype.initialize = function() {
        return this.set("threshold", 0);
      };

      LinkFilter.prototype.filter = function(links) {
        var _this = this;
        return _.filter(links, function(link) {
          return link.strength > _this.get("threshold");
        });
      };

      LinkFilter.prototype.connectivity = function(value) {
        if (value) {
          return this.set("threshold", value);
        } else {
          return this.get("threshold");
        }
      };

      return LinkFilter;

    })(Backbone.Model);
    return GraphView = (function(_super) {
      __extends(GraphView, _super);

      function GraphView() {
        _ref1 = GraphView.__super__.constructor.apply(this, arguments);
        return _ref1;
      }

      GraphView.prototype.init = function(instances) {
        this.model = instances["GraphModel"];
        this.model.on("change", this.update.bind(this));
        this.render();
        return instances["Layout"].addCenter(this.el);
      };

      GraphView.prototype.initialize = function(options) {
        this.linkFilter = new LinkFilter(this);
        return this.listenTo(this.linkFilter, "change:threshold", this.update);
      };

      GraphView.prototype.render = function() {
        var currentZoom, defs, initialWindowHeight, initialWindowWidth, linkContainer, nodeContainer, svg, translateLock, workspace, zoom, zoomCapture,
          _this = this;
        initialWindowWidth = $(window).width();
        initialWindowHeight = $(window).height();
        this.initialWindowWidth = initialWindowWidth;
        this.initialWindowHeight = initialWindowHeight;
        this.force = d3.layout.force().size([initialWindowWidth, initialWindowHeight]).charge(-500).gravity(0.2);
        this.linkStrength = function(link) {
          return (link.strength - _this.linkFilter.get("threshold")) / (1.0 - _this.linkFilter.get("threshold"));
        };
        this.force.linkStrength(this.linkStrength);
        svg = d3.select(this.el).append("svg:svg").attr("pointer-events", "all");
        zoom = d3.behavior.zoom();
        this.zoom = zoom;
        defs = svg.append("defs");
        defs.append("marker").attr("id", "Triangle").attr("viewBox", "0 0 20 15").attr("refX", "15").attr("refY", "5").attr("markerUnits", "userSpaceOnUse").attr("markerWidth", "20").attr("markerHeight", "15").attr("orient", "auto").append("path").attr("d", "M 0 0 L 10 5 L 0 10 z");
        defs.append("marker").attr("id", "Triangle2").attr("viewBox", "0 0 20 15").attr("refX", "-5").attr("refY", "5").attr("markerUnits", "userSpaceOnUse").attr("markerWidth", "20").attr("markerHeight", "15").attr("orient", "auto").append("path").attr("d", "M 10 0 L 0 5 L 10 10 z");
        zoomCapture = svg.append("g");
        zoomCapture.append("svg:rect").attr("width", "100%").attr("height", "100%").style("fill-opacity", "0%");
        translateLock = false;
        currentZoom = void 0;
        this.force.drag().on("dragstart", function() {
          translateLock = true;
          return currentZoom = zoom.translate();
        }).on("dragend", function() {
          zoom.translate(currentZoom);
          return translateLock = false;
        });
        zoomCapture.call(zoom.on("zoom", function() {
          if (translateLock) {
            return;
          }
          return workspace.attr("transform", "translate(" + d3.event.translate + ") scale(" + d3.event.scale + ")");
        })).on("dblclick.zoom", null);
        workspace = zoomCapture.append("svg:g");
        this.workspace = workspace;
        linkContainer = workspace.append("svg:g").classed("linkContainer", true);
        nodeContainer = workspace.append("svg:g").classed("nodeContainer", true);
        $(this.el).bind("contextmenu", function(e) {
          return false;
        });
        $(this.el).mousedown(function(e) {
          if (e.which === 3) {
            return _this.trigger("view:rightclick");
          } else {
            return _this.trigger("view:click");
          }
        });
        return this;
      };

      GraphView.prototype.update = function() {
        var clickSemaphore, filteredLinks, link, linkEnter, links, node, nodeEnter, nodes,
          _this = this;
        this.addCentering(this.workspace, this.zoom);
        nodes = this.model.get("nodes");
        links = this.model.get("links");
        filteredLinks = this.linkFilter ? this.linkFilter.filter(links) : links;
        this.force.nodes(nodes).links(filteredLinks).start();
        link = this.linkSelection = d3.select(this.el).select(".linkContainer").selectAll(".link").data(filteredLinks, this.model.get("linkHash"));
        linkEnter = link.enter().append("line").attr("class", "link").attr('marker-end', function(link) {
          if (link.direction === 'forward' || link.direction === 'bidirectional') {
            return 'url(#Triangle)';
          }
        }).attr('marker-start', function(link) {
          if (link.direction === 'backward' || link.direction === 'bidirectional') {
            return 'url(#Triangle2)';
          }
        });
        this.force.start();
        link.exit().remove();
        link.attr("stroke-width", function(link) {
          return 5 * (_this.linkStrength(link));
        });
        node = this.nodeSelection = d3.select(this.el).select(".nodeContainer").selectAll(".node").data(nodes, this.model.get("nodeHash"));
        nodeEnter = node.enter().append("g").attr("class", "node");
        nodeEnter.append("text").attr("dx", 12).attr("dy", ".35em").text(function(d) {
          return _this.findText(d);
        });
        nodeEnter.append("circle").attr("r", 5).attr("cx", 0).attr("cy", 0);
        clickSemaphore = 0;
        nodeEnter.on("click", function(datum, index) {
          var savedClickSemaphore, shifted;
          if (d3.event.defaultPrevented) {
            return;
          }
          if (d3.event.shiftKey) {
            shifted = true;
          } else {
            shifted = false;
          }
          datum.fixed = true;
          clickSemaphore += 1;
          savedClickSemaphore = clickSemaphore;
          return setTimeout((function() {
            if (clickSemaphore === savedClickSemaphore) {
              if (shifted) {
                _this.trigger("enter:node:shift:click", datum);
              }
              _this.trigger("enter:node:click", datum);
              return datum.fixed = false;
            } else {
              clickSemaphore += 1;
              return datum.fixed = false;
            }
          }), 250);
        }).on("dblclick", function(datum, index) {
          return _this.trigger("enter:node:dblclick", datum);
        });
        this.trigger("enter:node", nodeEnter);
        this.trigger("enter:link", linkEnter);
        node.exit().remove();
        return this.force.on("tick", function() {
          link.attr("x1", function(d) {
            return d.source.x;
          }).attr("y1", function(d) {
            return d.source.y;
          }).attr("x2", function(d) {
            return d.target.x;
          }).attr("y2", function(d) {
            return d.target.y;
          });
          return node.attr("transform", function(d) {
            return "translate(" + d.x + "," + d.y + ")";
          });
        });
      };

      GraphView.prototype.addCentering = function(workspace, zoom) {
        var height, translateParams, width;
        width = $(this.el).width();
        height = $(this.el).height();
        translateParams = [0, 0];
        return this.on("enter:node:shift:click", function(node) {
          var scale, x, y;
          x = node.x;
          y = node.y;
          scale = zoom.scale();
          translateParams = [(width / 2 - x) / scale, (height / 2 - y) / scale];
          zoom.translate([translateParams[0], translateParams[1]]);
          return workspace.transition().ease("linear").attr("transform", "translate(" + translateParams + ") scale(" + scale + ")");
        });
      };

      GraphView.prototype.forwardAlpha = function(layout, alpha, max) {
        var i, _results;
        alpha = alpha || 0;
        max = max || 1000;
        i = 0;
        _results = [];
        while (layout.alpha() > alpha && i++ < max) {
          _results.push(layout.tick());
        }
        return _results;
      };

      GraphView.prototype.drawXHairs = function(x, y, obj) {
        obj.append("line").attr("x1", x).attr("x2", x).attr("y1", y - 10).attr("y2", y + 10).attr("stroke-width", 2).attr("stroke", "red");
        return obj.append("line").attr("x1", x + 10).attr("x2", x - 10).attr("y1", y).attr("y2", y).attr("stroke-width", 2).attr("stroke", "red");
      };

      GraphView.prototype.getNodeSelection = function() {
        return this.nodeSelection;
      };

      GraphView.prototype.getLinkSelection = function() {
        return this.linkSelection;
      };

      GraphView.prototype.getForceLayout = function() {
        return this.force;
      };

      GraphView.prototype.getLinkFilter = function() {
        return this.linkFilter;
      };

      GraphView.prototype.findText = function(node) {
        if (node.name != null) {
          return node.name;
        } else if (node.title != null) {
          return node.title;
        } else {
          return '';
        }
      };

      return GraphView;

    })(Backbone.View);
  });

}).call(this);
