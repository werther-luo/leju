/*Omiwindow 有关发布活动，活动推荐的modal部分的效果*/
  $(function a(){

    var $modal_a = $('div.modal_a').omniWindow();

    $('.found-button').click(function(e){
      e.preventDefault();
      $modal_a.trigger('show');
    });
    
    $('.close_a-button').click(function(e){
      e.preventDefault();
      $modal_a.trigger('hide');
    });

    $('.close_c-button').click(function(e){
      e.preventDefault();
      $modal_a.trigger('hide');
      alert("发布成功！");
    });

    var $modal_b = $('div.modal_b').omniWindow();

    $('.guess-button').click(function(e){
      e.preventDefault();
      $modal_b.trigger('show');
    });
    
    $('.close_b-button').click(function(e){
      e.preventDefault();
      $modal_b.trigger('hide');
    });

          $('.close_d-button').click(function(e){
      e.preventDefault();
      $modal_b.trigger('hide');
      top.location="recommend.html";

    });

   });