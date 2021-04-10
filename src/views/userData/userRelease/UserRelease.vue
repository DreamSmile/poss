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
              placeholder="输入兼职关键字搜索兼职"
              @keyup.enter.native="selJob"
              style="width: 500px"
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
        .getPushJobHis({
          pageNumber: 1,
          pageSize: 10,
        })
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.$message.error("获取发布过的兼职列表失败，原因为：" + res.msg);
            return;
          }
          this.jobList = res.data.content;
          Object.assign(this.jobList, { type: "business", role: "merchant" });
          for (let i = 0; i < res.data.content.length; i++) {
            switch (res.data.content[i].status) {
              case 0:
                this.jobOver.push(res.data.content[i]);
                Object.assign(this.jobOver, { type: "business" });
              case 1:
                this.jobNo.push(res.data.content[i]);
                Object.assign(this.jobNo, { type: "business" });
                break;
              case 2:
                this.jobIng.push(res.data.content[i]);
                Object.assign(this.jobIng, { type: "business" });
              default:
                break;
            }
          }
        })
        .catch((err) => {
          this.$message.err(err);
        });
    },
    // 搜索框查询
    selJob() {
      if (!this.input) {
        this.$message({
          message: "请输入兼职关键字！",
          type: "warning",
        });
        return;
      }
      this.$api
        .getJobBySchool({
          campus: '',
          keyword: this.input,
          paginationInfo: {
            pageNumber: 1,
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
          Object.assign(this.jobList, { type: "business", role: "merchant" });
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
  },
};
</script>