# Dockerfile (for static site with Nginx)

# ---- Build Stage ----
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# Set environment variable for Docker builds
ENV DOCKER_BUILD=true
ENV NODE_ENV=production
RUN npm run build
# Build produces static files in /app/dist

# ---- Runtime Stage ----
FROM nginx:alpine AS runtime
# Copy static files to nginx html directory
COPY --from=builder /app/dist /usr/share/nginx/html
# Expose port 80
EXPOSE 80
# nginx starts automatically