<template>
  <div id="report">
    <el-table :data="reportList" border style="width: 100%">
      <el-table-column type="selection" width="55" align="center">
      </el-table-column>
      <el-table-column prop="user.nickName" sortable label="举报者" width="200">
      </el-table-column>
      <el-table-column
        prop="content.parttimeInfo.title"
        sortable
        label="工作标题"
        width="200"
      >
      </el-table-column>
      <el-table-column
        prop="content.parttimeInfo.campus"
        sortable
        label="工作学校"
        width="150"
      >
      </el-table-column>
      <el-table-column prop="createTime" sortable label="举报时间" width="100">
      </el-table-column>
      <el-table-column
        prop="content.typeName"
        sortable
        label="举报类型"
        width="140"
      >
      </el-table-column>
      <el-table-column prop="status" sortable label="工作状态">
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
          {{ parttimeInfo.title }}
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
      ids:[],//提交给接口的举报数据id
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
          console.log(res);
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
    // 点击处理举报
    handelReport(data) {
      console.log(data);
    },
    // 处理举报axios
    setReportByIdArr(data) {
      this.$adminApi.setReportByIdArr({
        ids: data,
        processAll: true,
      }).then(res=>{
          console.log(res);
          if(!res.success){
              this.$message.error(res.msg);
              return;
          }
          this.$message({
              message:'处理举报信息成功！',
              type:'success'
          })
        //   要将页面上数据清除

      }).catch(err=>{
          this.$message.error(err);
      });
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
  .form_title {
    padding-left: 10px;
    border-left: 2px solid #2c9ef7;
    line-height: 30px;
  }
}
</style>