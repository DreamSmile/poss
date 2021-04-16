import $store from '../store'
let socket = {
  socketEl: null,//websocket实例
  // 初始化
  init() {
    socket.socketEl = new ReconnectingWebSocket("ws://47.97.157.142:8888/websocket/" + $store.state.userData.id);
    socket.socketEl.onopen = this.onOpen;
    socket.socketEl.onmessage = this.onMessage;
    socket.socketEl.onerror = this.onError;
  },
  onOpen() {
    console.log("连接");
  },
  //   发送数据 fromUser:当前登录用户的id，toUser：要发送人的id，content:内容
  socketsend(data) {
    console.log('发送数据');
    console.log(data);
    socket.socketEl.send(JSON.stringify(data));
  },
  onMessage(e) {
    console.log("返回数据");
    let redata = JSON.parse(e.data);
    console.log(redata);
    $store.commit('setDiaData', {
      id: redata.id,
      content: redata.content,
      createTime: redata.createTime,
      fromUser: redata.fromUser,
      toUser:redata
    })
    return redata;
  },
  onError(e) {
    alert("webSocket连接错误");
    console.log(e);
  },
  onClose(e) {
    console.log("关闭websocket连接");
  },
}
if($store.state.userData.id!=null && $store.state.userData.id!=""){
    socket.init();
}
if($store.state.userData==[]){
  socket.onClose();
}


export default socket