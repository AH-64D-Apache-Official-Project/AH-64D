import { viteSingleFile } from "vite-plugin-singlefile";
/** @type {import('vite').UserConfig} */
export default {
  plugins: [viteSingleFile()],
  server: { watch: { usePolling: true } },
  build: {outDir: "../@AH-64D Apache Longbow/Addons/fza_ah64_ihadss/web"}
};
