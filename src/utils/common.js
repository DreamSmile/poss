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

// 时间格式化，传入2021-04-06 01:10:35，返回2021.04.06
export function returnData(date) {
    return date.trim().split(" ")[0].replace(/\-/g, '\.');
}
// 中国标准时间转换为2021-04-06
export function returntimes(time) {
    var d = new Date(time);
    return d.getFullYear() + '-' + return0(d.getMonth() + 1) + '-' + return0(d.getDate()) + ' ' + return0(d.getHours()) + ':' + return0(d.getMinutes()) + ':00';
}
//去除时间的所有特殊字符，如2020-10-02 00:08:03=>20201002000803
export function timeOut(time) {
    return time.replace(/\-/g, '').replace(/\:/g, '').replace(/\s*/g, "");
}

//获取当前年月日时分秒
export function getNowTime() {
    let time = new Date();
    return time.getFullYear() + return0(time.getMonth() + 1) + return0(time.getDate()) + return0(time.getHours()) + return0(time.getMinutes()) + '00';
}
// 获取当前时间6小时后
export function getSixHours() {
    let times = new Date();
    var addHour = times.setHours(times.getHours() + 6);
    let time = new Date(addHour);
    return time.getFullYear() + return0(time.getMonth() + 1) + return0(time.getDate()) + return0(time.getHours()) + return0(time.getMinutes()) + '00';
}

function return0(s) {
    return s < 10 ? '0' + s : s;
}
// 数组去重
export function deteleObject(obj) {
    var uniques = [];
    var stringify = {};
    for (var i = 0; i < obj.length; i++) {
        var keys = Object.keys(obj[i]);
        keys.sort(function (a, b) {
            return (Number(a) - Number(b));
        });
        var str = '';
        for (var j = 0; j < keys.length; j++) {
            str += JSON.stringify(keys[j]);
            str += JSON.stringify(obj[i][keys[j]]);
        }
        if (!stringify.hasOwnProperty(str)) {
            uniques.push(obj[i]);
            stringify[str] = true;
        }
    }
    uniques = uniques;
    return uniques;
}

//   获取字符串长度（汉字算两个字符，字母算一个）
export function getByteLen(val) {
    var len = 0;
    for (var i = 0; i < val.length; i++) {
        var a = val.charAt(i);
        if (a.match(/[^\x00-\xff]/ig) != null) {
            len += 2;
        } else {
            len += 1;
        }
    }
    return len;
}
