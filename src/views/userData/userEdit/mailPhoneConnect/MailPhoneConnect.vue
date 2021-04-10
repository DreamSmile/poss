<template>
  <div id="mailPhoneEdit">
    <top message="绑定信息"></top>
    <!-- 主要修改区 -->
    <div class="content">
      <p class="content_title">poss直聘通行证</p>
      <div class="main">
        <hr />
        <el-tabs v-model="activeName" stretch @tab-click="handleClick">
          <el-tab-pane label="綁定手机号" name="first"
            ><div class="forms">
              <el-form ref="formPhone" :model="formPhone" :rules="rules">
                <el-form-item prop="phoneNew">
                  <el-input
                    placeholder="请输入手机号"
                    v-model="formPhone.phoneNew"
                    style="margin-top: 20px"
                    :validate-event="false"
                  >
                  </el-input>
                </el-form-item>
                <el-form-item prop="code">
                  <el-input
                    placeholder="请输入验证码"
                    v-model="formPhone.code"
                    class="input-with-select"
                    :validate-event="false"
                  >
                    <span slot="prepend">验证码</span>
                    <span slot="append" v-show="times" class="send_ode"
                      >{{ times }}秒后重发</span
                    >
                    <span
                      slot="append"
                      v-show="!times"
                      class="send_ode"
                      @click="sendCode"
                      >发送验证码</span
                    >
                  </el-input></el-form-item
                ></el-form
              >
              <el-button class="sub" type="primary" @click="upPhone"
                >提交</el-button
              >
            </div></el-tab-pane
          >
          <el-tab-pane label="綁定邮箱" name="second"
            ><div class="forms">
              <el-form ref="formMail" :model="formMail" :rules="rules">
                <el-form-item prop="MailNew">
                  <el-input
                    style="margin-top: 16px"
                    v-model="formMail.MailNew"
                    placeholder="新邮箱"
                    :validate-event="false"
                  ></el-input>
                </el-form-item>
                <el-form-item prop="codeM">
                  <el-input
                    placeholder="请输入验证码"
                    v-model="formMail.codeM"
                    class="input-with-select"
                    :validate-event="false"
                  >
                    <span slot="prepend">验证码</span>
                    <span slot="append" v-show="timesM" class="send_ode"
                      >{{ timesM }}秒后重发</span
                    >
                    <span
                      slot="append"
                      v-show="!timesM"
                      class="send_ode"
                      @click="sendCodeM"
                      >发送验证码</span
                    >
                  </el-input></el-form-item
                >
              </el-form>
              <el-button class="sub" type="primary" @click="upMail">提交</el-button>
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
      times: null,
      timesM: null,
      formPhone: {
        phoneNew: "",
        select: "+86",
        code: "",
      },
      formMail: {
        mailNew: "",
        codeM: "",
      },
      rules: {
        phoneNew: [
          { required: true, message: "请输入手机号", trigger: "blur" },
          {
            pattern: /^((0\d{2,3}-\d{7,8})|(1[3584]\d{9}))$/,
            message: "请输入合法手机号/电话号",
            trigger: "blur",
          },
        ],
        mail: [
          { required: true, message: "请输入邮箱地址" },
          {
            type: "email",
            message: "请输入正确的邮箱地址",
          },
        ],
        code: { required: true, message: "请输入验证码" },
        codeM: { required: true, message: "请输入验证码" },
      },
      
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
      // console.log(tab);
      // console.log(event);
    },
    // 发送手机验证码
    sendCode() {
      if (
        !/^((0\d{2,3}-\d{7,8})|(1[3584]\d{9}))$/.test(this.formPhone.phoneNew)
      ) {
        this.$message.error("请输入正确的手机号码！");
        return;
      }
      let num = 60;
      let interval = setInterval(() => {
        this.times = num > 0 ? num-- : clearInterval(interval);
      }, 1000);
      this.$api
        .getCode({
          operationType: "bind",
          phoneNumber: this.formPhone.phoneNew,
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
    // 发送邮箱验证码
    sendCodeM() {
      console.log(this.formMail.MailNew);
      if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/.test(this.formMail.MailNew)) {
        this.$message.error("请输入正确的邮箱！");
        return;
      }
      let num = 60;
      let interval = setInterval(() => {
        this.timesM = num > 0 ? num-- : clearInterval(interval);
      }, 1000);
      console.log(this.formMail.MailNew);
      this.$api
        .getCodeByMail({
          operationType: "bind",
          email: this.formMail.MailNew,
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
    // 手机确定绑定
    upPhone() {
      this.$refs.formPhone.validate((valid) => {
        if (valid) {
          this.$api
            .bindPhone({
              phoneNumber: this.formPhone.phoneNew,
              verifyCode: this.formPhone.code,
            })
            .then((res) => {
              if (!res.success) {
                this.$alert("绑定手机号失败！原因为：" + res.msg);
                return;
              }
              this.$message({
                message: "绑定手机号成功！",
                type: "success",
              })
              
              }).catch((err) => {
                this.$message.error(err);
              });

              setTimeout(() => {
                this.$router.push("/userEdit");
              }, 2000);
            };
      });
    },
    // 邮箱确定绑定
    upMail() {
      this.$refs.formMail.validate((valid) => {
        if (valid) {
          this.$api
            .bindMail({
              email: this.formMail.MailNew,
              verifyCode: this.formMail.codeM,
            })
            .then((res) => {
              if (!res.success) {
                this.$alert("绑定邮箱失败！原因为：" + res.msg);
                return;
              }
              this.$message({
                message: "绑定邮箱成功！",
                type: "success",
              }).catch((err) => {
                this.$message.error(err);
              });
              setTimeout(() => {
                this.$router.push("/userEdit");
              }, 2000);
            });
        }
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
      /deep/ .el-select .el-input {
        width: 90px;
      }
      /deep/ .input-with-select .el-input-group__prepend {
        background-color: #fff;
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