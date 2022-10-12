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