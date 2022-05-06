create database guacdb;
create user 'guacuser'@'localhost' identified by 'Password123!';
grant select,insert,update,delete on guacdb.* to 'guacuser'@'localhost';
flush privileges;
