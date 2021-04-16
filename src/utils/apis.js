import { $post, $get, $put, $putP, $postP } from './http2.js';
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

// 修改密码
export function resetPass(data) {
    return $put(api + '/user/restPassword', data);
}

// 注销用户
export function logout() {
    return $get(api + '/user/logout');
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

// 获得参加的兼职分页
export function getHisByPage(data){
    return $post(api+'/user/join/his/query/page/',data);
}




/*工作详情页*/
export function getJobData(data) {
    return $post(api + '/parttime/detail', data);
}

// 加入兼职
export function addJob(data) {
    return $post(api + '/user/join/pt', data);
}
// 获得举报列表
export function reportList(){
    return $get(api+'/parttime/report/types');
}
//举报兼职
export function reportJob(data){
    return $post(api+'/user/report',data)
}

// 退出兼职
export function outJob(data) {
    return $post(api + '/user/exit/pt', data);
}
/*用户信息*/
// 修改基本信息
export function changeBaseData(data) {
    return $put(api + '/user/basicInfo', data);
}
// 修改头像
export function upImg(data) {
    return $putP(api + '/user/avatar/img', data);
}

// 绑定手机号
export function bindPhone(data) {
    return $put(api + '/user/bind/phone', data);
}

// 绑定邮箱
export function bindMail(data) {
    return $put(api + '/user/bind/email', data);
}

// 修改绑定后的邮箱
export function editbindMail(data){
    return $post(api+'/user/reset/email',data);
}

// 修改绑定的手机号
export function editBindPhone(data){
    return $post(api+'/user/reset/phone',data);
}

// 分页查看加入的兼职历史
export function getAddHisByPage(data){
    return $post(api+'/user/join/his/query/page/',data);
}
// 查看是否有资格成为商家
export function isGobusiness(){
    return $get(api+'/user/apply/prepare');
}

// 成为商家
export function toBusiness(data) {
    return $post(api + '/user/apply/turn', data);
}


/*商家功能*/
// 获取发布过的兼职列表,所有不分页
export function getPushJobHis(data) {
    return $get(api + '/merchant/pblish/already', data);
}
// 获取分页发布的兼职列表
export function getPushByPage(data){
    return $post(api+'/merchant/pblish/already/page',data);
}
// 删除工作申请工作的某个学生
export function selUserById(data){
    return $put(api+'/merchant/pt/user/remove',data);
}
// 商家发布兼职
export function pushJob(data) {
    return $postP(api + '/merchant/publish', data);
}
// 商家修改兼职
export function editJob(data) {
    return $putP(api + '/merchant/modify', data);
}
// 将兼职状态设置为开始
export function ingJob(data) {
    return $put(api + '/merchant/pt/breakupRecruit', data);
}
// 将兼职状态改为结束
export function overJob(data) {
    return $put(api + '/merchant/pt/end', data);
}
// 删除兼职
export function delJob(data) {
    return $post(api + '/merchant/pt/delete', data);
}

/*聊天*/
// 获取于用户所有存在聊天历史的聊天用户
export function getdialogueList(){
    return $get(api+'/user/chat');
}

// 获取对应用户的聊天记录
export function getHisByUserId(data){
    return $post(api +'/user/chat/record',data);
}