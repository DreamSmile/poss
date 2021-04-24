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
          <p class="tab_num">{{ base.userCount || 0 }}</p>
          <p class="tab_msg">平台用户总数量</p>
        </div>
        <div
          class="tabs merchant"
          :style="{
            backgroundImage:
              'url(' + require('@/assets/imgs/admin/merchant.png') + ')',
          }"
        >
          <p class="tab_num">{{ base.merchantCount || 0 }}</p>
          <p class="tab_msg">平台商家数</p>
        </div>
        <div
          class="tabs work"
          :style="{
            backgroundImage:
              'url(' + require('@/assets/imgs/admin/work.png') + ')',
          }"
        >
          <p class="tab_num">{{ base.ptCount || 0 }}</p>
          <p class="tab_msg">平台兼职数</p>
        </div>
        <div
          class="tabs add_user"
          :style="{
            backgroundImage:
              'url(' + require('@/assets/imgs/admin/add_user.png') + ')',
          }"
        >
          <p :class="base.todayNewUser > 0 ? 'tab_num_green' : 'tab_num'">
            {{ base.todayNewUser }}
          </p>
          <p class="tab_msg">今日新增用户数</p>
        </div>
        <div
          class="tabs add_work"
          :style="{
            backgroundImage:
              'url(' + require('@/assets/imgs/admin/add_work.png') + ')',
          }"
        >
          <p :class="base.todayNewPartTime > 0 ? 'tab_num_green' : 'tab_num'">
            {{ base.todayNewPartTime || 0 }}
          </p>
          <p class="tab_msg">今日新增兼职数</p>
        </div>
        <div
          class="tabs add_pending"
          :style="{
            backgroundImage:
              'url(' + require('@/assets/imgs/admin/Pending_work.png') + ')',
          }"
        >
          <p :class="base.transaction > 0 ? 'tab_num_red' : 'tab_num'">
            {{ base.transaction || 0 }}
          </p>
          <p class="tab_msg">待处理事物</p>
        </div>
      </div>
    </div>
    <!-- 图表和日志 -->
    <div class="home_data">
      <!-- 图表 -->
      <div class="home_echart">
        <p class="title">用户分布图</p>
        <div class="user">
          <div
            class="echert_el"
            ref="userEchertEl"
            style="width: 350px; height: 300px"
          ></div>
          <p class="echert_title">用户分部数</p>
        </div>
        <div class="merchant">
          <div
            class="echert_el"
            ref="merchantEchertEl"
            style="width: 350px; height: 300px"
          ></div>
          <p class="echert_title">商家分部数</p>
        </div>
      </div>
      <!-- 操作日志 -->
      <div class="home_journal">
        <p class="title">7天内操作日志</p>
        <span class="all_journal" @click="open = true">查看所有</span>
        <div class="journal_box">
          <el-scrollbar style="height: 100%">
            <el-steps direction="vertical" space="60px" :active="1">
              <el-step
                v-for="(item, i) in operationHis"
                :key="i"
                icon="el-icon-info"
                :title="item.adminName + item.content"
                :description="item.createTime"
              ></el-step>
            </el-steps>
          </el-scrollbar>
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
      <el-scrollbar style="height: 100%">
        <el-steps direction="vertical" space="60px" :active="1">
          <el-step
            v-for="(item, i) in operationHis"
            :key="i"
            icon="el-icon-info"
            :title="item.adminName + item.content"
            :description="item.createTime"
          ></el-step>
        </el-steps>
      </el-scrollbar>
    </el-dialog>
  </div>
</template>

<script>
import "./home.less";
// 引入 echarts 核心模块，核心模块提供了 echarts 使用必须要的接口。
import * as echarts from "echarts/core";
// 引入柱状图图表，图表后缀都为 Chart
import { PieChart } from "echarts/charts";
// 引入提示框，标题，直角坐标系组件，组件后缀都为 Component
import {
  TitleComponent,
  TooltipComponent,
  GridComponent,
} from "echarts/components";
// 引入 Canvas 渲染器，注意引入 CanvasRenderer 或者 SVGRenderer 是必须的一步
import { CanvasRenderer } from "echarts/renderers";

// 注册必须的组件
echarts.use([
  TitleComponent,
  TooltipComponent,
  GridComponent,
  PieChart,
  CanvasRenderer,
]);

export default {
  data() {
    return {
      open: false,
      base: {}, //tab的数据
      operationHis: [], //日志
      pieUserData: [], //饼图中用户分部数
      pieMerchant: [], //饼图中商家分部数
      userDistribution: {}, //接口中获取到的用户数
      merchantDistribution: {}, //接口中获取的商家数
    };
  },
  mounted() {
    this.setData();
  },
  methods: {
    setData() {
      this.$adminApi
        .getBase()
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.$message.error(res.msg);
            return;
          }
          this.base = res.data;
          this.operationHis = res.data.operationHis;
          this.userDistribution = res.data.userDistribution;
          this.merchantDistribution = res.data.merchantDistribution;
          this.setEchert();
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    // 设置图表
    setEchert() {
      for (let key of Object.keys(this.userDistribution)) {
        //定义用户分部数
        this.pieUserData.push({
          name: key,
          value: this.userDistribution[key],
        });
      }
      for (let key of Object.keys(this.merchantDistribution)) {
        //定义商家分部数
        this.pieMerchant.push({
          name: key,
          value: this.merchantDistribution[key],
        });
      }
      this.initEchert("userEchertEl", this.pieUserData);
      this.initEchert("merchantEchertEl", this.pieMerchant);
    },
    // 初始化图表
    initEchert(elDiv, eData) {
      let myChart = null;
      if (elDiv == "userEchertEl") {
        myChart = echarts.init(this.$refs.userEchertEl);
      } else if (elDiv == "merchantEchertEl") {
        myChart = echarts.init(this.$refs.merchantEchertEl);
      }
      myChart.setOption({
        tooltip: {
          trigger: "item",
        },
        series: [
          {
            name: "访问来源",
            type: "pie",
            radius: "50%",
            itemStyle: {
              normal: {
                label: {
                  show: true,
                  formatter: "{b} : {c} ({d}%)",
                },
                labelLine: { show: true },
              },
            },
            data: eData, //图表显示
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: "rgba(0, 0, 0, 0.5)",
              },
            },
          },
        ],
      });
    },
    // 关闭所有日志界面
    clear() {
      this.open = false;
    },
  },
};
</script>