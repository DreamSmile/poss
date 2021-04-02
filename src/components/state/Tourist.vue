<template>
  <div id="tourist">
    <p class="tourist_title">各大行业职位任你选择</p>
    <el-form ref="form" :model="form">
      <el-form-item
        :rules="[
          { required: true, message: '请输入手机号', trigger: 'blur' },
          {
            pattern: /^((0\d{2,3}-\d{7,8})|(1[3584]\d{9}))$/,
            message: '请输入合法手机号/电话号',
            trigger: 'blur',
          },
        ]"
      >
        <el-input v-model="form.phone" placeholder="请输入手机号码"></el-input>
      </el-form-item>
      <el-form-item class="write_code">
        <el-input v-model="form.code" placeholder="请输入验证码"></el-input>
        <span class="sendCode">发送验证码</span>
      </el-form-item>
      <el-button>登录/注册</el-button>
      <el-checkbox v-model="checked">同意poss直聘《用户协议》</el-checkbox>
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
    };
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
