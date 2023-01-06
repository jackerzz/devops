# db 压力测试
# 进入容器
```shell
docker run -itd  nature:v1 /bin/bash
docker attach e5ced25c01af
```


## PostgreSQL
    
### pgbench是PostgreSQL自带的压测工具。

####  初始化（生成4个测试表）
```shell
pgbench -h 127.0.0.1 -p 5432 -U postgres --initialize

```

#### 200个客户端，10个线程，将事务写入日志文件，每5秒报告进度，每个客户端100个事务，测试前清空标准的测试表
```shell
pgbench -h 127.0.0.1 -p 5432 -U postgres --client=200 --connect --jobs=10 --log --progress=5 --transactions=100 --vacuum-all
```

### sysbench
- sysbench是一款开源的多线程性能压测工具，可以对CPU、内存、线程、IO、数据库等进行性能压力测试

```shell
git clone https://github.com/akopytov/sysbench.git
cd sysbench
sh autogen.sh
./configure --with-pgsql --with-pgsql-includes=/usr/local/pgsql/include --with-pgsql-libs=/usr/local/pgsql/lib --without-mysql
make && make install
```

#### 查看sysbench版本
```shell
sysbench --version
```
#### 在sysbench/src/lua路径有十几种压测脚本，应根据压测目的选择对应的压测脚本。

```shell
select_random_ranges.lua
select_random_points.lua
prime-test.lua
oltp_write_only.lua
oltp_update_non_index.lua
oltp_update_index.lua
oltp_read_write.lua
oltp_read_only.lua
oltp_point_select.lua
oltp_insert.lua
oltp_delete.lua
oltp_common.lua
empty-test.lua
bulk_insert.lua
```

#### 创建10张测试表，每张表100万行
```shell
sysbench /home/postgres/sysbench/src/lua/oltp_insert.lua \
 --db-driver=pgsql \
 --pgsql-host=127.0.0.1 \
 --pgsql-port=5432 \
 --pgsql-user=postgres \
 --pgsql-password=Passwd@123 \
 --pgsql-db=postgres \
 --tables=10 \
 --table-size=1000000 \
 prepare
```
#### 压力测试
```shell
sysbench /home/postgres/sysbench/src/lua/oltp_insert.lua \
 --db-driver=pgsql \
 --pgsql-host=127.0.0.1 \
 --pgsql-port=5432 \
 --pgsql-user=postgres \
 --pgsql-password=Passwd@123 \
 --pgsql-db=postgres \
 --tables=10 \
 --table-size=1000000 \
 --report-interval=5 \
 --threads=100 \
 --time=60 \
 run
```

#### 清除压测数据
```shell
sysbench /home/postgres/sysbench/src/lua/oltp_insert.lua \
 --db-driver=pgsql \
 --pgsql-host=127.0.0.1 \
 --pgsql-port=5432 \
 --pgsql-user=postgres \
 --pgsql-password=Passwd@123 \
 --pgsql-db=postgres \
 --tables=10 \
 cleanup
```

## Redis压力测试 

```shell
 docker run --rm redislabs/memtier_benchmark:latest --help
```
# 参考资料
- [PostgreSQL 使用 pgbench 测试 sysbench 相关case](https://github.com/digoal/blog/blob/master/201610/20161031_02.md)
- [PostgreSQL压力测试](https://www.cnblogs.com/haha029/p/15618056.html)
- [PostgreSQL数据库压力测试工具pgbench简单应用](https://developer.aliyun.com/article/576668)
- [PostgreSQL 同步流复制(高并发写入)锁瓶颈分析](https://billtian.github.io/digoal.blog/2016/11/07/02.html)
- [Redis压力测试 ](https://www.cnblogs.com/haha029/p/15610140.html)
- [数据库压力测试方法概述 ](https://www.modb.pro/db/33001)
- [环思物联项目性能测试报告](https://rbo5uek8e5.feishu.cn/docx/Gfn3dthF6oVBDNxPW8scfBrWnsg)
- [iot测试数据详情](https://rbo5uek8e5.feishu.cn/sheets/shtcnD5hOZnlF1evmrbz5lDG7Ge?sheet=pvIjhh)
- [TiDB Sysbench 性能对比测试报告 - v5.3.0 对比 v5.2.2](https://docs.pingcap.com/zh/tidb/dev/benchmark-sysbench-v5.3.0-vs-v5.2.2)
- [PostgreSQL 实时健康监控 大屏 - 高频指标 - 珍藏级](https://developer.aliyun.com/article/640701)
- [PostgreSQL中的死锁](https://dreamer-yzy.github.io/2015/01/14/-%E7%BF%BB%E8%AF%91-PostgreSQL%E4%B8%AD%E7%9A%84%E6%AD%BB%E9%94%81/)