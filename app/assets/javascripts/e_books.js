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
      this.max_page_item = attr.max_page_item || 10;
      this.page_item_placeholder_tmpl = attr.page_item_placeholder_tmpl || "";
      this.page_item_label_tmpl = attr.page_item_label_tmpl || "";

      this.render();
    },

    render: function(){
      var self = this;
      var tmpl = _.template(this.page_item_tmpl);
      var page_item_label_tmpl = _.template(this.page_item_label_tmpl);
      var pages = _range(this.page_count, this.current_page, this.max_page_item);

      this.$page_container.empty();

      _.each(pages, function(index){
        self.$page_container.append(tmpl({
          page_index: index, 
          selected: self.current_page === index ? "active" : ""
        }));
      });

      if(pages[0] > 1) {
        self.$page_container.prepend(this.page_item_placeholder_tmpl).prepend(page_item_label_tmpl({
          page_index: this.current_page - 1,
          page_label: '上一页'
        })).prepend(page_item_label_tmpl({
          page_index: 1,
          page_label: '最新'
        }));
      }

      if(pages[pages.length - 1] < this.page_count) {
        self.$page_container.append(this.page_item_placeholder_tmpl).append(page_item_label_tmpl({
          page_index: this.current_page + 1,
          page_label: '下一页'
        })).append(page_item_label_tmpl({
          page_index: this.page_count,
          page_label: '最旧'
        }));
      }
    }
  });

  function _range(page_count, current_page, page_limit) {
    var page_limit_half = parseInt((page_limit - 1) / 2);  // 一半的距离
    var page_left_remain = current_page - 1;         // 左边还剩余的距离
    var page_right_remain = page_count - current_page;         // 右边还剩余的距离
    var page_left = Math.min(page_limit_half, page_left_remain);  // 左边应该有多少距离
    var page_right = Math.min(page_limit_half + (page_limit - 1) % 2, page_right_remain);  // 右边的距离
    var page_remain = page_limit - 1 - page_left - page_right;

    if(page_remain > 0) {
      if(current_page - page_left > 1) {
        page_left += Math.min(page_remain, current_page - page_left);
      }
      
      if(current_page + page_right < page_count) {
        page_right += Math.min(page_remain, page_count - current_page - page_right);
      }
    }

    return _.range(current_page - page_left, current_page + page_right + 1);
  }

  window.PaginationView = PaginationView;
})(Backbone, jQuery, _);
