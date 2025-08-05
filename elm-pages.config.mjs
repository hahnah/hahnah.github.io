import adapter from "elm-pages/adapter/static.js";
import { defineConfig } from "vite";

export default {
  adapter,
  vite: defineConfig({}),
  headTagsTemplate(context) {
    return `
      <script async src="https://www.googletagmanager.com/gtag/js?id=G-43J055Y1KK"></script>
      <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', 'G-43J055Y1KK');
      </script>
    `;
  },
};
