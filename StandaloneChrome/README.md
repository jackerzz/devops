apt update
apt install python3-evdev
apt autoclean &&  apt autoremove

# vnc 登录密码
secret

# 打包
docker build -t selenium_vnc:v9 .

# 运行
docker run -d -p 4444:4444 -p 7900:7900 --shm-size="2g"  test:v1

docker run -d -p 8888:8888 -p 7900:7900 --shm-size="2g"  selenoid/vnc_chrome:111.0

docker run -d -p 8888:8090 -p 7900:7900 selenium_vnc:v9
docker run -d -p 8889:8090 -p 7901:7900 selenium_vnc:v10