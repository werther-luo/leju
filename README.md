乐聚--基于地理位置的社交活动组织平台
===============

- Ruby On Rails 
- Event machin： thin
- Server： thin
- Chat： faye
- Html template： bootstrap
 
####安装运行：
  bundle install
  rake db:reset
  rake db:migrate
  rake db:populate


  thin start

  rackup faye.ru -E production -s thin

####用户名，密码：
username | password
-------- | --------
a@b.com  | foobar
a-1@b.com| foobar
.....| foobar
a-99@b.com | foobar
  
