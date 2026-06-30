# ===== 构建阶段 =====
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests -B

# ===== 运行阶段 =====
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/target/supermarket-backend-1.0.0.jar app.jar

# 暴露端口
EXPOSE 8080

# 启动命令（SPRING_PROFILES_ACTIVE=production 时读取 application-production.yml）
# 数据库和 JWT 信息从环境变量注入
ENTRYPOINT ["java", \
  "-jar", "app.jar", \
  "--spring.profiles.active=${SPRING_PROFILES_ACTIVE:-default}", \
  "--spring.datasource.url=${SPRING_DATASOURCE_URL}", \
  "--spring.datasource.username=${SPRING_DATASOURCE_USERNAME}", \
  "--spring.datasource.password=${SPRING_DATASOURCE_PASSWORD}", \
  "--jwt.secret=${JWT_SECRET}"]