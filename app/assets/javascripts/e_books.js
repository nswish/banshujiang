(function(Backbone, $, _){
  _.templateSettings = {
      interpolate: /\{\{=(.+?)\}\}/g
  };

  var PaginationView = Backbone.View.extend({
    initialize: function(attr){
      this.page_count = attr.page_count || 0;
      this.current_page = attr.current_page || 0;
      this.page_item_tmpl = attr.page_item_tmpl || "";
      this.$page_container = this.$el.find(attr.page_container);

      this.render();
    },

    render: function(){
      var self = this;
      var tmpl = _.template(this.page_item_tmpl);

      this.$page_container.empty();

      _.each(_.range(this.page_count), function(index){
        self.$page_container.append(tmpl({
          page_index: index+1, 
          selected: self.current_page === index+1 ? "active": ""
        }));
      });

    }
  });

  window.PaginationView = PaginationView;
})(Backbone, jQuery, _);
