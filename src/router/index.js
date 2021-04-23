import Vue from 'vue'
import VueRouter from 'vue-router'
import $store from '../store'
import $socket from '../utils/socket'
import * as $api from '../utils/apis'
import Home from '../views/Home.vue'
import { Message } from 'element-ui'

// 前台
const error = r => require.ensure([], () => r(require('@/views/error/Error')), 'error');
const register1 = r => require.ensure([], () => r(require('@/views/register1/Register1')), 'Register1');
const register = r => require.ensure([], () => r(require('@/views/register/Register')), 'register');
const login = r => require.ensure([], () => r(require('@/views/login/Login')), 'login');
const job = r => require.ensure([], () => r(require('@/views/job/Job')), 'job');
const pushJob = r => require.ensure([], () => r(require('@/views/pushJob/PushJob')), 'pushJob');
const dialogue = r => require.ensure([], () => r(require('@/views/dialogue/Dialogue')), 'dialogue');
const userData = r => require.ensure([], () => r(require('@/views/userData/UserData')), 'userData');
const userBase = r => require.ensure([], () => r(require('@/views/userData/userBase/UserBase')), 'userBase');
const userJoin = r => require.ensure([], () => r(require('@/views/userData/userJoin/UserJoin')), 'userJoin');
const userRelease = r => require.ensure([], () => r(require('@/views/userData/userRelease/UserRelease')), 'userRelease');
const userEdit = r => require.ensure([], () => r(require('@/views/userData/userEdit/UserEdit')), 'userEdit');
const mailPhoneEdit = r => require.ensure([], () => r(require('@/views/userData/userEdit/mailPhoneEdit/MailPhoneEdit')), 'mailPhoneEdit');
const mailPhoneConnect = r => require.ensure([], () => r(require('@/views/userData/userEdit/mailPhoneConnect/MailPhoneConnect')), 'mailPhoneConnect');
// 后台管理

const admin = r => require.ensure([], () => r(require('@/views/admin')), 'admin');
const homePage = r => require.ensure([], () => r(require('@/views/admin/home')), 'homePage');

const userIndex = r => require.ensure([], () => r(require('@/views/admin/user')), 'userIndex');
const merchantIndex = r => require.ensure([], () => r(require('@/views/admin/merchant')), 'merchantIndex');
const applyMerchantIndex = r => require.ensure([], () => r(require('@/views/admin/applyMerchant')), 'applyMerchantIndex');
const schoolIndex = r => require.ensure([], () => r(require('@/views/admin/school')), 'schoolIndex');
const reportIndex = r => require.ensure([], () => r(require('@/views/admin/report')), 'reportIndex');


Vue.use(VueRouter)

// 默认路由
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
  }, {
    path: '/job/:id',
    name: 'Job',
    component: job
  }, {
    path: '/dialogue/:id',
    name: 'Dialogue',
    component: dialogue
  }, {
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
      }, {
        path: '/userJoin',
        name: 'UserJoin',
        component: userJoin,
      }, {
        path: '/userRelease',
        name: 'UserRelease',
        component: userRelease,
      }
    ]
  }, {
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
  },
  // 后台
  {
    path: '/admin',
    name: 'Admin',
    component: admin,
    redirect: '/homePage',
    children: [
      {
        path: '/homePage',
        name: 'HomePage',
        component: homePage,
      }, {
        path: '/userIndex',
        name: 'UserIndex',
        component: userIndex,
      }, {
        path: '/merchantIndex',
        name: 'MerchantIndex',
        component: merchantIndex,
      }, {
        path: '/applyMerchantIndex',
        name: 'applyMerchantIndex',
        component: applyMerchantIndex,
      }
      , {
        path: '/schoolIndex',
        name: 'SchoolIndex',
        component: schoolIndex,
      }, {
        path: '/reportIndex',
        name: 'ReportIndex',
        component: reportIndex,
      }
    ]
  }
]
// 后台管理路由
const adminRouter =
{
  path: '/admin',
  name: 'Admin',
  component: admin,
  redirect: '/homePage',
  children: [
    {
      path: '/homePage',
      name: 'HomePage',
      component: homePage,
    }, {
      path: '/userIndex',
      name: 'UserIndex',
      component: userIndex,
    }, {
      path: '/merchantIndex',
      name: 'MerchantIndex',
      component: merchantIndex,
    }, {
      path: '/applyMerchantIndex',
      name: 'applyMerchantIndex',
      component: applyMerchantIndex,
    }
    , {
      path: '/schoolIndex',
      name: 'SchoolIndex',
      component: schoolIndex,
    }, {
      path: '/reportIndex',
      name: 'ReportIndex',
      component: reportIndex,
    }
  ]
}

const router = new VueRouter({
  routes
})

router.beforeEach((to, form, next) => {
  //处理无效路由
  if (Array.isArray(to.matched) && to.matched.length == 0) {
    next({
      path: "/error",
    });
    return;
  }
  let userInfo = $store.state;//所有的用户信息，包括token
  // 检测如果是没有token智能去注册首页登录
  if (to.name != "Login" && to.name != "Register" && to.name != "Home" && to.name != "Job" && userInfo.accessToken == "") {
    try {
      $socket.default.onClose();
    } catch (error) {
      console.log(error);
    }
    Message.error('请登录！');
    next({
      path: "/login"
    });
  }
  next();
})


export function addAdminRouter() {
  if ($store.state.userData.role == 'admin' && router.options.routes.length == 12) {
    router.addRoute(adminRouter);
  }
}


export default router
