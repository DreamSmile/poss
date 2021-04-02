<template>
  <div id="registerphone">
    <el-form ref="form" :model="form" :rules="rules">
      <el-form-item prop="phone">
        <el-input
          v-model="form.phone"
          placeholder="请输入手机号码"
          :validate-event="false"
        ></el-input>
      </el-form-item>
      <el-form-item prop="pass">
        <el-input
          type="password"
          v-model="form.pass"
          autocomplete="off"
          :validate-event="false"
          placeholder="请输入密码"
        ></el-input>
      </el-form-item>
      <el-form-item class="write_code" prop="code">
        <el-input
          v-model="form.code"
          placeholder="请输入验证码"
          :validate-event="false"
        ></el-input>
        <span class="sendCode" @click="sendCode">{{ times }}</span>
      </el-form-item>
      <el-checkbox v-model="checked">同意poss直聘《用户协议》</el-checkbox>
      <el-button type="primary" @click="regist" :loading="loading"
        >注册</el-button
      >
    </el-form>
    <div class="goLogin">
      已有账号？<span><router-link to="/login">去登录</router-link></span>
    </div>
  </div>
</template>
<script>
export default {
  name: "RegisterPhone",
  data() {
    return {
      form: {
        phone: "",
        pass: "",
        code: "",
      },
      checked: false,
      times: "发送验证码",
      loading: false,
      rules: {
        phone: [
          { required: true, message: "请输入手机号", trigger: "blur" },
          {
            pattern: /^((0\d{2,3}-\d{7,8})|(1[3584]\d{9}))$/,
            message: "请输入合法手机号/电话号",
            trigger: "blur",
          },
        ],
        pass: [
          { required: true, message: "请输入密码", trigger: "blur" },
          {
            min: 6,
            max: 10,
            message: "长度在 6 到 10 个字符",
            trigger: "blur",
          },
        ],
        code: { required: true, message: "请输入验证码" },
      },
    };
  },
  methods: {
    //  发送验证码
    sendCode() {
      if (!this.form.phone) {
        this.$message({
          message: "请先输入手机号码！",
          type: "warning",
        });
        return;
      }
      // this.times = this.$utils.countDown();
      this.$api
        .getCode({ operationType: "signup", phoneNumber: this.form.phone })
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.isErr("获取验证码失败", res.msg);
            return;
          }
        })
        .catch((err) => {
          this.isErr("获取验证码失败", err);
        });
    },
    // 注册
    regist() {
      this.$refs.form.validate((valid) => {
        if (valid && this.checked) {
          this.loading = true;
          this.$api
            .resgistByPhone({
              phoneNumber: this.form.phone,
              password: this.form.pass,
              verifyCode: this.form.code,
            })
            .then((res) => {
              console.log(res);
              console.log(this.form.phone, "验证码：" + this.form.code,+"密码："+this.form.pass);
              if (!res.success) {
                this.$alert("注册失败，原因为：" + res.msg, "错误", {
                  confirmButtonText: "确定",
                });
                return false;
              }
              this.loading = false;
              this.$message({
                message: "注册成功，将为您跳转至登录界面！",
                type: "success",
              });
              setTimeout(() => {
                this.$router.push("/login");
              }, 3000);
            })
            .catch((err) => {
              this.isErr("邮箱注册失败", err);
            });
        }
      });
    },
    isErr(name, msg) {
      this.$message.error(name + "，原因为：" + msg);
      this.loading = false;
      this.form.pass = "";
      this.form.phone = "";
      this.form.code = "";
    },
  },
};
</script>
<style lang="less" scoped>
#registerphone {
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
  margin-top: 30px;
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
</style>