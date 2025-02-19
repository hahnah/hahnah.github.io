import { defineConfig } from "vite";

export default {
  vite: defineConfig({}),
  resolveStaticRoutes: async () => {
    return {
      "/images": "public/images",
      "/content": "content",
    };
  },
};
