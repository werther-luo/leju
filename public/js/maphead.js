/**
 * Created with JetBrains WebStorm.
 * User: werther
 * Date: 12-11-5
 * Time: 下午5:04
 * To change this template use File | Settings | File Templates.
 */
//当html页面加载完毕后再执行该匿名函数
$(function () {
    var template = $('#tpl-infoWindow').html(), //用户渲染infoWindow的函数
        template2 = $('#tpl-activityList').html();


    // Create a new client to connect to Faye
    var client = new Faye.Client('http://222.19.212.41:9292/faye');

    //测试取rails_tag的用户信息
    var current_user_id = document.getElementById("current_user_id");
    console.log("---------current_user:" + current_user_id.value);

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
        div:'#map',
        zoom:18,
        //大连理工大学的经纬度
        lat:38.876,
        lng:121.525
    });

    //进行LBS定位，并将其设置为地图中心
    GMaps.geolocate({
        success:function (position) {
            map.setCenter(position.coords.latitude, position.coords.longitude);

            //成功定位并且页面加载完成后，提交经纬度，获取结果为两个list，将其渲染到地图和右下角弹窗那里去
            var initUrl = 'activities',
                initData = {
                    lng:position.coords.longitude,
                    lat:position.coords.latitude
                },
                initSuccess = function (data) {
                    //此处进行渲染
                    console.log("succed in replying data");

                    var activityList = eval(data); //此处待定
                    var adjecntActivities = activityList.adjActs, //取到地图活动 数组
                        relativeActivities = activityList.relaActs, //取到相关活动 数组
                        ownActivities = activityList.ownActs, //取到参加的活动
                        i = 0,
                        l = adjecntActivities.length,
                        l2 = ownActivities.length;
                    l3 = relativeActivities.length;
                    console.log("There are " + l3);

                    //在地图上添加marker
                    for (i = 0; i < l; i++) {
                        var infoWindow = Mustache.to_html(template,
                            {
                                time_start:adjecntActivities[i].time_start,
                                content:adjecntActivities[i].content,
                                creator_name:adjecntActivities[i].creator_name,
                                id:adjecntActivities[i].id
                            });

                        map.addMarker({
                            lat:adjecntActivities[i].lat,
                            lng:adjecntActivities[i].lng,
                            title:adjecntActivities[i].title,
                            infoWindow:{
                                content:infoWindow
                            }
                        });
                    }

                    var activityListWindow;
                    //在右下角显示活动列表
                    //显示我创建的活动
                    for (i = 0; i < l2; i++) {
                        activityListWindow = Mustache.to_html(template2,
                            {
                                time_start:ownActivities[i].time_start,
                                content:ownActivities[i].content,
                                creator_name:ownActivities[i].creator_name,
                                time_end:ownActivities[i].time_end,
                                title:ownActivities[i].title,
                                address_line:ownActivities[i].address_line,
                                creator_photo:"http://localhost:3000/" + ownActivities[i].creator_photo
                            });

                        // console.log(activityListWindow);
                        $(activityListWindow).appendTo($('#tab1'));
                    }
                    //我参加的活动
                    for (i = 0; i < l3; i++) {
                        activityListWindow = Mustache.to_html(template2,
                            {
                                time_start:relativeActivities[i].time_start,
                                content:relativeActivities[i].content,
                                creator_name:relativeActivities[i].creator_name,
                                time_end:relativeActivities[i].time_end,
                                title:relativeActivities[i].title,
                                address_line:relativeActivities[i].address_line,
                                creator_photo:"http://localhost:3000/" + relativeActivities[i].creator_photo
                            });

                        console.log(activityListWindow);
                        $(activityListWindow).appendTo($('#tab2'));
                    }


                },
                dataType = 'JSON';

            $.ajax({
                type:'GET',
                url:initUrl,
                data:initData,
                success:initSuccess,
                dataType:dataType
            });


            //开使监听广播，通道名称为“/newact/user_id”
            channel = "/newact/" + current_user_id.value;
            console.log("---------channel:" + channel);
            var public_subscription = client.subscribe(channel, function (data) {
                // alert("--" + data.act);
                var newActivity = eval('(' + data.act + ')');
                // alert("--" + newActivity.time_start);
                var infoWindow = Mustache.to_html(template,
                    {
                        time_start:newActivity.time_start,
                        content:newActivity.content,
                        creator_name:newActivity.creator_name
                    });

                map.addMarker({
                    lat:newActivity.lat,
                    lng:newActivity.lng,
                    title:newActivity.title,
                    infoWindow:{
                        content:infoWindow
                    }
                });
                // console.log("from the server: " + data.act);
            });

            //点击参加活动按钮
            $('#attend-activity').live('click', function(e) {
                e.preventDefault();
                console.log('clicked attend button');
                var activity_id = $(this).parent().find('input').val();
                console.log("Click the activity " + activity_id );

                    url = 'user_ac_relas',
                    data = {
                        activity_id:activity_id
                    },
                    success = function (data) {
                        //把新参加的活动显示到右下角列表中去
                        var activity = eval(data); //此处待定

                        activityWindow = Mustache.to_html(template2,
                            {
                                time_start: activity.time_start,
                                content: activitycontent,
                                creator_name: activity.creator_name,
                                time_end: activity.time_end,
                                title: activity.title,
                                address_line: activity.address_line,
                                creator_photo:"http://localhost:3000/" + activity.creator_photo
                            });

                        $(activityWindow).appendTo($('#tab2'));
                        alert("您已经成功参加该活动，点击右下角可以查看");

                        //把这个活动的infoWindow中参加按钮改成已参加
//                        $
                    },
                    dataType = 'JSON';

                $.ajax({
                    type:'POST',
                    url:url,
                    data:data,
                    success:success,
                    dataType:dataType
                });

            });

        },

        error:function (error) {
            alert('定位失败: ' + error.message);
        },

        not_supported:function () {
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
                        title:'刚刚添加的活动,刷新页面后可以查看详情'
                    });
                    $modal_a.trigger('show');

                    $('#activity-submit').click(function () {
                        var url = 'activities',
                            data = {
                                title:$('#activity-name-input').val(),
                                startTime:$('#start-time').val(),
                                endTime:$('#end-time').val(),
                                type:$('#type-input').val(),
                                peopleNum:$('#activity-number-input').val(),
                                content:$('#activity-description-input').val(),
                                ps:$('#activity-ps-input').val(),
                                lat:e.latLng.lat(),
                                lng:e.latLng.lng()
                            },
                            newSuccess = function () {
                                console.log("It begins");
                                // $modal_a.trigger('hide');
                                // alert("活动创建成功");
                            },
                            dataType = 'JSON';

                        $.ajax({
                            type:'POST',
                            url:url,
                            data:data,
                            success:newSuccess,
                            dataType:dataType
                        });

                        $modal_a.trigger('hide');
                        alert("活动创建成功");
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

