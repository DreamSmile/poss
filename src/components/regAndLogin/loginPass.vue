<template>
  <div id="loginPass">
    <el-form ref="form" :model="form" :rules="rules">
      <el-form-item prop="email">
        <el-input
          v-model="form.email"
          placeholder="请输入手机号/邮箱"
          :validate-event="false"
        ></el-input>
      </el-form-item>
      <el-form-item prop="pass">
        <el-input
          :validate-event="false"
          type="password"
          v-model="form.pass"
          autocomplete="off"
          placeholder="请输入密码"
        ></el-input>
      </el-form-item>
      <el-button type="primary" @click="goLogin" :loading="loading"
        >登录</el-button
      >
    </el-form>
    <div class="goRegister">
      没有账号？<span><router-link to="/register">去注册</router-link></span>
    </div>
  </div>
</template>
<script>
export default {
  name: "loginPass",
  data() {
    return {
      form: {
        email: "",
        pass: "",
      },
      loading: false,
      rules: {
        email: {
          required: true,
          message: "请输入手机号/邮箱",
        },
        pass: [
          { required: true, message: "请输入密码" },
          {
            min: 6,
            max: 10,
            message: "长度在 6 到 10 个字符",
          },
        ],
      },
    };
  },
  methods: {
    goLogin() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.loading = true;
          this.$api
            .loginByMail({
              account: this.form.email,
              password: this.form.pass,
            })
            .then((res) => {
              if (!res.success) {
                this.isErr(res.msg);
                return;
              }
              this.loading = false;
              this.$message({
                type: "success",
                message: "登录成功！即将为您跳转至首页",
              });
              this.$store.commit("setUserToken", res.data); //将token存到vuex
              setTimeout(() => {
                this.$router.push("/");
              }, 2000);
            })
            .catch((err) => {
              this.isErr(err);
            });
        }
      });
    },
    isErr(msg) {
      this.loading = false;
      this.$alert("登录失败！原因为：" + msg);
      this.form.email = "";
      this.form.pass = "";
    },
  },
};
</script>
<style lang="less" scoped>
#loginPass {
  margin-top: 20px;
}
/deep/ .el-button--primary {
  width: 100%;
  margin-top: 40px;
}
.goRegister {
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