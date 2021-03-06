import { $post, $get, $put, $putP, $postP } from './http2.js';
const api = './possApi';

/*首页*/
export function getBase(){
    return $get(api+'/admin/fetch/management/basic');
}
// 根据日期获取日志
export function getDateListByDate(data){
    return $post(api+'/admin/query/operation/his',data);
}

// 分页获取用户列表
export function getUserByPage(data) {
    return $post(api + '/admin/fetch/user/list/page', data);
}
// 根据用户id获取用户其他详情信息
export function getUserInfoById(data) {
    return $post(api + '/admin/fetch/user/detail', data);
}

// 根据用户id和封禁时长封禁用户
export function banUser(data) {
    return $post(api + '/admin/lock/account', data);
}
// 根据用户id解封用户
export function unsealUser(data) {
    return $post(api + '/admin/unlock/account', data);
}

/*商家管理*/
// 获取分页商家列表
export function getMerchantByPage(data) {
    return $post(api + '/admin/fetch/merchant/list/page', data);
}
// 根据用户id查看商家证明
export function getCertifyById(data) {
    return $post(api + '/admin/fetch/merchant/certify', data);
}

/*商家申请*/
// 分页获取未处理的商家申请
export function getapplyByPage(data) {
    return $post(api + '/admin/fetch/untreated/apply', data);
}
// 处理商家申请，同意或者不同意
export function handleApply(data) {
    return $post(api + '/admin/process/apply', data);
}

/*学校管理*/
// 增加学校
export function addSchool(data) {
    return $post(api + '/admin/campus/add', data);
}
// 文件上传学校
export function upSchoolFile(data){
    return $postP(api+'/admin/campus/add/file',data);
}


/*举报管理*/
// 分页查看所有举报信息
export function getReportByPage(data) {
    return $post(api + '/admin/fetch/report/page', data);
}
// 将举报信息设置成已经处理
export function setReportByIdArr(data) {
    return $post(api + '/admin/process/report', data);
}