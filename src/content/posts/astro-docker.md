---
title: 'Compose for Astro Blog'
description: 'Running Astro in Docker'
pubDate: 2025-11-18
author: 'JP Legat'
tags: ["astro"]
---

## Docker Compose file for spinning up Astro in a container

Run it from inside the Astro root directory.

```yaml
services:
  astro-blog:
    build:
      context: .
      dockerfile: Dockerfile
      no_cache: true
    image: astro:latest
    container_name: astro-local-blog
    ports:
      - 4321:80
    restart: unless-stopped
networks: {}
```
