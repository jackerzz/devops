# gitpod 搭建drone

## 参考地址： https://yeasy.gitbook.io/docker_practice/ci/drone/install
docker run -u zap -p 8080:8080 -p 8090:8090 -i owasp/zap2docker-stable zap-webswing.sh
docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest
#  集成方式
https://9000-jackerzz-devops-4ylayvxmst9.ws-us59.gitpod.io/documentation/analysis/github-integration/

# 开发环境
- [sonarqube-Bitnami 打包的 SonarQube](https://hub.docker.com/r/bitnami/sonarqube/)