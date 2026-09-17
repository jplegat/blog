# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal blog (`jplegat/blog`, published at https://jplegat.github.io/blog) built on Astro 5 as a static site. It is a fork of `dennisklappe/astro-theme-terminal` (git remote `upstream`), itself a port of panr's Hugo Terminal theme. The README is largely the upstream theme's README; site-specific details are below.

## Commands

```bash
npm install
npm run dev        # dev server at http://localhost:4321/ (base /)
npm run build      # static output to dist/ with base /blog (astro build sets NODE_ENV=production)
npm run preview    # serve dist/ at http://localhost:4321/blog
```

There are no tests and no linter. TypeScript is `astro/tsconfigs/strict`.

Docker (nginx serving `dist/`, port 8888) is the local test/preview environment. A container built from this repo runs at **http://192.168.1.150:8888/** on the Docker host (the same machine that serves the `/Volumes/Share` SMB mount, where the repo is `/mnt/files/Code/astro`; Docker Desktop is not running on the Mac). Use it to check changes before pushing. It serves the last built image, so rebuild on that host after editing:

```bash
./build.sh                       # down, prune, rebuild --no-cache, up -d
docker compose up -d --build     # same without the prune
```

Note the Docker build uses base `/`, so it does not exercise the `/blog` base path used on GitHub Pages.

Deployment is automatic: pushing to `main` runs `.github/workflows/deploy.yml` (`withastro/action@v2` → GitHub Pages).

## Base path — the main gotcha

`astro.config.mjs` sets `base` three ways:

- `DOCKER_BUILD=true` → `/` (set in the Dockerfile)
- `NODE_ENV=production` (any `astro build`, including the GitHub Actions one) → `/blog`
- otherwise (`npm run dev`) → `/`

Because of this, **every internal link must be prefixed with the base**. The convention used in every layout/component/page is:

```ts
const base = import.meta.env.BASE_URL.endsWith('/') ? import.meta.env.BASE_URL : import.meta.env.BASE_URL + '/';
// then: href={`${base}posts/${slug}/`}, href={`${base}tags/${tag}/`}
```

Hardcoded `/posts/...` or `/images/...` links will break on GitHub Pages. Post markdown uses absolute URLs (`https://jplegat.github.io/blog/images/...`) for images kept in `public/images/` — so new images show as broken in local/Docker previews until the commit is pushed and deployed.

## Content model

Posts live in `src/content/posts/*.md`; the schema is in `src/content.config.ts` (`title`, `pubDate` required; `description`, `updatedDate`, `author`, `image`, `externalLink`, `tags`, `draft` optional). Existing posts use `author: 'JP Legat'` and bare-array tags (`tags: [astro, docker]`). The file name is the slug (`/posts/<slug>/`).

`externalLink` makes `PostCard` link out (new tab) instead of to the local post page.

`draft: true` is filtered on the home page, `/posts`, and `/posts/[slug]` (including prev/next navigation), and from per-tag listings — but **not** from the tag set used to generate `/tags/*` routes, the `/tags` index counts, or `rss.xml.js`. Keep that in mind if touching draft handling.

## Rendering structure

- `BaseLayout.astro` — HTML shell, `<head>` meta/OG, the navigation menu (hardcoded twice: `.menu--mobile` dropdown and `.menu--desktop`; edit both), footer, menu toggle script, and the **global CSS import list** in `<style is:global>`. Import order matters — later files override earlier ones.
- `PostLayout.astro` — wraps `BaseLayout`; renders title/meta/tags/cover, then injects the code-block wrapper (`div.highlight` + `.code-title` + Copy button) client-side around every `pre.astro-code`.
- `src/pages/posts/[...slug].astro` — `getStaticPaths` sorts posts by `pubDate` desc and passes `prevPost`/`nextPost` for the "Read other posts" pagination.
- `src/pages/tags/[tag].astro` / `tags/index.astro` — tag routes derived from the union of all posts' `tags`.

## Styling

All styling is plain CSS in `src/styles/`, imported globally from `BaseLayout.astro`. Theme colours are CSS custom properties at the top of `terminal.css` (currently Solarized Dark); panr's Terminal.css generator output drops in there directly.

Fonts: Google Sans Code (variable, 300–800) is loaded by the two Fontsource `@import`s at the top of `terminal.css` (pinned to `google-sans-code:vf@5.3.0`); Vite hoists them to the top of the single CSS bundle. The stack is declared in three places that must stay in sync: `--font-family` in `main.css` (applied to `*`), and `body` and `code, kbd` in `terminal.css`. `public/fonts/` still holds the old `m6x11.ttf` and `FiraCode-VF.woff2`, both unreferenced.

Syntax highlighting is Shiki with the `css-variables` theme (`astro.config.mjs`); the actual token colours are defined in `syntax.css`.
