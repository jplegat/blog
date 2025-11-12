// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// https://astro.build/config
export default defineConfig({
  site: 'https://jplegat.github.io',
  base: process.env.DOCKER_BUILD ? '/' : (process.env.NODE_ENV === 'production' ? '/blog' : '/'),
  output: 'static', // ← Add this line to ensure static output
  integrations: [sitemap()],
  markdown: {
    shikiConfig: {
      theme: 'css-variables',
      langs: [],
      wrap: true,
    },
  },
});
