/* DO NOT MODIFY. This file was compiled Sun, 18 Mar 2012 12:52:41 GMT from
 * /Users/justin/hacks/documents/coffee/progressbar.coffee
 */

(function() {

  $(function() {
    var ProgressBar;
    ProgressBar = (function() {
      var MAX;

      MAX = 124;

      function ProgressBar(id, draw) {
        if (draw == null) draw = false;
        this.el = $(id);
        this.canvas = Raphael(this.el[0]);
        if (draw) this.draw();
      }

      ProgressBar.prototype.draw = function() {
        var inner, outer;
        this.outerWidth = this.el.width() - 6;
        outer = this.canvas.rect(5, 10, this.outerWidth, 23, 15);
        outer.attr('stroke', '#9EACB0');
        outer.attr('stroke-width', '2');
        inner = this.canvas.rect(10, 14, 0, 15, 10);
        inner.attr('fill', '#9EACB0');
        inner.attr('stroke', '#9EACB0');
        return this.inner = inner;
      };

      ProgressBar.prototype.tick = function() {
        var diff, newWidth, width;
        width = this.inner.attr('width');
        newWidth = width + 20;
        if (newWidth >= MAX) {
          diff = MAX - newWidth;
          return this.inner.attr('width', diff + newWidth);
        } else {
          return this.inner.attr('width', newWidth);
        }
      };

      ProgressBar.prototype.start = function() {
        return this.tick();
      };

      return ProgressBar;

    })();
    return window.ProgressBar = ProgressBar;
  });

}).call(this);
