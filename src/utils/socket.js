import $store from '../store'
import $route from '../router'
let socket = {
  socketEl: null,//websocket实例
  openNum: 0,//连接的次数，短期超过20次判断为错误连接（心跳机制未连接未成功自动重连产生的bug）
  errorNum: 0,//出现websocket连接错误次数，超过5次提醒，未超过自动重连
  // 初始化
  init() {
    if ($store.state.userData.id != undefined) {
      socket.socketEl = new ReconnectingWebSocket("ws://47.97.157.142:8888/websocket/" + $store.state.userData.id);
      socket.socketEl.onopen = this.onOpen;
      socket.socketEl.onmessage = this.onMessage;
      socket.socketEl.onerror = this.onError;
      console.log('初始化websocket');
    }
  },
  onOpen() {
    this.openNum++;
    if (this.openNum > 6) { this.init(); }
    else {
      console.log("连接" + $store.state.userData.id);
    }
    if ($store.state.userData.id == undefined) {
      socket.socketEl.close();
      location.reload();
      console.log('open监听');
    }
  },
  socketsend(data) {//   发送数据 fromUser:当前登录用户的id，toUser：要发送人的id，content:内容
    console.log('发送数据');
    console.log(data);
    if (socket.socketEl.readyState == WebSocket.OPEN) {//判断当前情况是否连接正常
      socket.socketEl.send(JSON.stringify(data));
    } else {
      alert('发生内部错误，可尝试刷新解决该问题！');
    }
  },
  onMessage(e) {//接收返回数据
    console.log("返回数据");
    let redata = JSON.parse(e.data);
    console.log(redata);
    $store.commit('setDiaData', {
      id: redata.id,
      content: redata.content,
      createTime: redata.createTime,
      fromUser: redata.fromUser,
      toUser: redata
    })
    return redata;
  },
  onError(e) {
    this.errorNum++;
    if (this.errorNum > 5) { this.init(); }
    else {
      console.log("webSocket连接错误" + $store.state.userData.id);
      socket.socketEl.close();
    }
  },
  onClose(e) {
    socket.socketEl.close();
    console.log("关闭websocket连接");
  },
}
//监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
window.onbeforeunload = function () {
  socket.onClose();
}

if ($store.state.userData == []) {
  socket.onClose();
}


export default socket