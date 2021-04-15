
const mutations = {
    setUserToken(state, data) {
        state.accessToken = data.accessToken ? data.accessToken : null;
        state.refreshToken = data.refreshToken ? data.refreshToken : null;
        state.hasUser = true;
        console.log(state);
    },

    setUserData(state, data) {
        state.userData = {
            avatar: data.avatar,
            applying:data.applying,
            campusInfo: data.campusInfo,
            email: data.email,
            id: data.id,
            joinCount: data.joinCount,
            publishCount: data.publishCount,
            major: data.major,
            nickName: data.nickName,
            phoneNumber: data.phoneNumber,
            role: data.role,
            sex: data.sex,
            signature: data.signature,
            status: data.status
        }
    },
    editUserData(state, data) {
        Object.assign(state.userData, data);
    },
    setDiaData(state,data){//当有数据传入，push进state
        state.diaData.push({
            id:data.id,
            content:data.content,
            createTime:data.createTime,
            fromUser:data.fromUser,
        })
    },
    clearDia(state){//打开了聊天界面就清除top的红点
        state.diaData=[];
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