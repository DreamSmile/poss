<template>
  <div id="userBase">
    <!-- 基本头像信息 -->
    <user-base-data></user-base-data>
    <!-- 基本信息 -->
    <div class="base_data">
      <p class="data_title">基本信息</p>
      <div class="rows first_row">
        <span class="row_problem">用户名</span
        ><span class="row_answer">{{
          $store.state.userData.nickName || "无"
        }}</span>
      </div>
      <div class="rows first_row">
        <span class="row_problem">性别</span
        ><span class="row_answer">{{ $store.state.userData.sex || "无" }}</span>
      </div>
      <div class="rows first_row">
        <span class="row_problem">手机号</span
        ><span class="row_answer">{{
          $store.state.userData.phoneNumber || "无"
        }}</span>
      </div>
      <div class="rows first_row">
        <span class="row_problem">邮箱</span
        ><span class="row_answer">{{
          $store.state.userData.email || "无"
        }}</span>
      </div>
    </div>
    <!-- 教育背景 -->
    <div class="base_data">
      <p class="data_title">教育背景</p>
      <router-link to="/userEdit">
        <button type="button">修改</button></router-link
      >
      <div class="rows first_row">
        <span class="row_problem">毕业院校</span
        ><span class="row_answer">{{
          $store.state.userData.campusInfo
            ? $store.state.userData.campusInfo.name
            : "无"
        }}</span>
      </div>
      <div class="rows first_row">
        <span class="row_problem">学历</span
        ><span class="row_answer">{{
          $store.state.userData.campusInfo
            ? $store.state.userData.campusInfo.type
            : "无"
        }}</span>
      </div>
      <div class="rows first_row">
        <span class="row_problem">专业</span
        ><span class="row_answer">{{
          $store.state.userData.campusInfo
            ? $store.state.userData.campusInfo.description
            : "无"
        }}</span>
      </div>
    </div>
  </div>
</template>
<script>
import "./userbase.less";
import userBaseData from "@/components/userBaseData";
export default {
  components: {
    userBaseData,
  },
  data() {
    return {
    };
  },
  mounted() {},
  methods: {},
};
</script>
