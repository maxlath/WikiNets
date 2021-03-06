// Generated by CoffeeScript 1.6.3
(function() {
  define([], function() {
    var DataController;
    return DataController = (function() {
      function DataController() {}

      DataController.prototype.init = function(instances) {
        return this.graphModel = instances["GraphModel"];
      };

      DataController.prototype.nodeAdd = function(node) {
        throw "must implement nodeAdd for your data controller";
      };

      DataController.prototype.nodeDelete = function(node) {
        throw "must implement nodeDelete for your data controller";
      };

      DataController.prototype.nodeEdit = function(oldNode, newNode) {
        throw "must implement nodeEdit for your data controller";
      };

      DataController.prototype.linkAdd = function(link) {
        throw "must implement linkAdd for your data controller";
      };

      DataController.prototype.linkDelete = function(link) {
        throw "must implement linkDelete for your data controller";
      };

      DataController.prototype.linkEdit = function(oldLink, newLink) {
        throw "must implement linkEdit for your data controller";
      };

      DataController.prototype.ajax = function(url, data, callback) {
        return $.ajax({
          url: url,
          data: data,
          success: callback
        });
      };

      return DataController;

    })();
  });

}).call(this);
