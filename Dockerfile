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

# Nginx 이미지 사용 (서버 환경)
FROM nginx:alpine

# 빌드 결과 복사
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx 설정 파일 복사 (필요한 경우)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# 포트 노출
EXPOSE 80
