#用户授权测试（authenticattion_pages_spec.rb）
1.登陆测试：

rspec 代码：
------------------------------------------------------------
describe "当试图在登陆之前访问其他页面" do
  before do
    visit edit_user_path(user)
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "登陆"
  end

  describe "登陆后" do
    describe "when signing in again" do
      before do
        delete signout_path
        visit signin_path
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "登陆"
      end

      it "should render the default (profile) page" do
        page.should have_selector('title', text: user.name) 
      end
    end
  end
end
-------------------------------------------------------------
