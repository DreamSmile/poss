import { $post, $get, $put } from './http2.js';
const api = './possApi';

/*注册*/
// 获取邮箱验证码
export function getCodeByMail(data) {
    return $post(api + '/open/send/email', data);
}
// 邮箱注册
export function resistByMail(data) {
    return $post(api + '/open/email/signup', data);
}

// 手机注册
export function resgistByPhone(data) {
    return $post(api + '/open/sms/signup', data);
}



/*登录*/
export function loginByMail(data) {
    return $post(api + '/open/account/login', data);
}

// 手机号登录
export function loginByCode(data) {
    return $post(api + '/open/sms/login', data);
}

// 获取手机号码验证码
export function getCode(data) {
    return $post(api + '/open/send/phone', data);
}

// 重新获取token
export function changeToke(data) {
    return $post(api + '/open/refresh/token', data);
}


/*主页*/
// 获取用户信息
export function getUserData() {
    return $get(api + '/user');
}
// 获取兼职历史列表
export function getJobHis() {
    return $get(api + '/user/join/his/query');
}

// 获取学校列表
export function getSchoolList() {
    return $get(api + '/campus/open/campusList');
}

// 根据传入的学校名称获取兼职列表
export function getJobBySchool(data) {
    return $post(api + '/parttime/query/page', data);
}




/*工作详情页*/
export function getJobData(data) {
    return $post(api + '/parttime/detail', data);
}

/*用户信息*/
// 修改基本信息
export function changeBaseData(data) {
    return $put(api + '/user/basicInfo', data);
}
// 修改头像
export function upImg(data) {
    return $put(api + '/user/avatar/img', data, { 'Content-Type': 'multipart/form-data' });
}

// 绑定手机号
export function bindPhone(data){
    return $put(api+'/user/bind/phone',data);
}

// 绑定邮箱
export function bindMail(data){
    return $put(api+'/user/bind/email',data);
}