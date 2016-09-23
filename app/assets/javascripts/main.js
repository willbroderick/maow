var overlaps = (function () {
    function getPositions( elem ) {
        var pos, width, height;
        pos = $( elem ).position();
        width = $( elem ).outerWidth();
        height = $( elem ).outerHeight();
        return [ [ pos.left, pos.left + width ], [ pos.top, pos.top + height ] ];
    }

    function comparePositions( p1, p2 ) {
        var r1, r2;
        r1 = p1[0] < p2[0] ? p1 : p2;
        r2 = p1[0] < p2[0] ? p2 : p1;
        return r1[1] > r2[0] || r1[0] === r2[0];
    }

    return function ( a, b ) {
        var pos1 = getPositions( a ),
            pos2 = getPositions( b );
        return comparePositions( pos1[0], pos2[0] ) && comparePositions( pos1[1], pos2[1] );
    };
})();

$.fn.reverse = [].reverse;

$(function($){

  $('.article-bias-graph').on('dolayout', function(){
    // position elements
    var $articles = $(this).find('.article').css({ top:'', left:'' }).removeClass('placed');
    var vMargin = parseInt($articles.first().css('margin-left'));
    var workingWidth = $(this).width() - $articles.first().outerWidth() - vMargin*2;
    var leftMostBias = 100, rightMostBias = 0;
    var columns = {};
    $articles.each(function(){
      // pop each article in its bias-column
      if(typeof columns[$(this).data('bias-level')] == 'undefined') {
        columns[$(this).data('bias-level')] = { articles: [], currTop: 0 };
      }
      columns[$(this).data('bias-level')].articles.push(this);
      // find visual bounds
      if($(this).data('bias-level') > rightMostBias) {
        rightMostBias = $(this).data('bias-level');
      }
      if($(this).data('bias-level') < leftMostBias) {
        leftMostBias = $(this).data('bias-level');
      }
    });
    var totalToPlace = $articles.length;
    var placed = [];
    while(totalToPlace > 0) {
      for(var key in columns) {
        if(columns[key].articles.length > 0) {
          var $toPlace = $(columns[key].articles.shift());
          totalToPlace--;
          $toPlace.css({
            top: columns[key].currTop,
            left: workingWidth * (key - leftMostBias)/(rightMostBias - leftMostBias)
          }).addClass('placed');
          // cache some numeric values we'll need later
          $toPlace.data({
            itop: columns[key].currTop,
            iheight: $toPlace.outerHeight(true)
          });
          $(placed).each(function(index){
            if(overlaps($toPlace, this)) {
              columns[key].currTop = Math.max(
                $(this).data('itop') + $(this).data('iheight'),
                columns[key].currTop
              );
              // set new position
              $toPlace.css('top', columns[key].currTop);
              $toPlace.data('itop', columns[key].currTop);
            }
          });
          columns[key].currTop += $toPlace.data('iheight');
          placed.unshift($toPlace);
        }
      }
    }
  }).trigger('dolayout');

  $(window).on('load resize', function(){
    $('.article-bias-graph').trigger('dolayout');
  });
});