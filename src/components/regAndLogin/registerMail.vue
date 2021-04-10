<template>
  <div id="registerMail">
    <el-form ref="form" :model="form">
      <el-form-item
        prop="email"
        :rules="[
          { required: true, message: '请输入邮箱地址' },
          {
            type: 'email',
            message: '请输入正确的邮箱地址',
          },
        ]"
      >
        <el-input
          v-model="form.email"
          :validate-event="false"
          placeholder="请输入邮箱号码"
        ></el-input>
      </el-form-item>
      <el-form-item
        :rules="[
          { required: true, message: '请输入密码', trigger: 'blur' },
          {
            min: 6,
            max: 10,
            message: '长度在 6 到 10 个字符',
            trigger: 'blur',
          },
        ]"
      >
        <el-input
          type="password"
          v-model="form.pass"
          autocomplete="off"
          placeholder="请输入密码"
          :validate-event="false"
        ></el-input>
      </el-form-item>
      <el-form-item :rules="{ required: true, message: '请输入验证码' }">
        <el-input
          :validate-event="false"
          v-model="form.code"
          placeholder="请输入验证码"
        ></el-input>
        <!-- <span class="sendCode" @click="sendCode">{{ times }}</span> -->
        <span class="sendCode" @click="sendCode" v-show="!times"
          >发送验证码</span
        >
        <span class="sendCode" @click="sendCode" v-show="times"
          >{{ times }}秒后重发</span
        >
      </el-form-item>
      <el-checkbox v-model="checked">同意poss直聘《用户协议》</el-checkbox>
      <el-button type="primary" @click="regist">注册</el-button>
    </el-form>
    <div class="goLogin">
      已有账号？<span><router-link to="/login">去登录</router-link></span>
    </div>
  </div>
</template>
<script>
export default {
  name: "RegisterMail",
  data() {
    return {
      form: {
        email: "",
        pass: "",
        code: "",
      },
      times: null,
      checked: false,
    };
  },
  methods: {
    // 发送验证码
    sendCode() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          //邮箱正确
          this.tiems = "已发送。。";
          let num = 60;
          let interval = setInterval(() => {
            this.times = num > 0 ? num-- : clearInterval(interval);
          }, 1000);
          this.$api
            .getCodeByMail({
              email: this.form.email,
              operationType: "signup",
            })
            .then((res) => {
              if (!res.success) {
                this.$alert("发送验证码失败，原因为：" + res.msg, "错误", {
                  confirmButtonText: "确定",
                });
                this.times = null;
                return false;
              }
            })
            .catch((err) => {
              this.$message.error("发送验证码失败！原因：" + err);
              this.times = null;
            });
        }
      });
    },
    // 邮箱注册
    regist() {
      this.$refs.form.validate((valid) => {
        if (!this.checked) {
          this.$message.error("请勾选下方同意条款");
          return;
        }
        if (valid && this.checked) {
          this.loading = true;
          this.$api
            .resistByMail({
              email: this.form.email,
              password: this.form.pass,
              verifyCode: this.form.code,
            })
            .then((res) => {
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
              }, 2000);
            })
            .catch((err) => {
              this.isErr("注册失败", err);
            });
        }
      });
    },
    isErr(name, msg) {
      this.$alert(name + "，原因为：" + msg);
      this.loading = false;
      this.form.pass = "";
      this.form.email = "";
      this.form.code = "";
    },
  },
};
</script>
<style lang="less" scoped>
#registerMail {
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