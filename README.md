myslog
======

MySQL slow query log parser

Install
-------

```
gem install myslog
```

Usage
-----

```ruby
myslog = MySlog.new

text = <<-EOF
# Time: 111003 14:17:38
# User@Host: root[root] @ localhost []
# Query_time: 0.000270  Lock_time: 0.000097  Rows_sent: 1  Rows_examined: 0
SET timestamp=1317619058;
SELECT * FROM life;
# User@Host: php[php] @  [192.168.10.235]
# Thread_id: 313  Schema: ename_bbs_dx15  Last_errno: 0  Killed: 0
# Query_time: 0.031467  Lock_time: 0.000197  Rows_sent: 0  Rows_examined: 0  Rows_affected: 0  Rows_read: 2
# Bytes_sent: 1243  Tmp_tables: 0  Tmp_disk_tables: 0  Tmp_table_sizes: 0
SET timestamp=1359008764;
SELECT * FROM pre_common_session WHERE sid='vWWzwC' AND CONCAT_WS('.', ip1,ip2,ip3,ip4)='192.168.200.57';
EOF

records = myslog.parse(text)
```

`records` is Array of Hash

```ruby
record = records.first

record[:time]          #=> Time(20111003 14:17:38)
record[:user]          #=> "root[root]"
record[:host]          #=> "localhost"
record[:host_ip]       #=> ""
record[:query_time]    #=> 0.000270
record[:lock_time]     #=> 0.000097
record[:rows_sent]     #=> 1
record[:rows_examined] #=> 0
record[:sql]           #=> "SET timestamp=1317619058; SELECT * FROM life;"
```
