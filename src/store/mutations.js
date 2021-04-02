
const mutations = {
    setUserToken(state, data) {
        state.accessToken = !data.accessToken ? localStorage.getItem('userToken') : data.accessToken;
        state.refreshToken = !data.refreshToken ? localStorage.getItem('refreshToken') : data.refreshToken;
        state.hasUser = true;
    },
    setUserData(state, data) {
        state.userData = {
            avatar: data.avatar,
            campusInfo: data.campusInfo,
            email: data.email,
            id: data.id,
            joinCount: data.joinCount,
            major: data.major,
            nickName: data.nickName,
            phoneNumber: data.phoneNumber,
            role: data.role,
            sex: data.sex,
            signature: data.signature,
            status: data.status
        }
    },
    getUserToken(state) {
        console.log(state);
        return state;
    },
    getuserData(state) {
        return state.userData;
    },
    clearAll(state) {//当判断出token过期，将所有数据清除，防止获取错误数据
        state.accessToken = '';
        state.refreshToken = '';
        state.hasUser = false;
        state.userData = {}
    },
    gethasUser(state) {
        return state.hasUser;
    }
}

export default mutations;