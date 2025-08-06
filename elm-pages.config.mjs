import { defineConfig } from "vite";

export default {
  vite: defineConfig({}),
  headTagsTemplate(context) {
    const isProduction = process.env.NODE_ENV === "production";
    const analyticsScript = isProduction
      ? `
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>`
      : "";

    return `
<link rel="stylesheet" href="/style.css" />${analyticsScript}
`;
  },
  preloadTagForFile(file) {
    return !file.endsWith(".css");
  },
};
