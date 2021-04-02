/*
* 管理本地缓存数据模块
*/

import Cache from 'web-storage-cache';

const lsCache = new Cache();
const ssCache = new Cache({ storage: "sessionStorage" });

const KEYS = {
    userinfo: "userinfo"
}

const namespace = "PAYMENT_AUDIT";

for (let p in KEYS) {
    if (KEYS.hasOwnProperty(p)) {
        KEYS[p] = `${namespace}:${p}`.toUpperCase();
    }
}//end for

class CommonStorage {
    constructor(key, exp = null, type = 'localStorage') {
        this.key = key;
        this.exp = exp;
        this.storage = (type === 'localStorage') ? lsCache : ssCache;
    }

    save(value) {
        const options = this.exp ? { exp: this.exp } : null;
        this.storage.set(this.key, value, options);
    }

    load() {
        return this.storage.get(this.key)
    }

    delete() {
        this.storage.delete(this.key)
    }
}

export const cachedUserInfo = new CommonStorage(KEYS.userinfo, 0);
export { lsCache, ssCache, KEYS as cacheKeys, namespace as cacheSpace };