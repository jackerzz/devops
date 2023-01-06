#!/bin/bash
# 基础配置
####### redis ###########
redis_config_pwd=""
redis_config_hostname=""
#######  ###########

Performance_testing_redis()
{
  echo "对redis 进行压力测试"
  echo $redis_config_pwd
  echo $redis_config_hostname
  docker run --rm redislabs/memtier_benchmark:latest
}

main ()
{
  echo -n " 开始进行压力测试了 ";
  echo "压力测试以及完成";
}
main
echo "Shell 传递参数实例！";
echo "执行的文件名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
echo "第三个参数为：$3";