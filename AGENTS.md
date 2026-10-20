# Making changes

This site uses GitHub Pages’ built-in Jekyll, Markdown pages, simple HTML, and
one stylesheet. `README.md` is the public introduction to the site. Keep editing
and maintenance instructions here, not in the README.

## Which file to edit

- `index.md`: homepage introduction and featured content.
- `about.md`: biography.
- `morning-brew.md`: videos, images, and collaborations.
- `work-with-me.md`: services, process, and how to start a conversation.
- `_data/socials.yml`: social and contact links. Set `url` to a full `https://…`
  address or `mailto:PUBLIC_EMAIL`. Empty URLs stay hidden; remove unused entries.
- `_config.yml`: site title, description, and address.
- `README.md`: description shown on the repository’s front page.

Keep the opening block between `---` lines on each page; it sets the title and
page address. Edit the writing below it. Remove unneeded placeholder sections.
For requested design changes, use `_layouts/default.html` and
`assets/css/style.css`; reuse the existing includes in `_includes/`.

## Images

Put web-sized copies in `assets/images/`, usually 1,600–2,000 pixels on the long
edge and a few hundred KB when practical. Keep originals outside the repository
and check for private location metadata. Do not add an image-processing pipeline.

Add an image to a Markdown page with:

```liquid
{% include image.html src="/assets/images/my-photo.jpg" alt="Description of the photo" caption="Optional caption" %}
```

Replace the filename and text. Omit `caption` if unwanted. Use `alt=""` only for
decorative images. Loading is eager by default for prominent top images; add
`loading="lazy"` for images farther down a page. Optional `width` and `height`
values must match the replacement image’s dimensions, or be removed.

## YouTube videos

Keep videos on YouTube. Use only the video ID—the part after `v=`, `youtu.be/`,
or `/shorts/`—and a descriptive title:

```liquid
{% include youtube.html id="VIDEO_ID" title="Descriptive video title" %}
{% include youtube.html id="VIDEO_ID" title="Descriptive Short title" portrait=true %}
```

An empty ID shows a placeholder. Embeds resize, load lazily, support fullscreen,
and never autoplay. The `youtube-nocookie.com` domain is privacy-enhanced, not
tracking-free; playing a video can share data with YouTube/Google.

## Preview and checks

Do not install Ruby, Bundler, or gems on this machine; the owner does not want the
Ruby toolchain downloaded here. Do not offer to install it. Check what is already
present with `ruby -v` and `bundle -v`. If either is missing or Ruby is older than
3.3, skip the local preview and the commands below, make the edits anyway, and
report that the build, `scripts/check_site.rb`, and browser checks did not run. In
that case the **Build and check** PR check is the only automated verification, so
call out anything it would have caught: broken internal links, missing image files,
missing alt text, and Markdown or front matter errors. Ask before installing any
other missing tool.

`Gemfile` and `Gemfile.lock` keep the build compatible with GitHub Pages; leave
them alone unless a dependency change is approved. Where Ruby 3.3 and Bundler are
already installed, run from the repository folder:

```sh
bundle config set --local path vendor/bundle
bundle install
bundle exec jekyll serve --safe --strict_front_matter
```

Preview at `http://localhost:4000/macyagilliam/`. Saved changes rebuild; refresh
the browser to see them. Stop with Ctrl+C. Restart after changing `_config.yml`.

Where the toolchain is installed, run before handing off:

```sh
bundle exec jekyll build --safe --strict_front_matter
bundle exec ruby scripts/check_site.rb
```

The check covers local links, fragments, image files, and missing alt attributes.
It does not verify external links, video playback, alt-text quality, or appearance.
Check desktop and phone-sized layouts and keyboard navigation when browser tools
are available. Report what ran, what passed, and what remains unverified.

## Publishing and undoing changes

- Work on the `test-changes` branch. Committing and pushing there are expected
  without asking. Never push to `main`, and open a pull request into `main` only
  when asked. A human reviews and decides when to publish. Do not merge or change
  repository or domain settings without approval. Explain changes briefly in plain
  language.
- Commit finished changes with a brief message, one topic per commit. Pushing to
  `test-changes` neither publishes the site nor runs **Build and check**, which
  runs only on pull requests into `main`.
- The **Build and check** PR check builds and checks links; it does not publish.
  Once Pages is configured, merging into `main` publishes the site.
- Undo a published change with **Revert** on its merged PR, then review and merge
  the resulting revert PR. If automatic reverting fails, prepare a revert branch;
  do not erase history.
- Standard GitHub Pages does not provide per-PR preview sites. Preview locally.

### Pages setup

With approval and admin access, use **Settings → Pages → Deploy from a branch →
main → / (root)**. Do not commit `_site` or add a separate deployment system.
The initial address is `https://macyagilliam.github.io/macyagilliam/`.

Recommend protecting `main` with required PRs and **Build and check**, blocking
force pushes and deletion. Check available permissions and controls first; the
status may only appear after its first run. Require a reviewer only if another
person is available to review.

For a custom domain, follow [GitHub’s domain setup instructions](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site).
Configure Pages, DNS, and HTTPS with approval. In a PR, set `_config.yml`’s `url`
to the domain’s `https://…` address and `baseurl` to `""`. Keep the `CNAME` file if
GitHub creates it. Local preview then uses `http://localhost:4000/`.

## Rules

- Make the smallest change that fulfills the request. Preserve existing work and
  the design unless a change is requested. Content requests belong in content files.
- Ask before adding dependencies, JavaScript, build tools, plugins, or external
  services. Do not introduce frameworks, a CMS, a database, or extra hosting.
- Keep semantic HTML, alt text, readable contrast, visible keyboard focus, and
  the mobile layout working. Navigation must not need JavaScript.
- Use labeled placeholders for missing content. Never invent personal details,
  endorsements, or contact information.
- Never commit secrets, private material, or unrelated files. The repository and
  its history are public, even files not shown on the website. Deleting a file
  does not remove it from history. Publish only material cleared for public use.

## Example requests

- “Replace the bio in about.md with this text. Keep the design unchanged.”
- “Add this YouTube video to Morning Brew using the existing include and this title.”
- “Update the social links to these URLs. Run the checks and do not push.”
