<template>
  <div id="loginPhone">
    <el-form ref="form" :model="form" :rules="rules">
      <el-form-item prop="phone">
        <el-input
          v-model="form.phone"
          placeholder="请输入手机号码"
          :validate-event="false"
        ></el-input>
      </el-form-item>
      <el-form-item prop="code" class="write_code">
        <el-input
          v-model="form.code"
          placeholder="请输入验证码"
          :validate-event="false"
        ></el-input>
        <span class="sendCode" @click="sendCode" v-if="isSend">{{
          times
        }}</span>
        <span class="sendCode" @click="sendCode" v-else>发送验证码</span>
      </el-form-item>
      <el-button type="primary" @click="login" :loading="loading"
        >登录</el-button
      >
    </el-form>
    <div class="goLogin">
      没有账号？<span><router-link to="/register">去注册</router-link></span>
    </div>
  </div>
</template>

<script>
export default {
  name: "LoginPhone",
  data() {
    return {
      form: {
        phone: "",
        code: "",
      },
      loading: false,
      isSend: false,
      times: "60",
      rules: {
        phone: [
          { required: true, message: "请输入手机号", trigger: "blur" },
          {
            pattern: /^((0\d{2,3}-\d{7,8})|(1[3584]\d{9}))$/,
            message: "请输入合法手机号",
            trigger: "blur",
          },
        ],
        code: {
          required: true,
          message: "请输入验证码",
        },
      },
    };
  },
  methods: {
    //  发送验证码
    sendCode() {
      // this.isSend=true;
      // this.times=this.$utils.countDown();
      if (!/^((0\d{2,3}-\d{7,8})|(1[3584]\d{9}))$/.test(this.form.phone)) {
        this.$message.error("请输入正确的手机号码！");
        return;
      }
      this.isSend = true;
      this.times = "已发送。。。";
      this.$api
        .getCode({
          operationType: "login",
          phoneNumber: this.form.phone,
        })
        .then((res) => {
          if (!res.success) {
            this.isErr("获取验证码失败", res.msg);
            return;
          }
        })
        .catch((err) => {
          this.isErr("获取验证码失败", err);
        });
    },
    // 登录
    login() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.loading = true;
          this.$api
            .loginByCode({
              phoneNumber: this.form.phone,
              verifyCode: this.form.code,
            })
            .then((res) => {
              if (res.success) {
                this.$message({
                  type: "success",
                  message: "登录成功！即将为您跳转至首页",
                });
                this.$utils.setLocalToken("userToken", res.data.accessToken); //将token放入缓存
                this.$store.commit("setUserToken", res.data.accessToken); //将token存到vuex
                setTimeout(() => {
                  this.$router.push("/");
                }, 2000);
              } else {
                this.isErr("登录失败", res.msg);
              }
            })
            .catch((err) => {
              this.isErr("登录失败", err);
            });
        }
      });
    },
    isErr(name, msg) {
      this.$alert(name + "，原因为：" + msg);
      this.loading = false;
      this.form.phone = "";
      this.form.code = "";
    },
  },
};
</script>
<style lang="less" scoped>
#loginPhone {
  margin-top: 20px;
}
/deep/.el-checkbox__label,
.el-checkbox__input,
.is-checked +,
.el-checkbox__label {
  color: #8392a7 !important;
}
/deep/ .el-button--primary {
  width: 100%;
  margin-top: 40px;
}
.write_code {
  position: relative;
}
.sendCode {
  color: #0eaaf5;
  position: absolute;
  right: 16px;
  cursor: pointer;
}
.sendCode:after  {
  content: "";
  width: 2px;
  height: 20px;
  position: absolute;
  top: 10px;
  left: -11px;
  background: #0eaaf5;
  opacity: 0.7;
}
.goLogin {
  line-height: 28px;
  color: #c1ccde;
  text-align: center;
  margin-top: 20px;
  span {
    color: #0eaaf5;
    cursor: pointer;
    a {
      color: #0eaaf5;
      text-decoration: none;
    }
  }
}
</style>