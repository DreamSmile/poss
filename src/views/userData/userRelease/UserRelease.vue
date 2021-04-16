<template>
  <div id="userJoin">
    <!-- 顶部头部基本信息 -->
    <user-base-data></user-base-data>
    <div class="content">
      <el-tabs v-model="activeName">
        <el-tab-pane :label="'所有(' + jobList.totalRows + ')'" name="first"
          ><div class="list_box">
            <el-input
              v-model="input"
              prefix-icon="el-icon-search"
              placeholder="输入兼职关键字搜索兼职"
              @keyup.enter.native="selJob"
              style="width: 500px"
            ></el-input>
            <work-list
              :jobList="jobList"
              @changePage="changePage"
            ></work-list></div
        ></el-tab-pane>
        <el-tab-pane :label="'未开始(' + jobNo.length + ')'" name="second"
          ><work-list :jobList="jobNo" @changePage="changePage"></work-list
        ></el-tab-pane>
        <el-tab-pane :label="'已结束(' + jobOver.length + ')'" name="third"
          ><work-list :jobList="jobOver" @changePage="changePage"></work-list
        ></el-tab-pane>
        <el-tab-pane :label="'进行中(' + jobIng.length + ')'" name="fourth"
          ><work-list :jobList="jobIng" @changePage="changePage"></work-list
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
    this.setOtherPage();
  },
  methods: {
    setData() {
      this.$api
        .getPushByPage({
          keyword: "",
          paginationInfo: {
            pageNumber: 1,
            pageSize: 10,
          },
        })
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.$message.error("获取发布过的兼职列表失败，原因为：" + res.msg);
            return;
          }
          this.jobList = res.data.content;
          Object.assign(this.jobList, {
            type: "business",
            role: "merchant",
            totalPages: res.data.totalPages,
            totalRows: res.data.totalRows,
          });
        })
        .catch((err) => {
          this.$message.err(err);
        });
    },
    setOtherPage() {
      this.$api
        .getPushJobHis()
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.$message.error(res.msg);
            return;
          }
          for (let i = 0; i < res.data.length; i++) {
            switch (res.data[i].status) {
              case 0:
                this.jobOver.push(res.data[i]);
                Object.assign(this.jobOver, {
                  type: "business",
                });
                break;
              case 1:
                this.jobNo.push(res.data[i]);
                Object.assign(this.jobNo, {
                  type: "business",
                });
                break;
              case 2:
                this.jobIng.push(res.data[i]);
                Object.assign(this.jobIng, {
                  type: "business",
                });
                break;
              default:
                break;
            }
          }
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    // 搜索框查询
    selJob() {
      this.jobByPage(this.input, 1);
    },
    // 子组件返回的查询分页
    changePage(data) {
      if (data.type == "UserRelease") {
        this.jobByPage(
          data.keyword == "undefined" ? data.keyword : "",
          data.page
        );
      }
    },
    // 分页查询兼职
    jobByPage(keyword, page) {
      this.$api
        .getPushByPage({
          keyword: keyword,
          paginationInfo: {
            pageNumber: page ? page : 1,
            pageSize: 10,
          },
        })
        .then((res) => {
          if (!res.success) {
            this.$message.error("搜索兼职失败！原因为：" + res.msg);
            return false;
          }
          this.jobList = res.data.content;
          Object.assign(this.jobList, {
            type: "business",
            role: "merchant",
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