<template>
  <div id="userJoin">
    <!-- 顶部头部基本信息 -->
    <user-base-data></user-base-data>
    <div class="content">
      <el-tabs v-model="activeName">
        <el-tab-pane :label="'所有(' + jobList.length + ')'" name="first"
          ><div class="list_box">
            <el-input
              v-model="input"
              prefix-icon="el-icon-search"
              placeholder="请输入兼职关键字"
              @keyup.enter.native="selJob"
              style="width: 500px"
              @changePage="changePage"
            ></el-input>
            <work-list :jobList="jobList"></work-list></div
        ></el-tab-pane>
        <el-tab-pane :label="'未开始(' + jobNo.length + ')'" name="second"
          ><work-list :jobList="jobNo"></work-list
        ></el-tab-pane>
        <el-tab-pane :label="'已结束(' + jobOver.length + ')'" name="third"
          ><work-list :jobList="jobOver"></work-list
        ></el-tab-pane>
        <el-tab-pane :label="'进行中(' + jobIng.length + ')'" name="fourth"
          ><work-list :jobList="jobIng"></work-list
        ></el-tab-pane>
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
      jobList: [],
      jobNo: [],
      jobOver: [],
      jobIng: [],
    };
  },
  mounted() {
    this.setData();
  },
  methods: {
    setData() {
      this.$api
        .getJobHis()
        .then((res) => {
          if (!res.success) {
            this.$message.error("获取用户兼职历史失败，原因为：" + res.msg);
            return;
          }
          this.jobList = res.data;
          Object.assign(this.jobList, {
            type: "join",
            totalRows: res.data.totalRows,
            totalRows: res.data.totalRows,
          });
          for (let i = 0; i < res.data.length; i++) {
            switch (res.data[i].status) {
              case 0:
                this.jobOver.push(res.data[i]);
                Object.assign(this.jobOver, { type: "join" });
              case 1:
                this.jobIng.push(res.data[i]);
                Object.assign(this.jobIng, { type: "join" });
                break;
              case 2:
                this.jobNo.push(res.data[i]);
                Object.assign(this.jobNo, { type: "join" });
              default:
                break;
            }
          }
        })
        .catch((err) => {
          this.$message.error("获取用户兼职历史错误，原因为：" + err);
        });
    },
    // 搜索兼职
    selJob() {
      this.jobByPage("", this.input, 1);
    },
    // 子组件返回的查询分页
    changePage(data) {
      if (data.type == "UserRelease") {
        this.jobByPage(data.campus, data.keyword, data.page);
      }
    },
    // 分页查询兼职
    jobByPage(campus, keyword, page) {
      this.$api
        .getJobBySchool({
          campus: campus,
          keyword: keyword,
          paginationInfo: {
            pageNumber: page ? page : 1,
            pageSize: 10,
          },
        })
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.$message.error("搜索兼职失败！原因为：" + res.msg);
            return false;
          }
          this.jobList = res.data.content;
          Object.assign(this.jobList, {
            type: "business",
            role: "merchant",
            campus: campus,
            keyword: keyword,
            totalRows: res.data.totalRows,
          });
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
  },
};
</script>