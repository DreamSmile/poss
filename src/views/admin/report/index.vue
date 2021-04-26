<template>
  <div id="report">
    <!-- 意见处理举报 -->
    <div class="report_edit">
      <el-button type="primary" size="mini" @click="batchReport">批量处理</el-button>
      <el-button type="primary" size="mini" @click="allReport">一键处理所申请</el-button>
    </div>
    <el-table ref="reportTable" :data="reportList" border style="width: 100%">
      <el-table-column type="selection" width="55" align="center">
      </el-table-column>
      <el-table-column prop="user.nickName" label="举报者" width="200">
      </el-table-column>
      <el-table-column
        prop="content.parttimeInfo.title"
        label="工作标题"
        width="200"
      >
      </el-table-column>
      <el-table-column
        prop="content.parttimeInfo.campus"
        label="工作学校"
        width="150"
      >
      </el-table-column>
      <el-table-column prop="createTime" label="举报时间" width="100">
      </el-table-column>
      <el-table-column
        prop="content.typeName"
        label="举报类型"
        width="140"
      >
      </el-table-column>
      <el-table-column prop="status" label="工作状态">
        <template slot-scope="scope">
          <el-tag
            :type="
              scope.row.status == '1'
                ? 'primary'
                : scope.row.status == '2'
                ? 'success'
                : 'info'
            "
            disable-transitions
            >{{
              scope.row.status == "1"
                ? "未开始"
                : scope.row.status == "2"
                ? "进行中"
                : "结束"
            }}</el-tag
          >
        </template>
      </el-table-column>
      <el-table-column fixed="right" label="操作" width="150">
        <template slot-scope="scope">
          <el-button @click="lookByReport(scope.row)" type="button" size="small"
            >详情</el-button
          >
          <el-button
            @click="handelReport(scope.row)"
            type="success"
            size="small"
            >处理</el-button
          >
        </template>
      </el-table-column>
    </el-table>
    <!-- 分页 -->
    <div class="page" v-show="allData.totalRows > 0">
      <el-pagination
        :hide-on-single-page="false"
        :total="allData.totalRows"
        background
        @current-change="changePage"
        :page-size="5"
        layout="prev, pager, next"
      >
      </el-pagination>
    </div>
    <!-- 详情页面 -->
    <el-dialog
      top="15vh"
      title="举报详情"
      :visible.sync="dataOpen"
      width="450px"
    >
      <el-form ref="form" :model="openInfo" label-width="80px" size="mini">
        <p class="form_title">基础信息</p>
        <el-form-item label="工作标题:">
          <el-tooltip
            class="item"
            effect="dark"
            content="点击查看兼职"
            placement="top"
          >
            <span class="work_title" @click="goWork(parttimeInfo.id)">{{
              parttimeInfo.title
            }}</span>
          </el-tooltip>
        </el-form-item>

        <el-form-item label="举报人:">
          {{ user.nickName }}
        </el-form-item>
        <el-form-item label="举报类型:">
          {{ content.typeName }}
        </el-form-item>
        <el-form-item label="举报描述:">
          {{ content.reason }}
        </el-form-item>
        <el-form-item label="举报时间:">
          {{ openInfo.createTime }}
        </el-form-item>
        <p class="form_title">工作详情</p>
        <el-form-item label="工作地点:">
          {{ parttimeInfo.campus + parttimeInfo.workplace }}
        </el-form-item>
        <el-form-item label="开始时间:">
          {{ parttimeInfo.startTime }}
        </el-form-item>
        <el-form-item label="工作时薪:">
          {{ parttimeInfo.hourlyWage }}元/时
        </el-form-item>
        <el-form-item label="参与人数:">
          {{ parttimeInfo.participantNumber }} / {{ parttimeInfo.limit }}
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>
<script>
export default {
  data() {
    return {
      reportList: [],
      allData: {},
      dataOpen: false,
      openInfo: {}, //详情弹出层的数据
      parttimeInfo: {}, //弹出层的工作信息
      content: {}, //弹出层的基础举报信息
      user: {}, //弹出层举报人信息
      ids: [], //提交给接口的举报数据id
    };
  },
  mounted() {
    this.setData();
  },

  methods: {
    setData() {
      this.reportAxios({
        property: "createTime",
        pageNumber: 1,
        pageSize: 5,
      });
    },
    // 点击更换页码
    changePage(page) {
      this.reportAxios({
        property: "createTime",
        pageNumber: page,
        pageSize: 5,
      });
    },
    // 分页的axios
    reportAxios(data) {
      this.$adminApi
        .getReportByPage({
          order: {
            direction: "asc",
            property: data.property,
          },
          pageNumber: data.pageNumber,
          pageSize: data.pageSize,
        })
        .then((res) => {
          if (!res.success) {
            this.$message.error(res.msg);
            return;
          }
          this.allData = res.data;
          this.reportList = res.data.content;
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    // 查看举报详情
    lookByReport(data) {
      this.openInfo = data;
      this.content = data.content;
      this.user = data.user;
      this.parttimeInfo = data.content.parttimeInfo;
      this.dataOpen = true;
    },
    // 点击单条处理举报
    handelReport(data) {
      this.setReportByIdArr({
        ids: [data.id],
        processAll: false,
        type: "one",
      });
    },
    // 批量处理举报
    batchReport() {
      let ids = [];
      let data = this.$refs.reportTable.selection;
      data.forEach((element) => {
        ids.push(element.id);
      });
      this.setReportByIdArr({
        ids: ids,
        processAll: false,
        type: "batch",
      });
    },
    // 一键处理举报
    allReport() {
      this.$confirm("此操作将会将所有举报信息标记为已处理, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "info",
      })
        .then(() => {
          this.setReportByIdArr({
            ids: [],
            processAll: true,
          });
        })
        .catch((err) => {});
    },
    
    // 处理举报axios
    setReportByIdArr(data) {
      this.$adminApi
        .setReportByIdArr({
          ids: data.ids,
          processAll: data.processAll,
        })
        .then((res) => {
          if (!res.success) {
            this.$message.error(res.msg);
            return;
          }
          this.$message({
            message: "处理举报信息成功！",
            type: "success",
          });
          //   要将页面上数据清除
          if (data.processAll) {
            //一键清除
            this.reportList = [];
          } else if (data.type == "batch") {
            //批量
            let data = this.$refs.reportTable.selection;
            this.reportList = this.reportList.filter((item) => {
              return data.every((item2) => {
                return item.id != item2.id;
              });
            });
          } else {
            //单条
            this.reportList = this.reportList.filter(
              (item) => item.id != data.ids[0]
            );
          }
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    // 新窗口打开兼职页面
    goWork(id) {
      let routeData = this.$router.resolve({
        name: "Job",
        params: { id: id },
      });
      window.open(routeData.href, "_blank");
    },
  },
};
</script>
<style scoped lang="less">
#report {
  /deep/.el-dialog__body {
    padding-top: 0;
  }
  /deep/.el-form-item {
    margin-bottom: 6px;
  }
  .report_edit {
    background-color: #fff;
    padding: 10px;
    margin-bottom: 10px;
  }
  .form_title {
    padding-left: 10px;
    border-left: 2px solid #2c9ef7;
    line-height: 30px;
  }
  .work_title {
    cursor: pointer;
    color: #2c9ef7;
  }
  .page {
    background-color: #fff;
    text-align: center;
    margin: 10px 0;
  }
}
</style>