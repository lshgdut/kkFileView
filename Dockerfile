FROM maven:3.8-adoptopenjdk-8 AS build

# 使用 Maven 打包项目
WORKDIR /app
COPY . .
RUN mvn -B clean package -Dmaven.test.skip=true --file pom.xml

# 第二阶段：基于基础镜像运行应用
FROM lshgdut/kkfileview-base:latest
# 替换为从构建阶段复制的制品
COPY --from=build /app/server/target/kkFileView-*.tar.gz /opt/
ENV KKFILEVIEW_BIN_FOLDER=/opt/kkFileView-4.4.0/bin
ENTRYPOINT ["java","-Dfile.encoding=UTF-8","-Dspring.config.location=/opt/kkFileView-4.4.0/config/application.properties","-jar","/opt/kkFileView-4.4.0/bin/kkFileView-4.4.0.jar"]
