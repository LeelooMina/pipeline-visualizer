import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { quasar, transformAssetUrls } from '@quasar/vite-plugin'

export default defineConfig(({ command, mode }) => {
  return { 
    plugins: [
      vue({
        template: { transformAssetUrls }
      }),
      quasar()
    ],
    css: {
      preprocessorOptions: {
        scss: {
          additionalData: `@import "src/quasar-variables.sass";`
        }
      }
    }
  }
})
