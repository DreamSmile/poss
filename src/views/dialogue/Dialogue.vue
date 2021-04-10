<template>
  <div id="dialogue">
    <top></top>
    <div class="content">
      <div class="content_flex">
        <div class="user_list">
          <p v-show="userList.length > 1">30天内联系人</p>
          <p v-show="userList.length == 0">
            近30天都没有联系人哦~{{ this.$route.params.id }}
          </p>
          <div class="list">
            <div class="list_box" v-for="(item, i) in userList" :key="i">
              <div
                class="imgs"
                :style="{ backgroundImage: 'url(' + imgSrc + ')' }"
              ></div>
              <div class="user">
                <p class="user_name">林先生</p>
                <p class="user_data">
                  闽江学院<el-divider direction="vertical"></el-divider>招聘者
                </p>
              </div>
              <p class="time">11:20</p>
            </div>
          </div>
        </div>
        <div class="dialog_box">
          <div class="box_data">
            <el-button type="button" @click="testWbscoket">测试webscoket</el-button>
            <p class="job_master">
              {{ jobData.merchantinfo ? jobData.merchantinfo.realName : ""
              }}<span>{{ jobData.workplace || "" }}</span>
            </p>
            <p class="job_data" v-show="jobData.title">
              沟通职位<span class="job_name">{{ jobData.title }}</span
              ><span class="job_money" v-show="jobData.hourlyWage"
                >时薪{{ jobData.hourlyWage || 0 }}/小时</span
              >
            </p>
          </div>
          <div class="box">这是聊天的</div>
          <div class="dialog_input">
            <el-button>发送</el-button>
            <el-divider></el-divider>
            <p class="icon">
              <img src="@/assets/imgs/face.png" />
              <img class="photo" src="@/assets/imgs/photo.png" />
            </p>
            <div class="inp">
              <textarea></textarea>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Top from "../../components/top.vue";
import "./dialogue.less";
export default {
  name: "dialogue",
  components: {
    Top,
  },
  data() {
    return {
      imgSrc: require("@/assets/imgs/user.jpg"),
      userList: [],
      jobData: {},
    };
  },
  mounted() {
    this.getDialogueList(); //获取聊天的人的列表
    this.getjobData(); //根据传入的路由id获得该工作信息
  },
  methods: {
    getDialogueList() {
      this.$api
        .getdialogueList()
        .then((res) => {
          if (!res.success) {
            this.$message.error("获取聊天联系人列表失败，原因为：" + res.msg);
            return;
          }
          console.log(res);
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    //根据传入的路由id获得该工作信息
    getjobData() {
      console.log('获得工作信息');
      if (this.$route.params.id &&this.$route.params.id!='top') {
        this.$api
          .getJobData({
            pid: this.$route.params.id,
          })
          .then((res) => {
            console.log(res);
            if (!res.success) {
              this.$message.error("获得工作信息失败，原因为：" + res.msg);
              return;
            }
            this.jobData = res.data;
          });
      }
    },
    
    // 测试webscoket
    testWbscoket(){
      console.log('点击');
      let ws=new WebSocket('ws://localhost:8080/websocket/'+this.$route.params.id);
       ws.onopen = function (evt) { //连接建立时触发
            console.log("连接上webscoket了");
            console.log(evt);
        }
        ws.onerror = function (event) {
          console.log('设备连接失败');
          console.log(event);
        }
         ws.onmessage = function (evt) { //客户端收到服务端数据
         console.log('服务端返回的数据');
         console.log(evt)
         }
      // ws.onopen = () => {
      //   // Web Socket 已连接上，使用 send() 方法发送数据
      //       ws.send('Holle')
      //       console.log('数据发送中...')
      //   }
      //   ws.onmessage = evt => {
      //   // console.log('数据已接收...')
      //   console.log('数据已接收');
      //   console.log(evt);
      //   }
      //   ws.onclose = function () {
      //   // 关闭 websocket
      //   console.log('连接已关闭...')
      //   }
      //   // 路由跳转时结束websocket链接
      //   this.$router.afterEach(function () {
      //   ws.close()
      //   })
    }

  },
};
</script>