<template>
  <div id="mailPhoneEdit">
    <top message="修改信息"></top>
    <!-- 主要修改区 -->
    <div class="content">
      <p class="content_title">poss直聘通行证</p>
      <div class="main">
        <hr />
        <el-tabs v-model="activeName" stretch>
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
                  placeholder="原手机号"
                ></el-input>
                <el-input
                  placeholder="+86"
                  v-model="formPhone.phoneNew"
                  class="input-with-select"
                  style="margin-top: 20px"
                >
                  <el-select
                    v-model="formPhone.select"
                    slot="prepend"
                    placeholder="+86"
                  >
                    <el-option label="+86" value="1"></el-option>
                    <el-option label="+0595" value="2"></el-option>
                  </el-select>
                </el-input>
                <el-input
                  placeholder="请输入验证码"
                  v-model="formPhone.code"
                  class="input-with-select"
                  style="margin-top: 20px"
                >
                  <span slot="prepend">验证码</span>
                  <span slot="append" class="send_ode">发送验证码</span>
                </el-input></el-form
              >
              <el-button class="sub" type="primary">提交</el-button>
            </div></el-tab-pane
          >
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
                  v-model="formPhone.MailNew"
                  placeholder="新邮箱"
                ></el-input>

                <el-input
                  placeholder="请输入验证码"
                  v-model="formPhone.code"
                  class="input-with-select"
                  style="margin-top: 20px"
                >
                  <span slot="prepend">验证码</span>
                  <span slot="append" class="send_ode">发送验证码</span>
                </el-input></el-form
              >
              <el-button class="sub" type="primary">提交</el-button>
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
        phoneOld: "",
        phoneNew: "",
        select: "+86",
        code: "",
      },
      formMail: {
        mailNew: "",
        code: "",
      },
    };
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