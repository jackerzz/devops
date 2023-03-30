apt update
apt install python3-evdev
apt autoclean &&  apt autoremove

# vnc 登录密码
secret

# 打包
docker build -t selenium_vnc:v1 .

# 运行
docker run -d -p 4444:4444 -p 7900:7900 --shm-size="2g"  erlancode/seleniuebase:v1

docker run -d -p 4444:4444 -p 7900:7900 --shm-size="2g"  selenoid/vnc_chrome:111.0