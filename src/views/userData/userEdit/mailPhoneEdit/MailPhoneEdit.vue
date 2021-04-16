<template>
  <div id="mailPhoneEdit">
    <top message="修改信息"></top>
    <!-- 主要修改区 -->
    <div class="content">
      <p class="content_title">兼职无忧通行证</p>
      <div class="main">
        <hr />
        <el-tabs v-model="activeName" stretch @tab-click="handleClick">
          <el-tab-pane label="修改手机号" name="first"
            ><div class="forms">
              <el-form
                ref="form"
                :model="formPhone"
                label-width="80px"
                size="mini"
              >
                <el-input
                  style="margin-top: 16px"
                  v-model="formPhone.phoneOld"
                  :disabled="true"
                  placeholder="原手机号"
                ></el-input>
                <el-input
                  placeholder="请输入验证码"
                  v-model="formPhone.code"
                  class="input-with-select"
                  style="margin-top: 20px"
                >
                  <span slot="prepend">验证码</span>
                  <span
                    v-show="!times"
                    slot="append"
                    class="send_ode"
                    @click="sendCodes"
                    >发送验证码</span
                  >
                  <span v-show="times" slot="append" class="send_ode"
                    >{{ times }}秒后重发</span
                  >
                </el-input></el-form
              >
              <el-button
                class="sub"
                type="primary"
                :disabled="hasph"
                @click="editPhone"
                >提交</el-button
              >
            </div></el-tab-pane
          >
          <!-- 邮箱修改 -->
          <el-tab-pane label="修改邮箱" name="second"
            ><div class="forms">
              <el-form
                ref="form"
                :model="formMail"
                label-width="80px"
                size="mini"
              >
                <el-input
                  style="margin-top: 16px"
                  v-model="formMail.mailOld"
                  placeholder="旧邮箱"
                  :disabled="true"
                ></el-input>

                <el-input
                  placeholder="请输入验证码"
                  v-model="formMail.codeM"
                  class="input-with-select"
                  style="margin-top: 20px"
                >
                  <span slot="prepend">验证码</span>
                  <span slot="append" v-show="timesM" class="send_ode"
                    >{{ timesM }}秒后重发</span
                  >
                  <span
                    slot="append"
                    v-show="!timesM"
                    class="send_ode"
                    @click="senCodeByMail"
                    >发送验证码</span
                  >
                </el-input></el-form
              >
              <el-button class="sub" type="primary" @click="editMail"
                >提交</el-button
              >
            </div></el-tab-pane
          >
        </el-tabs>
      </div>
    </div>
  </div>
