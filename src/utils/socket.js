import $store from '../store'
let socket={
    socketEl:null,//websocket实例
    // 初始化
    init(){
        socket.socketEl = new WebSocket("ws://47.97.157.142:8888/websocket/" + $store.state.userData.id);
        socket.socketEl.onopen = this.onOpen;
        socket.socketEl.onmessage = this.onMessage;
        socket.socketEl.onerror = this.onError;
    },
    onOpen() {
        console.log("连接成功");
      },
    //   发送数据 fromUser:当前登录用户的id，toUser：要发送人的id，content:内容
    socketsend(data){
        console.log(this);//最外层的socket
        console.log(socket.socketEl)//实例
        console.log(data);
        socket.socketEl.send(JSON.stringify(data));
    },
      onMessage(e) {
        console.log("返回数据");
        const redata = JSON.parse(e.data);
        // this.dialogueList.push({
        //   user: "business",
        //   content: redata.content,
        // });
        // this.mess = "";
        console.log(redata);
        return redata;
      },
      onError(e) {
        console.log("连接错误");
        console.log(e);
      },
      onclose(e) {
        console.log("关闭连接");
      },
}
socket.init();


export default socket