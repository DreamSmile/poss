const state = {
    hasUser: false,
    userToken: '',//当前登录人员的token,弃用
    accessToken: '',//当前登录人员正在使用的token
    refreshToken: '',//当使用的token过期时传给接口获取新token的参数
    userData: {},//当前登录人员的信息
};

export default state;