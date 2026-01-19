FROM eclipse-temurin:25-jdk AS builder

WORKDIR /build

# Gradleファイルをコピー（キャッシュ効率化）
COPY gradle gradle
COPY gradlew build.gradle settings.gradle ./

# 依存関係を先にダウンロード（キャッシュ）
RUN ./gradlew dependencies --no-daemon

# ソースをコピーしてビルド
COPY src src
RUN ./gradlew build --no-daemon -x test

# -----実行ステージ------
FROM eclipse-temurin:25-jre

WORKDIR /app

# ビルドステージからJARだけをコピー
COPY --from=builder /build/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
