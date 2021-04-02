<template>
  <div id="register">
    <div class="bg">
      <div class="top">
        <span class="logo">poss直聘</span>
        <el-divider direction="vertical"></el-divider>
        <span class="regisers">注册</span>
      </div>
    </div>
    <div class="content">
      <el-divider>欢迎注册poss直聘通行证</el-divider>
      <!-- 表单输入 -->
      <div class="forms">
        <el-form
          :model="ruleForm"
          status-icon
          :rules="rules"
          ref="ruleForm"
          class="demo-ruleForm form"
        >
          <el-form-item>
            <el-input
              placeholder="请输入手机号码或邮箱"
              v-model="ruleForm.phone"
              autocomplete="off"
              class="input-with-select"
            >
              <el-select
                v-model="ruleForm.sel"
                slot="prepend"
                placeholder="手机号码"
              >
                <el-option label="手机号码" value="phoneNumber"></el-option>
                <el-option label="邮箱" value="email"></el-option>
              </el-select>
            </el-input>
          </el-form-item>

          <el-form-item prop="pass">
            <el-input
              placeholder="请输入密码"
              v-model="ruleForm.pass"
              type="password"
              autocomplete="off"
              class="input-with-select"
            >
              <span slot="prepend">密码</span>
            </el-input>
          </el-form-item>

          <el-form-item prop="checkPass">
            <el-input
              placeholder="请确认密码"
              v-model="ruleForm.checkPass"
              type="password"
              autocomplete="off"
              class="input-with-select"
            >
              <span slot="prepend">确认密码</span>
            </el-input>
          </el-form-item>
          <!-- 验证码 -->
          <el-form-item>
            <el-input
              placeholder="请输入验证码"
              v-model="ruleForm.code"
              class="input-with-select"
            >
              <template slot="prepend">验证码</template>
              <el-divider slot="append" direction="vertical"></el-divider>
              <span slot="append" @click="sendCode">发送验证码</span>
            </el-input>
          </el-form-item>
          <!-- 按钮区 -->
          <div class="btn">
            <el-checkbox v-model="isTrue"
              >我同意<span>用户注册协议</span></el-checkbox
            >
            <el-button type="primary" @click="sub">注册</el-button>
            <div class="goLogin">已有账号？<a>去登录</a></div>
          </div>
        </el-form>
      </div>
    </div>
  </div>
</template>
<script>
import "./register.less";
export default {
  name: "Register",
  data() {
    var validatePass = (rule, value, callback) => {
      if (value === "") {
        callback(new Error("请输入密码"));
      } else {
        if (this.ruleForm.checkPass !== "") {
          this.$refs.ruleForm.validateField("checkPass");
        }
        callback();
      }
    };
    var validatePass2 = (rule, value, callback) => {
      if (value === "") {
        callback(new Error("请再次输入密码"));
      } else if (value !== this.ruleForm.pass) {
        callback(new Error("两次输入密码不一致!"));
      } else {
        callback();
      }
    };
    return {
      ruleForm: {
        pass: "",
        checkPass: "",
        sel: "手机号码",
        phone: "",
        code: "",
      },
      isTrue: false,
      rules: {
        pass: [{ validator: validatePass, trigger: "blur" }],
        checkPass: [{ validator: validatePass2, trigger: "blur" }],
      },
    };
  },
  methods: {
    //   发送验证码
    sendCode() {
      if (!this.ruleForm.phone) {
        this.$message({
          message: "请输入正确的" + this.ruleForm.sel,
          type: "error",
        });
        return false;
      }
      alert(this.ruleForm.phone);
    },
    sub() {
      this.$message({
        message: "注册",
        type: "success",
      });
    },
  },
};
</script>