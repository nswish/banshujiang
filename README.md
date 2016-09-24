###启动服务###
1. ./script/production.sh
2. ./script/production.sh skip    # 跳过 assets pipe

###给数据表增加字段###
```
  rails generate migration AddRemarkToDonations remark:string # 给Donations表增加一个Remark字段
```

###执行Migration###
```
  rake db:migrate RAILS_ENV=production # 指定环境执行Migration
```

###查询和修改数据表的自增字段
```
mysql> alter table e_books auto_increment = 1881;
mysql> show table status where name = 'e_books';
```
