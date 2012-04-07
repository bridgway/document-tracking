(function() {
  var Alice,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Alice = (function() {
    var _this = this;

    function Alice() {}

    Alice.load = function(config) {
      this.el = $(config['container']);
      this.el.addClass('alice');
      this.pages = new Alice.Pages;
      this.pages.on('reset', this.drawPages, this);
      this.pages.on('add', this.drawPage, this);
      this.pages.configure(config);
      this.pages.fetch();
      this.setupBindings();
      this.pages.first().set({
        current: true
      });
      return this.current = this.pages.first();
    };

    Alice.drawImage = function(url) {
      return $("<img class='thumb' src='" + url + "' />");
    };

    Alice.drawPage = function(page) {
      var pageView;
      pageView = new Alice.PageView(page);
      pageView.render();
      this.el.append(pageView.el);
      return page.set({
        view: pageView
      });
    };

    Alice.drawPages = function() {
      var page, _i, _len, _ref, _results;
      _ref = this.pages.models;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        page = _ref[_i];
        _results.push(this.drawPage(page));
      }
      return _results;
    };

    Alice.checkCurrent = function() {
      var $thumb, containerPadding, containerTop, currentIndex, pos;
      $thumb = Alice.current.view.$el;
      containerTop = Alice.el.offset().top;
      containerPadding = parseInt(Alice.el.css('padding'));
      pos = $thumb.offset().top - (containerTop - containerPadding);
      if (pos <= -$thumb.height()) {
        currentIndex = Alice.pages.indexOf(Alice.current);
        return Alice.setCurrent(Alice.pages.at(currentIndex + 1));
      } else if (pos >= $thumb.height()) {
        currentIndex = Alice.pages.indexOf(Alice.current);
        return Alice.setCurrent(Alice.pages.at(currentIndex - 1));
      }
    };

    Alice.scrollToCurrent = function() {
      var containerTop;
      containerTop = $(this.el).scrollTop();
      return $(this.el).animate({
        scrollTop: containerTop + this.current.view.$el.position().top - 10
      });
    };

    Alice.setCurrent = function(page) {
      Alice.current.set({
        current: false
      });
      page.set({
        current: true
      });
      return Alice.current = page;
    };

    Alice.setupBindings = function() {
      return this.el.on({
        'scroll': this.checkCurrent
      });
    };

    return Alice;

  }).call(this);

  Alice.Page = (function(_super) {

    __extends(Page, _super);

    function Page() {
      Page.__super__.constructor.apply(this, arguments);
    }

    return Page;

  })(Backbone.Model);

  Alice.PageView = (function(_super) {

    __extends(PageView, _super);

    function PageView() {
      this.imageTag = __bind(this.imageTag, this);
      this.currentChanged = __bind(this.currentChanged, this);
      this.handleClick = __bind(this.handleClick, this);
      PageView.__super__.constructor.apply(this, arguments);
    }

    PageView.prototype["class"] = "thumb";

    PageView.prototype.template = _.template("<img class='thumb' src='<%= url %>' />");

    PageView.prototype.events = {
      "dragstart img": function(ev) {
        return ev.preventDefault();
      },
      "click img": "handleClick"
    };

    PageView.prototype.handleClick = function(ev) {
      Alice.setCurrent(this.model);
      return Alice.scrollToCurrent();
    };

    PageView.prototype.initialize = function(page) {
      this.model = page;
      this.model.view = this;
      return this.model.on('change:current', this.currentChanged, this);
    };

    PageView.prototype.currentChanged = function(page, changedTo) {
      if (changedTo === true) {
        return this.imageTag().addClass('current');
      } else {
        return this.imageTag().removeClass('current');
      }
    };

    PageView.prototype.imageTag = function() {
      return this.$el.find('img');
    };

    PageView.prototype.render = function() {
      $(this.el).html(this.template(this.model.toJSON()));
      return this;
    };

    return PageView;

  })(Backbone.View);

  Alice.Pages = (function(_super) {

    __extends(Pages, _super);

    function Pages() {
      Pages.__super__.constructor.apply(this, arguments);
    }

    Pages.prototype.model = Alice.Page;

    Pages.prototype.configure = function(config) {
      this.pageURLTemplate = _.template(config['pages']);
      return this.numberOfPages = config['numPages'];
    };

    Pages.prototype.generateURL = function(size, page) {
      var url, vars;
      vars = {
        size: size,
        page: page
      };
      return url = this.pageURLTemplate(vars);
    };

    Pages.prototype.fetch = function() {
      var i, pages, url;
      i = 1;
      pages = [];
      while (i <= this.numberOfPages) {
        url = this.generateURL('700x', i);
        pages.push(new Alice.Page({
          url: url
        }));
        i += 1;
      }
      return this.reset(pages);
    };

    return Pages;

  })(Backbone.Collection);

  window.Alice = Alice;

}).call(this);
