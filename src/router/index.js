import Vue from 'vue'
import VueRouter from 'vue-router'
import $store from '../store'
import * as $api from '../utils/apis'
import Home from '../views/Home.vue'
// import { Message} from 'element-ui'

const register1 = r => require.ensure([], () => r(require('@/views/register1/Register1')), 'Register1');
const register = r => require.ensure([], () => r(require('@/views/register/Register')), 'register');
const login = r => require.ensure([], () => r(require('@/views/login/Login')), 'login');
const job = r => require.ensure([], () => r(require('@/views/job/Job')), 'job');
const pushJob = r => require.ensure([], () => r(require('@/views/pushJob/PushJob')), 'pushJob');
const dialogue = r => require.ensure([], () => r(require('@/views/dialogue/Dialogue')), 'dialogue');
const error = r => require.ensure([], () => r(require('@/views/error/Error')), 'error');


const userData = r => require.ensure([], () => r(require('@/views/userData/UserData')), 'userData');
const userBase = r => require.ensure([], () => r(require('@/views/userData/userBase/UserBase')), 'userBase');
const userJoin = r => require.ensure([], () => r(require('@/views/userData/userJoin/UserJoin')), 'userJoin');
const userRelease = r => require.ensure([], () => r(require('@/views/userData/userRelease/UserRelease')), 'userRelease');
const userEdit = r => require.ensure([], () => r(require('@/views/userData/userEdit/UserEdit')), 'userEdit');
const mailPhoneEdit = r => require.ensure([], () => r(require('@/views/userData/userEdit/mailPhoneEdit/MailPhoneEdit')), 'mailPhoneEdit');
const mailPhoneConnect = r => require.ensure([], () => r(require('@/views/userData/userEdit/mailPhoneConnect/MailPhoneConnect')), 'mailPhoneConnect');

Vue.use(VueRouter)
// Vue.prototype.$message = Message;

let checkLogin = { isLogin: false }
const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  }, {
    path: '/register1',
    name: 'Register1',
    component: register1
  }, {
    path: '/register',
    name: 'Register',
    component: register
  }, {
    path: '/login',
    name: 'Login',
    component: login
  },
  {
    path: '/job/:id',
    name: 'Job',
    component: job
  },
  {
    path: '/dialogue/:id',
    name: 'Dialogue',
    component: dialogue
  },
  {
    path: '/pushJob/:id',
    name: 'PushJob',
    component: pushJob
  }, {
    path: '/userData',
    name: 'UserData',
    component: userData,
    redirect: '/userBase',
    children: [
      {
        path: '/userBase',
        name: 'UserBase',
        component: userBase,
      },
      {
        path: '/userJoin',
        name: 'UserJoin',
        component: userJoin,
      }, {
        path: '/userRelease',
        name: 'UserRelease',
        component: userRelease,
      }
    ]
  }
  , {
    path: '/userEdit',
    name: 'UserEdit',
    component: userEdit,
  }, {
    path: '/mailPhoneEdit/:type',
    name: 'MailPhoneEdit',
    component: mailPhoneEdit,
  }, {
    path: '/mailPhoneConnect/:type',
    name: 'MailPhoneConnect',
    component: mailPhoneConnect,
  }, {
    path: '/error',
    name: 'Error',
    component: error,
  }
]

const router = new VueRouter({
  routes
})

router.beforeEach((to, form, next) => {
  //处理无效路由
  if (Array.isArray(to.matched) && to.matched.length == 0) {
    next({
      path: "/error",
      query: { msg: encodeURIComponent("很抱歉，页面它不小心迷路了..") }
    });
    return;
  }
  // 只有登录注册，首页能让游客进入


  let userInfo = $store.state;//所有的用户信息，包括token

  // 每次换路由就获取用户接口，检查token是否过期
  // if (to.name != "Login" && to.name != "Register") {
  // }
  next();

})

export default router
