#测试user模型（user_spec.rb）
测试注册用例代码：
------------------------------------------------------------
@user = User.new(name: "Example User", email: "user@example.com", 
                 password: "foobar", password_confirmation: "foobar")
------------------------------------------------------------

1.模型（Attributes）属性测试：
rspec 代码：
------------------------------------------------------------
subject { @user }

it { should respond_to(:name) }
it { should respond_to(:email) }
it { should respond_to(:password_digest) }
it { should respond_to(:password) }
it { should respond_to(:password_confirmation) }
it { should respond_to(:remember_token) }
it { should respond_to(:admin) }
it { should respond_to(:authenticate) }
it { should respond_to(:microposts) }
it { should respond_to(:feed) }
it { should respond_to(:relationships) }
it { should respond_to(:followed_users) }
it { should respond_to(:reverse_relationships) }
it { should respond_to(:followers) }
it { should respond_to(:following?) }
it { should respond_to(:follow!) }
it { should respond_to(:unfollow!) }

it { should be_valid }
it { should_not be_admin }
------------------------------------------------------------

2.user管理员权限测试
新注册用户不应该接触admin属性
rspec代码：
------------------------------------------------------------
describe "可使用的属性" do
  it "不应该允许接触admin属性" do
    expect do
      User.new(admin: true)
    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end    
end
------------------------------------------------------------

3.email不能为空，用户名不能超过51个字母
rspec代码：
------------------------------------------------------------
describe "当email为空" do
  before { @user.email = " " }
  it { should_not be_valid } end

describe "当用户名过长" do
  before { @user.name = "a" * 51 }
  it { should_not be_valid }
end
------------------------------------------------------------

3.email格式测试：
测试用例：
  不合格的用例：
    user@foo,com
    user_at_foo.org
    example.user@foo.
  合格的用例：
    user@foo.COM
    A_US-ER@f.b.org
    frst.lst@foo.jp
    a+b@baz.cn
rspec代码：
------------------------------------------------------------
describe "当用户email格式不正确" do
  it "应该显示格式不合法" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |invalid_address|
      @user.email = invalid_address
      @user.should_not be_valid
    end      
  end
end

describe "当用户email格式不正确" do
  it "应该显示格式不合法" do
    addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    addresses.each do |valid_address|
      @user.email = valid_address
      @user.should be_valid
    end      
  end
end
------------------------------------------------------------

4.用户email地址唯一性测试：
（新创建的用户的email不能与现有用户email相同）
rspec代码：
------------------------------------------------------------
describe "用户名已经存在" do
  before do
    user_with_same_email = @user.dup
    user_with_same_email.email = @user.email.upcase
    user_with_same_email.save
  end

  it { should_not be_valid }
end
------------------------------------------------------------


5.密码确认测试：
rspec代码：
------------------------------------------------------------
describe "当确认密码与密码不相同时" do
  before { @user.password_confirmation = "mismatch" }
  it { should_not be_valid }
end
------------------------------------------------------------

















