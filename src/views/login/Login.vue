<template>
  <div id="login">
    <div class="bg">
      <div class="content">
        <!-- 左边：固定 -->
        <div class="content_left">
          <img src="@/assets/imgs/login/logo_blue.png" />
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
            <el-tab-pane label="密码登录" name="pass"><loginPass/></el-tab-pane>
            <el-tab-pane label="短信登录" name="messpage"><loginPhone/></el-tab-pane>
          </el-tabs>
          
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import "../register/register.less";

import loginPass from "@/components/regAndLogin/loginPass";
import loginPhone from "@/components/regAndLogin/loginPhone";
export default {
  name: "Login",
  components: {
    loginPass,
    loginPhone,
  },
  data() {
    return {
      activeName: "pass",
    };
  },
};
</script>