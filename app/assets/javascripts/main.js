var overlaps = (function () {
    function getPositions( elem ) {
        var pos, width, height;
        pos = $( elem ).position();
        width = $( elem ).width();
        height = $( elem ).height();
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
    $articles.each(function(){
      if($(this).data('bias-level') > rightMostBias) {
        rightMostBias = $(this).data('bias-level');
      }
      if($(this).data('bias-level') < leftMostBias) {
        leftMostBias = $(this).data('bias-level');
      }
    });
    var currTop = 0;
    $articles.each(function(){
      var $toPlace = $(this);
      var left = workingWidth * ($(this).data('bias-level') - leftMostBias)/(rightMostBias - leftMostBias);
      $toPlace.css({ top: currTop, left: left }).addClass('placed');
      // if overlap, move top
      $articles.filter('.placed').not(this).reverse().each(function(){
        if(overlaps($toPlace, this)) {
          currTop += $(this).outerHeight() + vMargin;
          $toPlace.css('top', currTop);
          return false;
        }
      });
    });
  }).trigger('dolayout');

  $(window).on('load resize', function(){
    $('.article-bias-graph').trigger('dolayout');
  });
});