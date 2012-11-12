#活动的action测试（activity_controller_spec.rb）：
#测试活动的应该有的action动作是否正常响应
1.新建活动页面的请求测试
rspec 代码：
------------------------------------------------------------
describe "通过“get”方法请求‘new’action时" do
  it "应该返回成功的http响应" do
    get 'new'
    response.should be_success
  end
end
------------------------------------------------------------

2.新建活动存储的请求测试
rspec 代码：
------------------------------------------------------------
describe "通过post方法请求activity的create方法时" do
  it "应该返回成功的http响应" do
    get 'create'
    response.should be_success
  end
end
------------------------------------------------------------

3.活动activity的显示测试
rspec 代码：
------------------------------------------------------------
describe "通过‘get’方法请求activity时" do
  it "应该返回成功的http响应" do
    get 'show'
    response.should be_success
  end
end
------------------------------------------------------------