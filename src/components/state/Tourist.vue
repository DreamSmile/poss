<template>
  <div id="tourist">
    <p class="tourist_title">各大行业职位任你选择</p>
    <el-form ref="form" :model="form">
      <el-form-item>
        <el-input v-model="form.phone" placeholder="请输入手机号码"></el-input>
      </el-form-item>
      <el-form-item class="write_code">
        <el-input v-model="form.code" placeholder="请输入验证码"></el-input>
        <span v-show="!times" class="sendCode" @click="sendCodes"
          >发送验证码</span
        >
        <span v-show="times" class="sendCode">{{ times }}秒后重发</span>
      </el-form-item>
      <el-button type="bttton" @click="sub">登录</el-button>
      <el-checkbox v-model="checked">同意兼职无忧《用户协议》</el-checkbox>
    </el-form>
  </div>
</template>
<script>
export default {
  name: "Tourist",
  data() {
    return {
      form: {
        phone: "",
        code: "",
      },
      checked: false,
      times: null,
    };
  },
  methods: {
    // 发送验证码
    sendCodes() {
      if (!/^((0\d{2,3}-\d{7,8})|(1[3584]\d{9}))$/.test(this.form.phone)) {
        this.$message.error("请输入正确的手机号");
        return false;
      }
      let num = 60;
      let interval = setInterval(() => {
        this.times = num > 0 ? num-- : clearInterval(interval);
      }, 1000);
      this.$api
        .getCode({
          phoneNumber: this.form.phone,
          operationType: "login",
        })
        .then((res) => {
          if (!res.success) {
            this.$message.error("发送验证码失败，原因为：" + res.msg);
            return;
          }
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    // 登录或者注册
    sub() {
      if (
        !/^((0\d{2,3}-\d{7,8})|(1[3584]\d{9}))$/.test(this.form.phone) ||
        !this.form.code
      ) {
        this.$message.error("请填写完整手机号好验证码！");
        return;
      }
      if (!this.checked) {
        this.$message.error("请同意用户协议再登录");
        return;
        
      }
      this.$api
        .loginByCode({
          phoneNumber: this.form.phone,
          verifyCode: this.form.code,
        })
        .then((res) => {
          if (!res.success) {
            this.$message.error("登录失败！原因为：" + res.msg);
            return;
          }
          this.$store.commit("setUserToken", res.data); //将token存到vuex
          this.$router.go(0);
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
  },
};
</script>
<style scoped lang="less">
@import "../../assets/css/common.less";
#tourist {
  margin-top: 20px;
  padding: 20px;
  background-color: @base-color;
  text-align: center;
  padding-top: 0;
  .tourist_title {
    font-size: 16px;
    line-height: 68px;
    color: #fff;
  }
  /deep/.el-checkbox__label,
  .el-checkbox__input,
  .is-checked +,
  .el-checkbox__label {
    color: #fff !important;
    font-size: 12px;
  }
  /deep/ .el-button,
  .el-button--default {
    width: 100%;
    color: @base-color;
    margin-bottom: 10px;
  }
  .sendCode {
    color: #0eaaf5;
    position: absolute;
    opacity: 0.7;
    right: 16px;
    cursor: pointer;
    z-index: 100;
  }
  .sendCode:after {
    content: "";
    width: 2px;
    height: 23px;
    position: absolute;
    top: 9px;
    left: -11px;
    background: #0eaaf5;
    opacity: 0.4;
  }
  .goLogin {
    line-height: 28px;
    color: #c1ccde;
    text-align: center;
    margin-top: 10px;
    span {
      color: #0eaaf5;
      cursor: pointer;
      a {
        color: #0eaaf5;
        text-decoration: none;
      }
    }
  }
}
</style>
