# Bun 이미지 사용 (빌드 환경)
FROM oven/bun:latest AS builder

# 작업 디렉토리 설정
WORKDIR /app

# package.json 및 bun.lock 복사
COPY package.json bun.lock ./

# 의존성 설치
RUN bun install

# 소스 코드 복사
COPY . .

# 빌드 실행 (Astro 빌드)
RUN bun run build

# === 배포 ===
FROM nginx:alpine

# 환경 변수 복사
ARG DOMAIN  # docker build 시에 전달될 환경 변수 정의
ENV DOMAIN ${DOMAIN}  # 컨테이너 내부에서 사용할 환경 변수 설정

# 빌드 결과물을 Nginx의 웹 페이지 디렉토리에 복사
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx 설정 파일 복사
COPY nginx.conf.template /etc/nginx/conf.d/default.conf

# Nginx 실행 전에 환경 변수를 사용하여 설정 파일 내용 변경
CMD ["/bin/sh", "-c", "envsubst < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]

# 포트 노출
EXPOSE 80
