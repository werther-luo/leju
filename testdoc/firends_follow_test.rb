#测试用户关注好友流程
1.添加好友测试：

rspec 代码：
------------------------------------------------------------
describe "添加好友关系" do

  it "应该增加好友关系表的count" do
    expect do
      xhr :post, :create, relationship: { followed_id: other_user.id }
    end.should change(Relationship, :count).by(1)
  end

  it "成功之后应该返回" do
    xhr :post, :create, relationship: { followed_id: other_user.id }
    response.should be_success
  end
end
------------------------------------------------------------

2.删除好友测试
rspec 代码：
------------------------------------------------------------
describe "删除好友" do

  before { user.follow!(other_user) }
  let(:relationship) { user.relationships.find_by_followed_id(other_user) }

  it "好友关系数据表应该减少1" do
    expect do
      xhr :delete, :destroy, id: relationship.id
    end.should change(Relationship, :count).by(-1)
  end

  it "应该有成功的返回" do
    xhr :delete, :destroy, id: relationship.id
    response.should be_success
  end
end
------------------------------------------------------------
