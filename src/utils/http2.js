import axios from 'axios';
import $store from '../store'
import $router from '../router'
import $socket from '../utils/socket'
import { changeToke } from '../utils/apis'
import { Message } from 'element-ui';

const axiosIns = axios.create({
    timeout: 15 * 1000,
    headers: {
        "Content-Type": "application/json;charset=UTF-8",
    }
});
const axiosInsP = axios.create({
    timeout: 15 * 1000,
    contentType: false,
    processData: false,
    headers: {
        "Content-Type": "multipart/form-data",
        "Accept": "*/*"
    }
});

// 发起请求前拦截，获取缓存中token>vuex中>空，将token放到头部
axiosIns.interceptors.request.use(config => {
    let token = $store.state.accessToken ? $store.state.accessToken : '';
    if (token) {
        config.headers.Authorization = token;
    }

    return config;
}, err => {
    return Promise.reject(err);
}
);
axiosInsP.interceptors.request.use(config => {
    config.headers.Authorization = $store.state.accessToken;
    return config;
}, err => {
    return Promise.reject(err);
}
);
let userInfo = $store.state;//所有的用户信息，包括token
console.log(userInfo);
//类似于.then(()=>{},()=>{});
axiosIns.interceptors.response.use(response => {
    //对响应数据做点处理
    if (response.data.code == 13005 || response.data.code == 401) {
        changeToke({ "refreshToken": userInfo.refreshToken }).then(res => {
            console.log('更换token');
            if (!res.success) {//获取新的token失败，就跳转首页,并清除所有存入vux的信息
                $store.commit('clearAll');
                $socket.default.onClose();//关闭websocket
                $router.push("/login");
                Message.error('登录信息失效，请重新登录!');
                return;
            }//获取新的token成功，就修改token
            console.log('修改token成功');
            $store.commit('setUserToken', res.data);
            // 重新访问接口
            console.log(response);
            return axiosIns(response.config);
        }).catch(err => {
            $store.commit('clearAll');
            $socket.default.onClose();//关闭websocket
            $router.push("/login");
            Message.error('登录信息失效，请重新登录!');
        })
    } else if (response.data.code == 13025) {//token未传直接跳转登录页,用户未登录
        $store.commit('clearAll');
        $socket.default.onclose();//关闭websocket
        $router.push("/login");
        Message.error('请登录！');

    } else if (response.data.code == 13066) {//登录状态失败，一般是账号同时登录，提示其他地方登录，并跳转到登录界面
        $store.commit('clearAll');
        $socket.default.onClose();//关闭websocket
        $router.push("/login");
        Message.error('账号已在其他地区登录，请重新登录！');
    }
    else {
        return response;
    }
}, error => {
    //对响应错误做点处理

    if (error && error.response) {
        switch (error.response.status) {
            case 400:
                error.message = "错误请求";
                break;
            case 401:
                error.message = "未授权，请先授权";
                break;
            case 403:
                error.message = "拒绝访问";
                break;
            case 404:
                error.message = "请求错误，未找到资源";
                break;
            case 405:
                error.message = "请求方法不允许";
                break;
            case 408:
                error.message = "请求超时";
                break;
            case 500:
                error.message = "服务器端出错|500";
                break;
            case 501:
                error.message = "网络未实现";
                break;
            case 502:
                error.message = "网络错误";
                break;
            case 503:
                error.message = "服务不可用";
                break;
            case 504:
                error.message = "网络超时";
                break;
            case 505:
                error.message = "http版本不支持该请求";
                break;
            default:
                error.message = "请求错误";
        }

        error.message = `${error.response.status} ${error.message}`;
    } else
        error.message = `请求失败 原因：` + error.message;

    return Promise.reject(error.message);
});

export function $post(url, params, config = {}) {
    return new Promise((resolve, reject) => {
        axiosIns.post(url, params, config).then(res => {
            if (res.status == 200)
                resolve(res.data);
            else
                reject(`POST请求失败 信息：status=${res.status} statusText=${res.statusText}`);
        }).catch(errmsg => {
            reject(errmsg);
        });
    });
}

export function $get(url, params, config = {}) {
    if (params && typeof (config) == "object") {
        config.params = params;
    }

    return axiosIns.get(url, config).then(res => {
        if (res.status == 200)
            return res.data;
        else
            return Promise.reject(`GET请求失败 信息：status=${res.status} statusText=${res.statusText}`);
    });
}

export function $put(url, params, config = {}) {
    return new Promise((resolve, reject) => {
        axiosIns.put(url, params, config).then(res => {
            if (res.status == 200)
                resolve(res.data);
            else
                reject(`PUT请求失败 信息：status=${res.status} statusText=${res.statusText}`);
        }).catch(errmsg => {
            reject(errmsg);
        });
    });
}

// 传文件
export function $putP(url, params, config = {}) {
    return new Promise((resolve, reject) => {
        axiosInsP.put(url, params, config).then(res => {
            if (res.status == 200)
                resolve(res.data);
            else
                reject(`PUT请求失败 信息：status=${res.status} statusText=${res.statusText}`);
        }).catch(errmsg => {
            reject(errmsg);
        });
    });
}

// 发布兼职
export function $postP(url, params, config = {}) {
    return new Promise((resolve, reject) => {
        axiosInsP.post(url, params, config).then(res => {
            if (res.status == 200)
                resolve(res.data);
            else
                reject(`POST请求失败 信息：status=${res.status} statusText=${res.statusText}`);
        }).catch(errmsg => {
            reject(errmsg);
        });
    });
}

export const $ajax = axiosIns;
