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
        template2 = $('#tpl-activityList').html(),	//用于渲染右下角活动列表
		template3 = $('#tpl-chatWindow').html(),	//用于渲染聊天框
		template4 = $('#tpl-chatItem').html(),	//用户渲染聊天条目
		basePath = $('#host_ip').val();
	
	console.log("base path is:" + basePath);

    // Create a new client to connect to Faye
    var client = new Faye.Client('http://' + basePath + ':9292/faye');

    //测试取rails_tag的用户信息
    var current_user_id = document.getElementById("current_user_id");
    console.log("---------current_user:" + current_user_id.value);
    var current_user_name = document.getElementById("current_user_name");
    console.log("---------current_user:" + current_user_name.value);
	

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
                        relativeActivities = activityList.relaActs, //取到用户参加的活动 数组
                        ownActivities = activityList.ownActs, //取到用户创建的活动
                        i = 0,
                        l = adjecntActivities.length,
                        l2 = ownActivities.length;
                    	l3 = relativeActivities.length,
						activityType = '',
						markerIcon = '';

                    //在地图上添加marker
                    for (i = 0; i < l; i++) {
						// TODO 根据活动类型确定marker的颜色
						activityType = adjecntActivities[i].type;
						switch(activityType){
							case '电子竞技': markerIcon = 'http://www.google.com/intl/en_us/mapfiles/ms/micons/yellow-dot.png';
							break;
							case '美食': markerIcon = 'http://www.google.com/intl/en_us/mapfiles/ms/micons/blue-dot.png';
							break;
							case '运动': markerIcon = 'http://www.google.com/intl/en_us/mapfiles/ms/micons/green-dot.png';
							break;
							case '旅行': markerIcon = 'http://www.google.com/intl/en_us/mapfiles/ms/micons/red-dot.png';
							break;	
							case '文艺': markerIcon = 'http://www.google.com/intl/en_us/mapfiles/ms/micons/black-dot.png';
							break;	
						}

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
							icon: markerIcon,
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
								id: ownActivities[i].id,
                                creator_photo:"http://" + basePath + ":3000/" + ownActivities[i].creator_photo
                            });

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
								id: ownActivities[i].id,
                                creator_photo:"http://" + basePath + ":3000/" + relativeActivities[i].creator_photo
                            });

                        // console.log(activityListWindow);
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
            client.subscribe(channel, function (data) {
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
                var activity_id = $(this).parent().find('input').val(),
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
                                content: activity.content,
                                creator_name: activity.creator_name,
                                time_end: activity.time_end,
                                title: activity.title,
                                address_line: activity.address_line,
								id: activity.id,
                                creator_photo: "http://" + basePath + ":3000/" + activity.creator_photo
                            });

                        $(activityWindow).appendTo($('#tab2'));
                        alert("您已经成功参加该活动，点击右下角可以查看");

                        // TODO 把这个活动的infoWindow中参加按钮改成已参加
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
			
			var activity_id = '';
			//点击查看详情之后出现聊天框
            $('#chat-open').live('click', function(e) {
                e.preventDefault();
                console.log('clicked chat button');
                var activityElement = $(this).parent().find('input'),
					activity_id = activityElement.val(),
                    url = 'message/index',
                    data = {
                        activity_id: activity_id
                    },
                    success = function (data) {
						//成功获取聊天记录之后弹出聊天框
				        var chatWindow = Mustache.to_html(template3,{
		                	id: activity_id
		                });
					
						$(chatWindow).appendTo($('#chat-place'));
						
						//TODO 显示历史聊天记录
                    },
                    dataType = 'JSON';
				
				console.log(activity_id);
				
			    $.ajax({
                	type:'GET',
                    url:url,
                    data:data,
                    success:success,
                    dataType:dataType
                });
				
				//监听关闭聊天框 
				// $('#chat-close').live('click', function(e) {
				// 	
				// };
						
				//接受聊天的广播
				client.subscribe('/chatmsg/' + activity_id, function( data ){
					console.log("subscribe the message." + data.comment);
					//把聊天内容写入
                    var chatItem = Mustache.to_html(template4,{
                            user_name: current_user_name.value,
							comment: data.comment
                    });
					var placeID = '#place' + activity_id;
					var commentBody = $(placeID).parent().find('table#message');
					$(chatItem).appendTo(commentBody);	
				});	
				
				//聊天部分
				$('#chat-comment').live('click', function(e){
					e.preventDefault();
					console.log("Just clicked comment button on activity :" + activity_id);
					
					var commentElemment = $(this).parent().find('textarea'),
						comment = commentElemment.val();
					
					if(comment.length > 0){
						//用户发言，将说的话发到服务器端
						var url = 'message/new',
							data = {
								message: comment,
								activity_id: activity_id
							},
							success = function(data){
						
							},
							dataType = 'JSON';
					
						$.ajax({
							type: 'POST',
							url: url,
							data: data,
							success: success,
							dataType: dataType
						});
					
						commentElemment.val("");
						
						//把聊天内容进行广播
						var channal = '/chatmsg/' + activity_id;
						console.log("Ready to publis a message on " + activity_id + " of " + channal + '|' + current_user_id.value + "|" + comment);
			            client.publish(channal, {
			            	user_name: current_user_name.value,
							comment: comment
			            });		
						console.log("Succeed in receiving a message.");        
					}		
				})

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

