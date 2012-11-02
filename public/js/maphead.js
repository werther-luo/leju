//当html页面加载完毕后再执行该匿名函数
$(function () {
    //初始化‘新建活动’弹窗所需要的变量
    var $modal_a = $('div.modal_a').omniWindow();

    //一下为弹窗事件的绑定
    $('.found-button').click(function (e) {
        e.preventDefault();
        $modal_a.trigger('show');
    });

    $('.close_a-button').click(function (e) {
        e.preventDefault();
        $modal_a.trigger('hide');
    });

    var $modal_b = $('div.modal_b').omniWindow();

    $('.guess-button').click(function (e) {
        e.preventDefault();
        $modal_b.trigger('show');
    });

    $('.close_b-button').click(function (e) {
        e.preventDefault();
        $modal_b.trigger('hide');
    });


    var map = new GMaps({
        div: '#map',
        zoom: 18,
        //大连理工大学的经纬度
        lat: 38.876,
        lng: 121.525
    });

    //进行LBS定位，并将其设置为地图中心
    GMaps.geolocate({
        success: function (position) {
            map.setCenter(position.coords.latitude, position.coords.longitude);

            map.addMarker({
//        lat:position.coords.latitude,
//        lng:position.coords.longitude,
                lat: 38.876,
                lng: 121.525,
                title: 'Marker with InfoWindow',
                infoWindow: {
                    content: '<div><table><tr><td rowspan="2"><img src="Pictures/艺术学院.jpg"></td><td><a href="#">&nbsp;&nbsp;&nbsp;艺术学院</a></td></tr><tr><td></td><td></td></tr></table></br><a href="#">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;第九届校园艺术节将于9月20日盛大开幕，本次艺术节包括了绘画比赛，海报设计大赛，K歌大赛等项目，快来报名参加吧！</a></br></br>30分钟前<a class="pull-right" style="display:inline-block">分享(30)</a><a class="pull-right" style="display:inline-block">转发(30)&nbsp;&nbsp;&nbsp;</a><a class="pull-right" style="display:inline-block">参加(30)&nbsp;&nbsp;&nbsp;</a></div>'
                }
            });
        },

        error: function (error) {
            alert('定位失败: ' + error.message);
        },

        not_supported: function () {
            alert("您的浏览器并不支持定位");
        },

        always:function () {
//            alert("Done!");
        }
    });

    //添加marker
//    map.addMarker({
////        lat:position.coords.latitude,
////        lng:position.coords.longitude,
//        lat: 38.876,
//        lng: 121.525,
//        title: 'Marker with InfoWindow',
//        infoWindow: {
//            content: '<div><table><tr><td rowspan="2"><img src="Pictures/艺术学院.jpg"></td><td><a href="#">&nbsp;&nbsp;&nbsp;艺术学院</a></td></tr><tr><td></td><td></td></tr></table></br><a href="#">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;第九届校园艺术节将于9月20日盛大开幕，本次艺术节包括了绘画比赛，海报设计大赛，K歌大赛等项目，快来报名参加吧！</a></br></br>30分钟前<a class="pull-right" style="display:inline-block">分享(30)</a><a class="pull-right" style="display:inline-block">转发(30)&nbsp;&nbsp;&nbsp;</a><a class="pull-right" style="display:inline-block">参加(30)&nbsp;&nbsp;&nbsp;</a></div>'
//        }
//    });


    map.drawRoute({
        origin:[38.876, 121.525],
        destination:[38.876, 122.73],
        travelMode:'driving',
        strokeColor:'#131540',
        strokeOpacity:0.6,
        strokeWeight:6,
        step:function (e) {
            console.log(e.step_number + ": " + e.instructions);
        }
    });

    map.setContextMenu({
        control:'map',
        options:[
            {
                title:'新增活动',
                name:'add_marker',
                action:function (e) {
                    this.addMarker({
                        lat:e.latLng.lat(),
                        lng:e.latLng.lng(),
                        title:'刚刚添加的活动'
                    });
                    $modal_a.trigger('show');

                    $('#activity-submit').click(function () {
                        alert($('#activity-name-input').val());
                        alert($('#date-input').val());
                        alert($('#activity-type-input').val());
                        alert($('#activity-number-input').val());
                        alert($('#activity-description-input').val());
                        alert(e.latLng.lat() + ', ' + e.latLng.lng());


                        var url = 'activities/new',
                            data = {

                            },
                            success = function(){
                                alert("活动创建成功");
                            },
                            dataType = 'JSON';

                        $.ajax({
                            type: 'POST',
                            url: url,
                            data: data,
                            success: success,
                            dataType: dataType
                        });
                    });
                }
            },
            {
                title:'以此处为中心',
                name:'center_here',
                action:function (e) {
                    this.setCenter(e.latLng.lat(), e.latLng.lng());
                }
            }
        ]
    });
});