</template>
<script>
import top from "../../../../components/top";
export default {
  name: "MailPhoneEdit",
  components: {
    top,
  },
  data() {
    return {
      activeName: "first",
      formPhone: {
        phoneOld: this.$store.state.userData.phoneNumber,
        code: "",
      },
      hasph: false,
      formMail: {
        mailOld: this.$store.state.userData.email,
        codeM: "",
      },
      hasma: false,
      times: null,
      timesM: null,
    };
  },
  mounted() {
    this.setData();
  },
  methods: {
    setData() {
      this.$route.params.type == "phone"
        ? (this.activeName = "first")
        : (this.activeName = "second");
    },
    // 点击tab弹出提示，已经绑定过邮箱是否重新绑定
    handleClick(tab, event) {
      let hasPhone =
        this.$store.state.userData.phoneNumber == null ? false : true;
      let hasMail = this.$store.state.userData.email == null ? false : true;
      if (this.activeName == "first" && !hasPhone) {
        //手机编辑
        this.$message({
          message: "您还未绑定手机号，不可以修改哦！",
          type: "warning",
        });
        this.hasph = true;
      }
      if (this.activeName == "second" && !hasMail) {
        this.$message({
          message: "您还未绑定邮箱号，不可以修改哦！",
          type: "warning",
        });
        this.hasma = true;
      }
    },
    // 发送邮箱验证码
    senCodeByMail() {
      let num = 60;
      let interval = setInterval(() => {
        this.timesM = num > 0 ? num-- : clearInterval(interval);
      }, 1000);
      this.$api
        .getCodeByMail({
          operationType: "restEmail",
          email: this.formMail.mailOld,
        })
        .then((res) => {
          if (!res.success) {
            this.$alert("发送验证码失败，原因为：" + res.msg);
            return;
          }
        })
        .catch((err) => {
          this.$message.error("发送验证码错误" + err);
        });
    },
    // 确定修改邮箱，修改后再去绑定邮箱
    editMail() {
      if (!this.formMail.codeM) {
        this.$message.error("请输入验证码！");
        return;
      }
      this.$api
        .editbindMail({
          verifyCode: this.formMail.codeM,
          email: this.formMail.mailOld,
        })
        .then((res) => {
          if (!res.success) {
            this.$alert("修改邮箱失败，原因为：" + res.msg);
            return;
          }
          this.$message({
            message: "即将转入绑定邮箱界面，请绑定新邮箱！",
            type: "success",
          });
          // 修改邮箱成功，再去绑定邮箱
          setTimeout(() => {
            this.$router.push("/mailPhoneConnect/phone");
          }, 2000);
        })
        .catch((err) => {
          this.$message.error("修改邮箱失败错误" + err);
        });
    },
    // 发送验证码到旧手机号
    sendCodes() {
      if (this.hasph) {
        return;
      }
      let num = 60;
      let intervalphone = setInterval(() => {
        this.times = num > 0 ? num-- : clearInterval(intervalphone);
      }, 1000);
      this.$api
        .getCode({
          operationType: "restPhone",
          phoneNumber: this.formPhone.phoneOld,
        })
        .then((res) => {
          if (!res.success) {
            this.$alert("发送验证码失败，原因为：" + res.msg);
            return;
          }
        })
        .catch((err) => {
          this.$message.error("发送验证码错误" + err);
        });
    },
    // 修改手机号
    editPhone() {
      if (!this.formPhone.code) {
        this.$message.error("请输入验证码！");
        return;
      }
      // 验证都通过提起修改
      this.$api
        .editBindPhone({
          phoneNumber: this.formPhone.phoneOld,
          verifyCode: this.formPhone.code,
        })
        .then((res) => {
          if (!res.success) {
            this.$message.error("修改绑定的手机号失败，原因为：" + res.msg);
            return;
          }
          this.$message({
            message: "即将转入绑定手机界面，请绑定新手机！",
            type: "success",
          });
          // 可以修改后，跳转到绑定界面
          setTimeout(() => {
            this.$router.push("/mailPhoneConnect/phone");
          }, 2000);
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
  },
};
</script>
<style scoped lang="less">
@import "../../../../assets/css/common.less";
#mailPhoneEdit {
  .content {
    width: 70%;
    margin: 0 auto;
    margin-top: 50px;
    .content_title {
      line-height: 54px;
      color: @font-color;
      font-weight: bold;
      font-size: 16px;
      padding-top: 10px;
    }
    .main {
      hr {
        background-color: #e4e7ed;
        border: none;
        height: 2px;
        width: 70%;
        margin: 0 auto;
        position: absolute;
        top: 152px;
        left: 0;
        right: 0;
      }
      .forms {
        width: 400px;
        margin: 0 auto;
        .sub {
          width: 100%;
          margin-top: 40px;
        }
      }
      /deep/.el-tabs__item {
        color: #e4e7ed;
      }
      /deep/.is-active {
        color: #409eff !important;
      }
      /deep/.el-tabs__header {
        margin-left: auto;
        margin-right: auto;
        width: 50%;
      }

      /deep/.el-input-group__append {
        background-color: #fff;
        cursor: pointer;
        color: @base-color;
      }
    }
  }
}
</style>