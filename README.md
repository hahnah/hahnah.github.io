# Hahnah's Site

This is source code and contents of my site.

Using [https://github.com/hahnah/elm-pages-blog-template](https://github.com/hahnah/elm-pages-blog-template) as template.

## Hosting URL

[https://hahnah.github.io](https://hahnah.github.io)

## What is used?

- [Elm](https://elm-lang.org/) language v0.19
- [Elm Pages](https://elm-pages.com/) v3
- [Tailwind CSS](https://tailwindcss.com/) v3

See package.json for more details.

## Setup

1. Install [Volta](https://volta.sh/) for manageing Node.js and npm versions.
   - _OPTION_: You can replace Volta with any other manager what you like, or can just install Node.js directory.
2. Install and set Node.js and npm with Volta like below.
   ```bash
   volta install node@22 # See accurate version in package.json. Or you can use newer version by your own.
   volta install npm@11 # See accurate version in package.json. Or you can use newer version by your own.
   ```
3. Install Node modules
   ```bash
   npm install
   ```

## Running dev server

```bash
npm run start
```

Then open `http://localhost:1234` in your browser.

## Writing a blog post

Add a new markdown file in `content/tech-blog/<any slug what to want>/index.md` or `content/life-blog/<any slug what to want>/index.md`.

## Deploying on GitHub Pages

1. Make sure your repositgory name is same as `<your github username>.github.io`. If not, change it.
2. Edit `Settings.domain` definition in `src/Settings.elm` file. It shoulbe be `<your github username>.github.io`.
3. Make sure `Settings.basePath` is `"/"` in `src/Settings.elm` file.
4. Setup GitHub Pages on GitHub site at "Settings" tab -> "Pages":
   - Set "Source" to `Deploy from a branch`
   - Set "Branch" to `gh-pages` branch and `/root` directory.

Deployment Settings are done!  
Every time you push to the `main` branch, the site will be built and deployed to GitHub Pages with this URL: `https://<your github username>.github.io`.

### Can we deploy site to subdirectory in GitHub Pages?

Which mean, like `https://<your github username>.github.io/any-subdirectory`.  
Typically, subdirectory name will be same as repository name.

The answer is... **No, we can't**.

It's because of elm-pages bug of `build --base ...` command.  
See below issue for more details.  
[https://github.com/dillonkearns/elm-pages/issues/404](https://github.com/dillonkearns/elm-pages/issues/404)

## Author

Hahnah (Natsuki Harai)

## LICENSE

All codes, contents and other things in this repository is licensed under CC BY-NC-ND 4.0.  
See [LICENSE](LICENSE) file for more details.
