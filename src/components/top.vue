<template>
  <div id="top">
    <div class="bg">
      <div class="inner">
        <router-link to="/">
          <img src="@/assets/imgs/login/logo_white.png" alt="boss直聘" />
        </router-link>
        <div class="nav">
          <ul>
            <li v-show="!message"><router-link to="/">首页</router-link></li>
            <li v-if="$store.state.userData.role == 'merchant'">
              <router-link :to="{ name: 'PushJob', params: { id: 0 } }"
                >发布</router-link
              >
            </li>
            <li v-show="message" class="top_title">{{ message }}</li>
          </ul>
        </div>
      </div>
      <!-- 右侧 -->
      <div class="navData">
        <!-- 未登录区 -->
        <div class="btns">
          <button v-if="!$store.state.accessToken">
            <router-link to="/register">注册</router-link>
          </button>
          <button v-if="!$store.state.accessToken">
            <router-link to="/login">登录</router-link>
          </button>
          <!-- 已登录区 -->
          <span
            v-if="$store.state.accessToken"
            :class="$store.state.diaData.length > 0 ? 'hasDia' : ''"
            ><router-link
              :to="{
                name: 'Dialogue',
                params: { id: 'topF' },
              }"
              >聊天</router-link
            ></span
          >
          <router-link to="/admin" v-if="$store.state.userData.role == 'admin'">
            <span class="user_admin">后台</span></router-link
          >
          <router-link to="/userData">
            <span class="user_name" v-if="$store.state.accessToken">{{
              $store.state.userData.nickName || ""
            }}</span>
            <el-dropdown v-if="$store.state.accessToken">
              <div
                v-if="$store.state.accessToken"
                class="imgs"
                :style="{
                  backgroundImage:
                    'url(' +
                    (this.$store.state.userData.avatar ||
                      require('../assets/imgs/user.jpg')) +
                    ')',
                }"
              ></div>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item @click.native="dialogVisible = true"
                  >修改密码</el-dropdown-item
                >
                <el-dropdown-item @click.native="signOut"
                  >退出</el-dropdown-item
                >
              </el-dropdown-menu>
            </el-dropdown>
          </router-link>
        </div>
      </div>
    </div>
    <!-- 修改密码，退出，注销页面 -->
    <el-dialog
      :modal-append-to-body="false"
      :visible.sync="dialogVisible"
      :close-on-click-modal="false"
      :before-close="clear"
      title="修改密码"
      width="400px"
      height="300px"
    >
      <div class="business_box">
        <el-form ref="form" :model="form">
          <el-input v-model="form.passOld" placeholder="原密码"></el-input>
          <el-input
            placeholder="新密码"
            v-model="form.passNew"
            class="input-with-select"
            style="margin-top: 20px"
          >
          </el-input>
          <el-input
            placeholder="请输入验证码"
            v-model="form.code"
            class="input-with-select"
            style="margin-top: 20px"
          >
          </el-input>
          <span v-show="!times" class="sendCode" @click="sendCodes"
            >发送验证码</span
          >
          <span v-show="times" class="sendCode"
            >{{ times }}秒后重发</span
          ></el-form
        >
        <el-button class="sub" type="primary" @click="sub">提交</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
