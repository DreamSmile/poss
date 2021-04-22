<template>
  <div id="home_age">
    <!-- 后台管理模块 -->
    <div class="home_tab">
      <p class="title">后台管理</p>
      <div class="tabs_box">
        <div
          class="tabs user"
          :style="{
            backgroundImage:
              'url(' + require('@/assets/imgs/admin/user.png') + ')',
          }"
        >
          <p class="tab_num">3341</p>
          <p class="tab_msg">平台用户总数量</p>
        </div>
        <div
          class="tabs merchant"
          :style="{
            backgroundImage:
              'url(' + require('@/assets/imgs/admin/merchant.png') + ')',
          }"
        >
          <p class="tab_num">3341</p>
          <p class="tab_msg">平台商家数</p>
        </div>
        <div
          class="tabs work"
          :style="{
            backgroundImage:
              'url(' + require('@/assets/imgs/admin/work.png') + ')',
          }"
        >
          <p class="tab_num">3341</p>
          <p class="tab_msg">平台兼职数</p>
        </div>
        <div
          class="tabs add_user"
          :style="{
            backgroundImage:
              'url(' + require('@/assets/imgs/admin/add_user.png') + ')',
          }"
        >
          <p class="tab_num">3341</p>
          <p class="tab_msg">今日新增用户数</p>
        </div>
        <div
          class="tabs add_work"
          :style="{
            backgroundImage:
              'url(' + require('@/assets/imgs/admin/add_work.png') + ')',
          }"
        >
          <p class="tab_num">3341</p>
          <p class="tab_msg">今日新增兼职数</p>
        </div>
        <div
          class="tabs add_pending"
          :style="{
            backgroundImage:
              'url(' + require('@/assets/imgs/admin/Pending_work.png') + ')',
          }"
        >
          <p class="tab_num">3341</p>
          <p class="tab_msg">待处理事物</p>
        </div>
      </div>
    </div>
    <!-- 图表和日志 -->
    <div class="home_data">
      <!-- 图表 -->
      <div class="home_echart">
        <p class="title">用户分布图</p>
        <span>这是图表</span>
      </div>
      <!-- 操作日志 -->
      <div class="home_journal">
        <p class="title">7天内操作日志</p>
        <span class="all_journal" @click="open = true">查看所有</span>
        <div class="journal_box">
          <el-steps direction="vertical" space="60px" :active="1">
            <el-step
              icon="el-icon-info"
              title="我做了一个操作"
              description="最近更新"
            ></el-step>
            <el-step
              icon="el-icon-info"
              title="做了操作"
              description="2021-10-11"
            ></el-step>
            <el-step
              icon="el-icon-info"
              title="步骤 3"
              description="这是一段很长很长很长的描述性文字"
            ></el-step>
            <el-step
              icon="el-icon-info"
              title="步骤 3"
              description="这是一段很长很长很长的描述性文字"
            ></el-step>
            <el-step
              icon="el-icon-info"
              title="步骤 3"
              description="这是一段很长很长很长的描述性文字"
            ></el-step>
          </el-steps>
        </div>
      </div>
    </div>
    <!-- 所有日志界面 -->
    <el-dialog
      title="所有操作"
      :visible.sync="open"
      width="482px"
      :before-close="clear"
    >
      <div>这是所有日志</div>
    </el-dialog>
  </div>
</template>

<script>
import "./home.less";
export default {
  data() {
    return {
      open: false,
    };
  },
  methods: {
    // 关闭所有日志界面
    clear() {
      this.open = false;
    },
  },
};
</script>