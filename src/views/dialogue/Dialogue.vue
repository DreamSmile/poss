<template>
  <div id="dialogue">
    <top></top>
    <div class="content">
      <div class="content_flex">
        <!-- 左侧列表 -->
        <div class="user_list">
          <p v-show="userList.length > 0">30天内联系人</p>
          <p v-show="userList.length == 0">近30天都没有联系人哦~</p>
          <div class="list">
            <el-scrollbar style="height: 100%">
              <div
                :class="[{ list_active: i == isActive }, 'list_box']"
                v-for="(item, i) in userList"
                :key="i"
                @click="
                  getHisByUserId(
                    item,
                    item.avatar ? item.avatar : imgSrc,
                    $event,
                    i
                  )
                "
              >
                <div
                  class="imgs"
                  :class="{ isHas: i == item.isHas }"
                  :style="{
                    backgroundImage:
                      'url(' + (item.avatar ? item.avatar : imgSrc) + ')',
                  }"
                ></div>
                <div class="user">
                  <p class="user_name">{{ item.nickName }}</p>
                  <p class="user_data">
                    {{ item.campus || "未知"
                    }}<el-divider direction="vertical"></el-divider
                    >{{
                      item.role == "admin"
                        ? "管理员"
                        : item.role == "merchant"
                        ? "招聘者"
                        : "求职者"
                    }}
                  </p>
                </div>
                <!-- <p class="time">11:20</p> -->
              </div>
            </el-scrollbar>
          </div>
        </div>
        <!-- 右侧 -->
        <div class="dialog_box">
          <div class="box_data">
            <p class="job_master">
              {{ jobData.nickName || "" }}
              <span>{{ jobData.school || "" }}</span>
            </p>
            <!-- <p class="job_data" v-show="jobData.title">
              沟通职位<span class="job_name">{{ jobData.title }}</span
              ><span class="job_money" v-show="jobData.hourlyWage"
                >时薪{{ jobData.money || 0 }}/小时</span
              >
            </p> -->
          </div>
          <div class="box" ref="box" v-loading="loading">
            <div class="box_no" v-show="jobData.nickName == null">
              <i class="el-icon-set-up icon"></i>
              <p class="tip">与您沟通过的人员都会在左侧列表展示</p>
            </div>
            <div
              :class="item.user == 'ours' ? 'box_right' : 'box_left'"
              v-for="(item, i) in dialogueList"
              :key="i"
            >
              <div
                :class="['imgs', { isHasData: item.isHas == 1 }]"
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
            <el-button size="mini" @click="sendMess">发送</el-button>
            <el-divider></el-divider>
            <!-- <p class="icon">
              <img src="@/assets/imgs/face.png" />
              <img class="photo" src="@/assets/imgs/photo.png" />
            </p> -->
            <div class="inp">
              <textarea v-model="mess" @keydown="messageSend"></textarea>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
// import {state} from 'vuex'
import Top from "../../components/top.vue";
import "./dialogue.less";
export default {
  name: "dialogue",
  components: {
    Top,
  },
  watch: {
    "$store.state.diaData"(data) {
      if (this.$route.name == "Dialogue") {
        this.setDia(data);
      }
    },
  },
  methods: {
    // 取出state中的数据，取消top上的红点
    getStateData() {
      this.setDia(this.$store.state.diaData);
    },
    // 监听到的返回对话内容
    setDia(data) {
      if (data.lenegth < 1) {
        return;
      }
      //监听聊天信息改变
      if (this.$store.state.diaData.length < 1) {
        //数据空一般是已经循环过清空了
        return;
      }
      for (let index = 0; index < data.length; index++) {
        // 页面上显示的刚好就是当先监听到的用户对话页面
        if (
          data[index].fromUser == this.jobData.id &&
          this.jobData.nickName != null
        ) {
          this.dialogueList.push({
            user: "business",
            content: data[index].content,
            time: data[index].createTime,
            imgSrc: this.jobData.avatar,
            fromUser: data[index].fromUser,
          });
          this.$nextTick(() => {
            let container = this.$refs.box;
            container.scrollTop = container.scrollHeight;
          });
          continue; //跳出此次循环，不用判断是不是界面其他联系人
        }
        // 如果会话是其他用户发的，将用户列表时间变成红色
        for (let i = 0; i < this.userList.length; i++) {
          if (data[index].fromUser == this.userList[i].id) {
            console.log("有用户信息");
            this.userList[i].isHas = 1;
          }
        }
      }
      // 循环生成完就清空
      this.$store.commit("clearDia");
    },
    // 获取聊天人员的列表
    getDialogueList() {
      this.$api
        .getdialogueList()
        .then((res) => {
          if (!res.success) {
            this.$message.error("获取聊天联系人列表失败，原因为：" + res.msg);
            return;
          }
          for (let i = 0; i < res.data.length; i++) {
            let data = res.data[i];
            data["isHas"] = -1;
            this.userList.push(data);
          }
          // setTimeout(() => {
          this.getStateData(); //state中有存储信息，这步模拟点击进来top上的红点取消
          // }, 4000);
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    //根据传入的路由id获得该工作信息,并且显示历史对话
    getjobData() {
      if (this.$route.params.id && this.$route.params.id != "topF") {
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
            this.jobData = {
              id: res.data.publisher.id,
              nickName: res.data.publisher.nickName,
              avatar: res.data.publisher.avatar,
              school: res.data.campus,
              money: res.data.hourlyWage,
            };
            for (let i = 0; i < this.userList.length; i++) {
              if (res.data.publisher.id == this.userList[i].id) {
                //判断出现在要交流的用户刚好在聊天人的列表
                let item = {
                  id: res.data.publisher.id,
                  nickName: res.data.publisher.nickName,
                  avatar: res.data.publisher.avatar,
                  school: res.data.campus,
                  money: res.data.hourlyWage,
                  isHas: -1,
                };
                this.getHisByUserId(item, item.avatar, item, i);
              }
            }
          });
      }
    },
    // 根据用户id 显示对应的聊天记录,但传入的参数是所有参数，头像
    getHisByUserId(item, imgurl, el, index) {
      this.loading = true;
      this.isActive = index; //当前点击的列表背景颜色变
      item.isHas = -1; //取消界面上的红点
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
            avatar: item.avatar,
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
                fromUser: res.data[i].fromUser,
              });
            } else {
              this.dialogueList.push({
                user: "ours",
                content: res.data[i].content,
                time: res.data[i].createTime,
                fromUser: res.data[i].fromUser,
              });
            }
          }
          this.$nextTick(() => {
            let container = this.$refs.box;
            container.scrollTop = container.scrollHeight;
            this.loading = false;
          });
        })
        .catch((err) => {
          this.$message.error(err);
          this.loading = false;
        });
    },
    //输入框回车发送信息
    messageSend(event) {
      if (event.keyCode === 13) {
        this.sendMess();
      }
    },
    // 发送信息按钮
    sendMess() {
      if (this.mess == "" || this.mess == null) {
        this.$message.error("不允许发送空内容~");
        return;
      }
      if (this.jobData.id == undefined) {
        this.$message.error("请选择对话人员再发信息哦~");
        this.mess = "";
        return;
      }
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
      this.$nextTick(() => {
        let container = this.$refs.box;
        container.scrollTop = container.scrollHeight;
      });
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
      isActive: -1,
      loading: false,
    };
  },
  mounted() {
    this.getDialogueList(); //获取聊天的人的列表
    this.getjobData(); //根据传入的路由id获得该工作信息
    this.$socket.default.init();
  },
};
</script>