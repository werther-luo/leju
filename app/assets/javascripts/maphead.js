var map;
    $(document).ready(function(){
      var map = new GMaps({
        div: '#map',
        lat: -12.043333,
        lng: -77.028333,

        
      });



      GMaps.geolocate({

        success: function(position){
          

          map.setCenter(position.coords.latitude, position.coords.longitude);

     
          map.addMarker({
        lat: position.coords.latitude,
        lng: position.coords.longitude,
        title: 'Marker with InfoWindow',
        infoWindow: {
          content: '<div><table><tr><td rowspan="2"><img src="Pictures/艺术学院.jpg"></td><td><a href="#">&nbsp;&nbsp;&nbsp;艺术学院</a></td></tr><tr><td></td><td></td></tr></table></br><a href="#">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;第九届校园艺术节将于9月20日盛大开幕，本次艺术节包括了绘画比赛，海报设计大赛，K歌大赛等项目，快来报名参加吧！</a></br></br>30分钟前<a class="pull-right" style="display:inline-block">分享(30)</a><a class="pull-right" style="display:inline-block">转发(30)&nbsp;&nbsp;&nbsp;</a><a class="pull-right" style="display:inline-block">参加(30)&nbsp;&nbsp;&nbsp;</a></div>'
        }
        
        
      });

        /*
  defaultMarker=map.addMarker({
        lat: position.coords.latitude,
        lng: position.coords.longitude,
        
        details: {
          database_id: 42,
          author: 'HPNeo'
        },
        click: function(e){
          if(console.log)
            console.log(e);
          alert('We can design the mouse clicked function.');
        }
      });
        */

          
/*
  map.addMarker({
        lat: position.coords.latitude,
        lng: position.coords.longitude,
        title: 'Marker with InfoWindow',
        infoWindow: {
          content: '<p>HTML Content HTML Content HTML Content HTML Content</p>'
        }
      });*/


  /* Another Marker
          map.drawOverlay({
        lat: position.coords.latitude,
        lng: position.coords.longitude,
        content: '<div class="overlay" style="font-size:12px;line-height:15px;width:120px;">This is a kind of mark.We can add more description here.  </div>'
      });*/
        },

        error: function(error){
          alert('Geolocation failed: '+error.message);
        },
        not_supported: function(){
          alert("Your browser does not support geolocation");
        },
        always: function(){
          alert("Done!");
        }
      });  
      
    });

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

    var $modal_b = $('div.modal_b').omniWindow();

    $('.guess-button').click(function(e){
      e.preventDefault();
      $modal_b.trigger('show');
    });
    
    $('.close_b-button').click(function(e){
      e.preventDefault();
      $modal_b.trigger('hide');
    });

   });