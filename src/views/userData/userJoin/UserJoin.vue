<template>
  <div id="userJoin">
    <!-- 顶部头部基本信息 -->
    <user-base-data></user-base-data>
    <div class="content">
      <el-tabs v-model="activeName">
        <el-tab-pane label="所有(10)" name="first"
          ><div class="list_box">
            <el-input
              v-model="input"
              prefix-icon="el-icon-search"
              placeholder="输入活动标题或者日期进行搜索"
              style="width: 500px"
            ></el-input>
            <work-list></work-list></div
        ></el-tab-pane>
        <el-tab-pane label="未开始(3)" name="second">开始</el-tab-pane>
        <el-tab-pane label="已结束(5)" name="third">未结束</el-tab-pane>
        <el-tab-pane label="进行中(2)" name="fourth">进行</el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>
<script>
import userBaseData from "@/components/userBaseData";
import WorkList from "../../../components/workList.vue";
export default {
  name: "userJoin",
  components: {
    userBaseData,
    WorkList,
  },
  data() {
    return {
      activeName: "first",
      input: "",
    };
  },
};
</script>