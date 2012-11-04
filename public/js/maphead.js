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

            //成功定位并且页面加载完成后，提交经纬度，获取结果为两个list，将其渲染到地图和右下角弹窗那里去
            var initUrl = 'activities',
                initData = {
                    lng: position.coords.longitude,
                    lat: position.coords.latitude
                },
                initSuccess = function(data){
                    //此处进行渲染
                    console.log("succed in replying data");

                    var activityList = eval(data); //此处待定
                    var adjecntActivities = activityList.adjActs, //取到地图活动 数组
                        relativeActivities = activityList.relaActs,   //取到相关活动 数组
                        i = 0,
                        l = adjecntActivities.length,
                        template = $('#tpl-infoWindow').html();   //用户渲染infoWindow的函数


                    for (; i < l; i++) {
                        var infoWindow = Mustache.to_html(template, 
                            {
                                time_start: adjecntActivities[i].time_start,
                                content: adjecntActivities[i].content,
                                creator_name: adjecntActivities[i].creator_name
                            });
                        
                        map.addMarker({
                            lat: adjecntActivities[i].lat,
                            lng: adjecntActivities[i].lng,
                            title: adjecntActivities[i].title,
                            infoWindow: {
                                content: infoWindow
                            }
                        });
                    }

                },
                dataType = 'JSON';

            $.ajax({
                type: 'GET',
                url: initUrl,
                data: initData,
                success: initSuccess,
                dataType: dataType
            });


            // Create a new client to connect to Faye
            var client = new Faye.Client('http://localhost:9292/faye');
            // Subscribe to the public channel
            var public_subscription = client.subscribe('/activity/public', function(data) {
              console.log("from the server: " + data.acts);
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
                        // alert($('#activity-name-input').val());
                        // alert($('#date-input').val());
                        // alert($('#activity-type-input').val());
                        // alert($('#activity-number-input').val());
                        // alert($('#activity-description-input').val());
                        // alert(e.latLng.lat() + ', ' + e.latLng.lng());


                        var url = 'activities',
                            data = {
                                title : $('#activity-name-input').val(),
                                startTime: $('#start-time').val(),
                                endTime : $('#end-time').val(),
                                type : $('#type-input').val(),
                                peopleNum: $('#activity-number-input').val(),
                                content: $('#activity-description-input').val(),
                                ps : $('#activity-ps-input').val(),
                                lat:e.latLng.lat(),
                                lng:e.latLng.lng()
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