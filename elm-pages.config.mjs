import { defineConfig } from "vite";

export default {
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
