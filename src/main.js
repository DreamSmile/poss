import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';

import '@/assets/css/reset.css'
import '@/assets/css/common.less'

Vue.use(ElementUI)

Vue.config.productionTip = false;
import * as apis from '@/utils/apis.js';
import * as adminApi from '@/utils/adminApi.js';

import * as utils from '@/utils/common.js';
import * as socket from '@/utils/socket.js';

Vue.prototype.$api = apis;
Vue.prototype.$adminApi = adminApi;
Vue.prototype.$utils = utils;
Vue.prototype.$socket = socket


new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
