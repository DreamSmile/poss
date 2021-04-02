// 倒计时
export function countDown() {
    let num = 60;
    let interval = setInterval(() => {
        let test = num > 0 ? num-- : clearInterval(interval);
        console.log(test);
        return test
    }, 1000);
}

export function returntime(time) {
    return time;
}

// 登录后将token存入localstorage，并提交给state
export function setLocalToken(name, obj) {
    localStorage.setItem(name, JSON.stringify(obj));
}
// 获取token中的数据
export function getLocalToken(name) {
    return localStorage.getItem(name);
}
// 移除token中的数据
export function removeLocalToken(name) {
    localStorage.removeItem(name);
}
