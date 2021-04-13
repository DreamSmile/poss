<template>
  <div id="dialogue">
    <top></top>
    <div class="content">
      <div class="content_flex">
        <div class="user_list">
          <p v-show="userList.length > 0">
            30天内联系人{{ this.$store.state.userData.id }}
          </p>
          <p v-show="userList.length == 0">
            近30天都没有联系人哦~{{ this.$store.state.userData.id }}
          </p>
          <div class="list">
            <div
              class="list_box"
              v-for="(item, i) in userList"
              :key="i"
              @click="getHisByUserId(item, item.avatar ? item.avatar : imgSrc)"
            >
              <!-- getHisByUserId(item.id, item.avatar ? item.avatar : imgSrc) -->
              <div
                class="imgs"
                :style="{
                  backgroundImage:
                    'url(' + (item.avatar ? item.avatar : imgSrc) + ')',
                }"
              ></div>
              <div class="user">
                <p class="user_name">{{ item.nickName }}</p>
                <p class="user_data">
                  {{ item.campus || "未知"
                  }}<el-divider direction="vertical"></el-divider>招聘者
                </p>
              </div>
              <p class="time">11:20</p>
            </div>
          </div>
        </div>
        <div class="dialog_box">
          <div class="box_data">
            <!-- <el-button type="button" @click="testsend">店长发</el-button> -->
            <p class="job_master">
              {{ jobData.nickName || "" }}
              <span>{{ jobData.school || "未知" }}</span>
            </p>
            <!-- <p class="job_data" v-show="jobData.title">
              沟通职位<span class="job_name">{{ jobData.title }}</span
              ><span class="job_money" v-show="jobData.hourlyWage"
                >时薪{{ jobData.money || 0 }}/小时</span
              >
            </p> -->
          </div>
          <div class="box">
            <div
              :class="item.user == 'ours' ? 'box_right' : 'box_left'"
              v-for="(item, i) in dialogueList"
              :key="i"
            >
              <div
                class="imgs"
                :style="{
                  backgroundImage:
                    'url(' +
                    (item.imgSrc ? item.imgSrc : $store.state.userData.avatar) +
                    ')',
                }"
              ></div>
              <p :class="item.user == 'ours' ? 'ours_mess' : 'business_mess'">
                {{ item.content }}
              </p>
            </div>
          </div>
          <div class="dialog_input">
            <el-button @click="sendMess">发送</el-button>
            <el-divider></el-divider>
            <p class="icon">
              <img src="@/assets/imgs/face.png" />
              <img class="photo" src="@/assets/imgs/photo.png" />
            </p>
            <div class="inp">
              <textarea v-model="mess"></textarea>
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
  methods: {
    // 获取聊天人员的列表
    getDialogueList() {
      this.$api
        .getdialogueList()
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.$message.error("获取聊天联系人列表失败，原因为：" + res.msg);
            return;
          }
          for (let i = 0; i < res.data.length; i++) {
            this.userList.push(res.data[i]);
          }
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    //根据传入的路由id获得该工作信息,并且显示历史对话
    getjobData() {
      if (this.$route.params.id && this.$route.params.id != "top") {
        console.log("根据工作获取参数");
        this.$api
          .getJobData({
            pid: this.$route.params.id,
          })
          .then((res) => {
            console.log("根据头部传入的信息，获取工作内容");
            console.log(res);
            if (!res.success) {
              this.$message.error("获得工作信息失败，原因为：" + res.msg);
              return;
            }
            this.jobData = {
              id: res.data.publisher.id,
              nickName: res.data.publisher.nickName,
              avatar: res.data.publisher.avatar,
              school: res.data.campus,
              money: res.data.hourlyWage,
            };
            this.userList.push({
              id: res.data.publisher.id,
              nickName: res.data.publisher.nickName,
              avatar: res.data.publisher.avatar,
              school: res.data.campus,
              money: res.data.hourlyWage,
            });
            this.getHisByUserId(res.data.publisher.id);
          });
      }
    },
    // 根据用户id 显示对应的聊天记录,但传入的参数是所有参数，头像
    getHisByUserId(item, imgurl) {
      this.dialogueList = [];
      this.$api
        .getHisByUserId({
          toUser: item.id,
        })
        .then((res) => {
          if (!res.success) {
            this.$message.error("获取聊天记录失败！原因为：" + res.id);
            return;
          }
          // 生成对应的左侧聊天信息
          this.jobData = {
            id: item.id,
            nickName: item.nickName,
            school: item.campus,
          };
          // 生成对话
          for (let i = 0; i < res.data.length; i++) {
            if (res.data[i].fromUser == item.id) {
              //判断出这条对话是招聘者发的
              this.dialogueList.push({
                user: "business",
                content: res.data[i].content,
                time: res.data[i].createTime,
                imgSrc: imgurl,
              });
            } else {
              this.dialogueList.push({
                user: "ours",
                content: res.data[i].content,
                time: res.data[i].createTime,
              });
            }
          }
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    // 发送信息按钮
    sendMess() {
      // console.log(this.$socket.default);
      // return;
      this.dialogueList.push({
        user: "ours",
        content: this.mess,
      });
      this.$socket.default.socketsend({
        fromUser: this.$store.state.userData.id, //当前登录用户的id,
        toUser: this.jobData.id, //接收人id
        content: this.mess,
      });
      this.mess = "";
    },
    testsend() {
      this.dialogueList.push({
        user: "business",
        content: this.mess,
      });
      this.mess = "";
    },
  },
  data() {
    return {
      imgSrc: require("@/assets/imgs/user.jpg"),
      userList: [],
      jobData: {},
      mess: "", //输入框的内容
      diaData: {
        fromUser: this.$store.state.userData.id,
        toUser: "",
        content: "这是发送内容",
      },
      dialogueList: [], //对话列表，连接webscoket后使用Push的方式模拟对话
      diaJob: {
        nickName: "",
        school: "",
      }, //右侧聊天需要的参数
    };
  },
  mounted() {
    // this.getjobData(); //根据传入的路由id获得该工作信息
    this.getDialogueList(); //获取聊天的人的列表
  },
};
</script>