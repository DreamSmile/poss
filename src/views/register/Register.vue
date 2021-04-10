<template>
  <div id="register">
    <div class="bg">
      <div class="content">
        <!-- 左边：固定 -->
        <div class="content_left">
          <img src="@/assets/imgs/login/logo.png" />
          <div class="left_box">
            <i class="el-icon-document"></i>
            <div>
              <p class="box_title">沟通</p>
              <p class="box_msg">在线职位及沟通</p>
            </div>
          </div>
          
          <div class="left_box">
            <i class="el-icon-document"></i>
            <div>
              <p class="box_title">任性选</p>
              <p class="box_msg">各大职位由你选</p>
            </div>
          </div>
        </div>
        <div class="content_right">
          <el-tabs v-model="activeName">
            <el-tab-pane label="邮箱注册" name="mail"><registerMail/></el-tab-pane>
            <el-tab-pane label="手机注册" name="phone"><registerPhone/></el-tab-pane>
          </el-tabs>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import "./register.less";

import registerMail from "@/components/regAndLogin/registerMail";
import registerPhone from "@/components/regAndLogin/registerPhone";
export default {
  name: "Register",
  components: {
    registerMail,
    registerPhone,
  },
  data() {
    return {
      activeName: "mail",
    };
  },
};
</script>