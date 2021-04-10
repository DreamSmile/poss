import axios from 'axios';
import $store from '../store'

const axiosIns = axios.create({
    timeout: 15 * 1000,
    headers: {
        "Content-Type": "application/json;charset=UTF-8",
    }
});
const axiosInsP = axios.create({
    timeout: 15 * 1000,
    contentType:false,
    processData:false,
    headers: {
        "Content-Type": "multipart/form-data",
        "Accept":"*/*"
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

//类似于.then(()=>{},()=>{});
axiosIns.interceptors.response.use(response => {
    //对响应数据做点处理
    return response;
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
