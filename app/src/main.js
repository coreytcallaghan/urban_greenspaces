import Vue from 'vue'
import App from './App.vue'
import router from './router'
import L from 'leaflet'
import VueFuse from 'vue-fuse'

Vue.use(VueFuse)
Vue.config.productionTip = false
delete L.Icon.Default.prototype._getIconUrl
L.Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png')
})

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
