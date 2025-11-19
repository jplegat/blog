---
title: 'Astro running on Docker'
description: 'Docker compose file for Astro locally'
pubDate: 2025-11-19
author: 'JP Legat'
tags: [astro, docker, docker-compose]
---

## Compose

```yaml
services:
  astro-blog:
    build:
      context: .
      dockerfile: Dockerfile
      no_cache: true
    image: astro:latest
    container_name: astro-blog
    ports:
      - "4321:80"
    restart: unless-stopped
