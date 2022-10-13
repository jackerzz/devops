# 参考链接
https://www.cnblogs.com/kaibindirver/p/14988791.html
https://www.jianshu.com/p/29c7240e9f48
https://blog.csdn.net/weixin_41821317/article/details/115431336
https://www.automatetheplanet.com/execute-android-appium-tests-docker-selenoid/


https://www.cnblogs.com/se7enjean/p/16396051.html
# image

https://hub.docker.com/r/selenoid/android/tags

# pull image 
docker pull selenoid/android:7.0
docker run -d --name selenoid-ui -p 8080:8080 aerokube/selenoid-ui --selenoid-uri http://${DOCKER_GATEWAY_ADDR}:4444
docker run -d --name selenoid -p 4444:4444 -v /var/run/docker.sock:/var/run/docker.sock -v /workspace/devops/selenoid/config/:/etc/selenoid/:ro aerokube/selenoid


# test2
## 配置
```json
{
    "chrome": {
        "default": "78.0",
        "versions": {
            "78.0": {
                "image": "selenoid/vnc:chrome_78.0",
                "port": "4444",
                "path": "/",
                "env": [
                    "LANG=ru_RU.UTF-8",
                    "LANGUAGE=ru:en",
                    "LC_ALL=ru_RU.UTF-8"
                ]
            }
        }
    },
    "android": {
        "default": "6.0",
        "versions": {
            "6.0": {
                "image": "selenoid/android:6.0",
                "port": "4444",
                "path": "/mobile",
                "env": [
                    "LANG=ru_RU.UTF-8",
                    "LANGUAGE=ru:en",
                    "LC_ALL=ru_RU.UTF-8"
                ]
            }
        }
    }
}
```
docker pull selenoid/vnc:chrome_78.0
docker pull selenoid/android:6.0
docker pull aerokube/selenoid
docker pull aerokube/selenoid-ui

## 运行
docker run -d --name selenoid -p 4444:4444 -v /var/run/docker.sock:/var/run/docker.sock -v /workspace/devops/selenoid/config/:/etc/selenoid/:ro aerokube/selenoid
docker run -d --name selenoid-ui --privileged=true -p 8888:8080 aerokube/selenoid-ui --selenoid-uri http://192.168.95.131:4444
docker run -d --name selenoid -p 4444:4444 -v /var/run/docker.sock:/var/run/docker.sock -v /home/selenoid_ui/config/:/etc/selenoid/:ro aerokube/selenoid
