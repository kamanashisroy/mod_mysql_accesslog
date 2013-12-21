CREATE DATABASE IF NOT EXISTS MYDBNAME;
USE MYDBNAME;
CREATE TABLE IF NOT EXISTS accesslog (
  remote_host int(10) unsigned,
  remote_user varchar(2048),
  timestamp int(10) unsigned,
  request_line varchar(2048),
  status smallint(5) unsigned,
  bytes_body int(10) unsigned,
  header varchar(2048),
  environment varchar(2048),
  filename varchar(2048),
  request_protocol enum('VERSION_1_0','VERSION_1_1'),
  request_method enum('GET','POST','HEAD','OPTIONS','PROPFIND','MKCOL','PUT','DELETE','COPY','MOVE','PROPPATCH','REPORT','CHECKOUT','CHECKIN','VERSION_CONTROL','UNCHECKOUT','MKACTIVITY','MERGE','LOCK','UNLOCK','LABEL','CONNECT'),
  server_port smallint(5) unsigned,
  query_string varchar(2048),
  time_used smallint(5) unsigned,
  url varchar(2048),
  server_name varchar(2048),
  http_host varchar(2048),
  keep_alive tinyint(3) unsigned,
  bytes_in int(10) unsigned,
  bytes_out int(10) unsigned,
  response_header varchar(2048)
);
