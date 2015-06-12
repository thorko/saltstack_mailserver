global:
  ipv6: <your ipv6 address>
  ipv4: <your ipv4 address>

postfix:
  mydomain: <yourdomain>
  # mydestination = your domains the mailserver will accept
  mydestination: <domains seperated by comma>
  db_user: postfix
  db_pass: <your db password for postfix>
  db_name: postfix

opendkim:
  domain: <yourdomain>
  keys: ['yourdomain.private', 'yourdomain.txt'] 

sqlgrey:
  db_name: sqlgrey
  db_user: sqlgrey
  db_pass: <your password for sqlgrey user>
  optmethod: optout
  loglevel: 2
  pidfile: /var/tmp/sqlgrey.pid

mysql:
  bindaddress: 127.0.0.1
  innodb_log_size: 500M
  innodb_file_per_table: 1
  query_cache_limit: 1M
  query_cache_size: 16M
  key_buffer: 16M
  root_user: root
  root_pass: <your mysql root password>

spamassassin:
  database: spamassassin
  dbuser: spamassassin
  dbpass: <you password>
