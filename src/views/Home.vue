<template>
  <div id="home">
    <top></top>
    <div class="content">
      <img class="banner" src="@/assets/imgs/banner.png" />
      <div class="main">
        <!-- 左边主要内容 -->
        <div class="main_data">
          <div class="search">
            <el-input
              placeholder="请输入关键字"
              v-model="jobName"
              autocomplete="off"
              class="input-with-select"
            >
              <el-select v-model="select" slot="prepend" placeholder="选择学校">
                <el-option label="全部" value=""></el-option>
                <el-option
                  :label="item.name"
                  :value="item.name"
                  :sId="item.id"
                  :sType="item.type"
                  v-for="(item, i) in schoolList"
                  :key="i"
                ></el-option>
              </el-select>
              <el-button
                type="primary"
                slot="append"
                icon="el-icon-search"
                @click="queryJob"
              ></el-button>
            </el-input>
          </div>
          <!-- 左边工作列表 -->
          <el-tabs v-model="activeName">
            <el-tab-pane label="推荐职位" name="first"
              ><workList :jobList="jobList" @changePage="changePage"
            /></el-tab-pane>
            <el-tab-pane label="最新职位" name="second"
              ><workList :jobList="jobListHot" @changePage="changePageHot"
            /></el-tab-pane>
          </el-tabs>
        </div>
        <!-- 右边不同用户显示不同内容 -->
        <div class="main_state">
          <tourist v-if="!$store.state.accessToken" /><student v-else />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import "./home.less";
import top from "@/components/top.vue";
import workList from "@/components/workList.vue";
import student from "@/components/state/student.vue";
import tourist from "@/components/state/Tourist.vue";

export default {
  name: "Home",
  data() {
    return {
      schoolList: [],
      jobName: "",
      select: "",
      activeName: "first",
      jobList: [], //传给子组件的搜索工作列表
      jobListHot: [], //推荐
    };
  },
  components: {
    top,
    workList,
    student,
    tourist,
  },
  mounted() {
    this.getUserData();
    this.getSchoolList();
    this.jobListAxios(this.select, this.jobName, "asc");
    this.jobListAxios(this.select, this.jobName, "desc");
  },
  methods: {
    // 获取用户信息
    getUserData() {
      this.$api
        .getUserData()
        .then((res) => {
          if (!res.success) {
            this.$store.commit("clearAll");
            return;
          }
          // 已经获取到了用户信息
          this.$store.dispatch("setUserAysc", res.data);
        })
        .catch((err) => {
          this.$message.error("获取登录信息失败，请登录！");
          this.$store.commit("clearAll");
        });
    },
    // 获取学校列表
    getSchoolList() {
      this.$api
        .getSchoolList()
        .then((res) => {
          if (!res.success) {
            this.$message.error("获取学校列表失败！原因为：" + res.msg);
            return false;
          }
          this.schoolList = res.data;
        })
        .catch((err) => {
          this.$message.error("获取学校列表失败！" + err);
        });
    },
    // 搜索工作
    queryJob() {
      if (!this.select || !this.jobName) {
        this.jobListAxios(this.select, this.jobName);
      } else {
        this.$message({
          message: "请选择学校名称或兼职关键字再搜索！",
          type: "warning",
        });
        return false;
      }
    },
    // 子组件更换页码，先判断是不是首页的子组件
    changePage(data) {
      if (data.type == "Home") {
        this.jobListAxios(data.campus, data.keyword, "asc", data.page);
      }
    },
    // 热门
    changePageHot(data) {
      if (data.type == "Home") {
        this.jobListAxios(data.campus, data.keyword, "desc", data.page);
      }
    },
    // 获得分页兼职列表
    jobListAxios(campus, keyword, direction, page) {
      this.$api
        .getJobBySchool({
          campus: campus,
          keyword: keyword,
          paginationInfo: {
            order: {
              direction: direction,
              property: "campus",
            },
            pageNumber: page ? page : 1,
            pageSize: 10,
          },
        })
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.$message.error("获取兼职列表失败！原因为：" + res.msg);
            return false;
          }
          if (direction == "asc") {
            this.jobList = res.data.content;
            Object.assign(this.jobList, {
              type: "home",
              campus: campus,
              keyword: keyword,
              totalRows: res.data.totalRows,
            });
          } else {
            this.jobListHot = res.data.content;
            Object.assign(this.jobListHot, {
              type: "home",
              campus: campus,
              keyword: keyword,
              totalRows: res.data.totalRows,
            });
          }
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
  },
};
</script>
