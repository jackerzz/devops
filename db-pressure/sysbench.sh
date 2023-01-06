#!/bin/bash
# 基础配置
####### sysbench_postgres ###########
####### db config ###########
pgsql_user="postgres"
pgsql_password="huansi.net@v3"
pgsql_port="30021"
pgsql_host="122.224.36.54"
####### sysbench config ##########
tables=10
table_size=100000
debug="off"
time=1200
threads=100
report_interval=5
histogram="on"
#######  ###########
create_oltp(){
  echo "创建进行压力测试操作的表"
  echo "运行的函数: $0"
  echo "传入的参数：$1"
  sysbench $1 \
  --db-driver=pgsql \
  --pgsql-host=$pgsql_host\
  --pgsql-port=$pgsql_port \
  --pgsql-user=$pgsql_user \
  --pgsql-password=$pgsql_password \
  --pgsql-db=postgres \
  --tables=$tables \
  --debug=$debug\
  --table-size=$table_size \
  prepare
  echo "！！！表格创建完成 ！！！"
}
run_performance(){
  echo "对postgres 进行压力测试"
  echo "运行的函数: $0"
  echo "传入的参数：$1"
  sysbench $1 \
   --db-driver=pgsql \
   --pgsql-host=$pgsql_host \
   --pgsql-port=$pgsql_port \
   --pgsql-user=$pgsql_user \
   --pgsql-password=$pgsql_password \
   --pgsql-db=postgres \
   --tables=$tables \
   --table-size=$table_size \
   --debug=$debug \
   --report-interval=$report_interval \
   --threads=$threads \
   --time=$time \
   --histogram=$histogram \
   run
}

run_cleanup(){
  echo "清理压测产生数据"
  echo "运行的函数: $0"
  echo "传入的参数：$1"
  sysbench $1 \
   --db-driver=pgsql \
   --pgsql-host=$pgsql_host \
   --pgsql-port=$pgsql_port \
   --pgsql-user=$pgsql_user \
   --pgsql-password=$pgsql_password \
   --pgsql-db=postgres \
   --debug=$debug\
   --tables=$tables \
   cleanup
}


main ()
{
  echo -n " 开始进行压力测试了 ";
#  input_path="sysbench/src/lua/oltp_update_non_index.lua"   # +1
  input_path="sysbench/src/lua/oltp_read_only.lua"         # wait
#  input_path="sysbench/src/lua/oltp_insert.lua"            # wait
#  input_path="sysbench/src/lua/oltp_common.lua"            # wait
#  input_path="sysbench/src/lua/bulk_insert.lua"            # wait

#  input_path="sysbench/src/lua/oltp_update_index.lua"      # done
#  input_path="sysbench/src/lua/oltp_read_write.lua"        # done
#  input_path="sysbench/src/lua/oltp_read_write.lua"        # done

  echo "输入的路径$input_path"

  create_oltp $input_path
  run_performance $input_path
  run_cleanup $input_path

  echo "压力测试以及完成";

}
main
