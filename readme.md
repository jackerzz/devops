# docker 镜像推送到docker hub
- [docker hub 推送镜像](https://blog.csdn.net/butterfly5211314/article/details/83068807)
``` 
$ docker login                                      # 登陆
$ docker tag first-image  gerrylon/first-image      # 打包镜像
$ docker push gerrylon/first-image                  # 推送镜像
```

# gitpod 搭建drone

## 参考地址： https://yeasy.gitbook.io/docker_practice/ci/drone/install
- docker run -u zap -p 8080:8080 -p 8090:8090 -i owasp/zap2docker-stable zap-webswing.sh

- docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest

# 
```shell script
#构建镜像
docker build -t ${IMAGE_NAME} .
```

# 开发环境
- [sonarqube-Bitnami 打包的 SonarQube](https://hub.docker.com/r/bitnami/sonarqube/)

# zap-基线测试
docker run -t owasp/zap2docker-stable zap-baseline.py -t http://www.huansi.net/


# sonarqube
- [zap 使用介绍](https://medium.com/volosoft/running-penetration-tests-for-your-website-as-a-simple-developer-with-owasp-zap-493d6a7e182b)
- [phabricator 停止维护的代码审查工具](https://github.com/phacility/phabricator)
- [phabricator-试用 ](https://docs.sonarqube.org/latest/setup/get-started-2-minutes/)
- [汉化参考 ](https://cloud.tencent.com/developer/article/1822521)

# 低代码引擎
- [demo-crm](https://github.com/YaoApp/demo-crm)
- [yao-wms](https://github.com/YaoApp/yao-wms)