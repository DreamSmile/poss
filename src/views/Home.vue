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
              placeholder="选择学校"
              v-model="jobName"
              autocomplete="off"
              class="input-with-select"
            >
              <el-select v-model="select" slot="prepend" placeholder="选择学校">
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
              ><workList :jobList="jobList"
            /></el-tab-pane>
            <el-tab-pane label="最新职位" name="second"
              ><workList :jobList="jobList"
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
    };
  },
  components: {
    top,
    workList,
    student,
    tourist,
  },
  mounted() {
    // this.getUserData();
    this.getSchoolList();
    this.jobListAxios(this.select, this.jobName);
  },
  methods: {
    // 获取用户信息
    // getUserData() {
    //   this.$api
    //     .getUserData()
    //     .then((res) => {
    //       console.log(res);
    //       if (res.code == 13004 || res.code == 401) {
    //         console.log('判断出验证过期');
    // this.$router.push('/login');
    // this.$api
    //   .changeToken({
    //     refreshToken: this.$store.state.accessToken,
    //     userId: this.$store.state.userDataid,
    //   })
    //   .then((res) => {
    //     console.log(res);
    // if (res.success) {
    //   // this.$store.commit("setUserToken", res.data); //重新更新token
    //   // 更新后重新获取用户信息
    //   // getUserData();
    // } else {
    //   // this.$store.commit("clearAll");
    //   this.$message.error("当前为游客模式，需要使用更多功能请登录");
    // }
    // })
    // .catch((err) => {
    //   this.$message.error("重新换新token失败");
    // });
    //     console.log("验证码过期");
    //     return;
    //   } else if (res.code == 13006) {
    //     //token为空,等于没有用户登录，为防止无登录状态却有登录人信息，将Vux中数据清除
    //     this.$store.commit("clearAll");
    //     return;
    //   }
    //   console.log("配置新的tonken");
    //   // 已经获取到了用户信息
    //   this.$store.commit("setUserData", res.data);
    // })
    // .catch((err) => {
    //   this.$message.error("获取登录信息失败，请登录！");
    // });
    // },
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
      if (!this.select) {
        this.$message({
          message: "请选择学校名称或兼职关键字再搜索！",
          type: "warning",
        });
        return false;
      } else {
        this.jobListAxios(this.select, this.jobName);
      }
    },

    jobListAxios(campus, keyword) {
      this.$api
        .getJobBySchool({
          campus: campus,
          keyword: keyword,
          paginationInfo: {
            pageNumber: 1,
            pageSize: 10,
          },
        })
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.$message.error("获取兼职列表失败！原因为：" + res.msg);
            return false;
          }
          this.jobList = res.data.content;
          Object.assign(this.jobList,{"type":"home"});
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
  },
};
</script>