export default {
  name: "Top",
  data() {
    return {
      dialogVisible: false,
      imgSrc:
        this.$store.state.userData.avatar || require("../assets/imgs/user.jpg"),
      form: {
        passOld: "",
        passNew: "",
        code: "",
      },
      times: null,
    };
  },
  props: ["message"],
  methods: {
    // 有绑定手机号时，修改密码的验证码默认发送给手机，其次邮箱
    sendCodes() {
      const phoneNumber = this.$store.state.userData.phoneNumber;
      const mail = this.$store.state.userData.email;
      phoneNumber ? this.sendPhoneCode(phoneNumber) : this.sendMailCode(mail);
    },
    // 发送手机验证码
    sendPhoneCode(phoneNumber) {
      let num = 60;
      let interval = setInterval(() => {
        this.times = num > 0 ? num-- : clearInterval(interval);
      }, 1000);
      this.$api
        .getCode({
          operationType: "resetPassword",
          phoneNumber: phoneNumber,
        })
        .then((res) => {
          if (!res.success) {
            this.isErr("获取手机验证码失败", res.msg);
            return;
          }
        })
        .catch((err) => {
          this.$message.error("获取手机验证码失败", err);
        });
    },
    // 发送邮箱验证码
    sendMailCode(mail) {
      let num = 60;
      let interval = setInterval(() => {
        this.times = num > 0 ? num-- : clearInterval(interval);
      }, 1000);
      this.$api
        .getCodeByMail({
          operationType: "resetPassword",
          email: mail,
        })
        .then((res) => {
          if (!res.success) {
            this.isErr("获取邮箱验证码失败", res.msg);
            return;
          }
        })
        .catch((err) => {
          this.$message.error("获取邮箱验证码失败", err);
        });
    },
    // 提交修改密码申请
    sub() {
      if (!this.form.passOld || !this.form.passNew || !this.form.code) {
        this.$message.error("请填写完整的新旧密码与验证码！");
        return;
      }
      let pasLen = this.$utils.getByteLen(this.form.passNew);
      if (!(13 > pasLen && pasLen > 5)) {
        this.$message.error("新密码长度应为6-12位~");
        return;
      }
      if (this.form.passOld == this.form.passNew) {
        this.$message.error("新旧密码不可相同~");
        return;
      }
      this.$api
        .resetPass({
          newPassword: this.form.passNew,
          oldPassword: this.form.passOld,
          verifyCode: this.form.code,
        })
        .then((res) => {
          if (!res.success) {
            this.$message.error("修改密码失败，原因为：" + res.msg);
            return;
          }
          this.$message({
            message: "修改密码成功！即将跳转至登录界面！",
            type: "success",
          });
          // 需要重新登录，要把所有用户信息清除
          setTimeout(() => {
            this.$store.commit("clearAll");
            this.$router.push("/login");
          }, 2000);
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    // 退出
    signOut() {
      this.$confirm("是否退出当前账号?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          this.$api
            .logout()
            .then((res) => {
              if (!res.success) {
                $alert("退出账号失败，原因为：" + res.msg);
                return;
              }
              this.$store.commit("clearAll");
              if (this.$route.path != "/") {
                this.$router.push("/");
              }
              try {
                this.$socket.default.onClose();
              } catch (error) {
                console.log(error);
              }
            })
            .catch((err) => {
              console.log(err);
            });
        })
        .catch((err) => {});
    },
    // 关闭修改密码界面
    clear() {
      this.form = {
        passOld: "",
        passNew: "",
        code: "",
      };
      this.dialogVisible = false;
    },
  },
};
</script>
<style scoped lang="less">
#top {
  width: 100%;
  height: 50px;
  position: fixed;
  top: 0;
  left: 0;
  background-color: #162343;
  z-index: 100;
  .bg {
    height: 50px;
    top: 0;
    left: 0;
    width: 80%;
    margin: 0 auto;
    min-width: 900px;
    z-index: 100;
    position: relative;
    .inner {
      box-sizing: border-box;
      position: absolute;
      top: 50%;
      margin-top: -25px;
      height: 100%;
      img {
        width: 140px;
        vertical-align: middle;
        display: inline-block;
        margin-right: 12px;
      }
      .nav {
        display: inline-block;
        vertical-align: middle;
        height: 100%;
        ul {
          text-align: center;
          height: 100%;
          li {
            font-size: 14px;
            float: left;
            color: #fff;
            font-weight: 400;
            width: 89px;
            background-color: transparent;
            font-weight: 400;
            height: 100%;
            margin-top: 15px;
            /deep/a {
              color: #fff;
              text-decoration: none;
            }
            /deep/a:hover {
              color: #8bcdef;
            }
          }
          .top_title {
            padding-left: 14px;
            position: relative;
          }
          .top_title:after {
            content: "";
            width: 2px;
            height: 30px;
            position: absolute;
            background-color: #fff;
            left: 0;
            top: -6px;
          }
        }
      }
    }
    .navData {
      position: absolute;
      right: 20px;
      height: 100%;
      line-height: 50px;
      top: 0;
      .btns {
        display: inline-block;
        .hasDia::after {
          content: ".";
          position: absolute;
          left: 54px;
          top: -26px;
          font-size: 60px;
          color: red;
        }
        button {
          margin: 0 13px;
          width: 54px;
          height: 20px;
          border: 1px solid #0eaaf5;
          opacity: 1;
          border-radius: 20px;
          background-color: transparent;
          /deep/a {
            color: #fff;
            text-decoration: none;
          }
        }
        /deep/.el-badge {
          color: #fff;
          margin: 0 16px;
          cursor: pointer;
          line-height: 48px;
        }
        span {
          color: #fff;
          cursor: pointer;
          line-height: 50px;
          display: inline-block;
          margin-left: 32px;
          font-size: 14px;
          font-weight: 400;
          /deep/a {
            color: #fff;
            text-decoration: none;
          }
          /deep/a:hover {
            color: #8bcdef;
          }
        }

        .user_name {
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          display: inline-block;
          vertical-align: middle;
          line-height: 50px;
          width: 82px;
        }
        .user_name:hover {
          color: #8bcdef;
        }
        .user_admin:hover {
          color: #8bcdef;
        }
        .imgs {
          width: 26px;
          height: 26px;
          border-radius: 50%;
          display: inline-block;
          margin-left: 14px;
          vertical-align: middle;
          background-size: cover;
          background-position: 50%;
          background-color: #ddd;
        }
      }
    }
  }
  /deep/.el-dialog__body {
    padding-top: 10px;
    .business_box {
      position: relative;
      .send_ode {
        color: #0eaaf5;
      }
      .sub {
        width: 100%;
        margin-top: 30px;
      }
      .sendCode {
        color: #0eaaf5;
        position: absolute;
        opacity: 0.7;
        right: 16px;
        bottom: 80px;
        cursor: pointer;
        z-index: 100;
      }
      .sendCode:after {
        content: "";
        width: 2px;
        height: 23px;
        position: absolute;
        top: -2px;
        left: -11px;
        background: #0eaaf5;
        opacity: 0.4;
      }
    }
  }
}
</style>
