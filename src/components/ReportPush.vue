<template>
  <div id="report">
    <span>举报详情：</span>
    <textarea v-model="reason"></textarea>
    <el-button type="primary" @click="report">举报</el-button>
  </div>
</template>
<script>
export default {
  name: "ReportPush",
  data() {
    return {
      reason: "",
    };
  },
  props: {
    reportType: {
      type: Object,
      default: () => {},
    },
  },
  methods: {
    //   举报按钮
    report() {
      this.$api
        .reportJob({
          pid: this.reportType.jobId,
          reason: this.reason,
          type: this.reportType.type,
        })
        .then((res) => {
          if (!res.success) {
            this.$message.error("举报兼职失败，原因为：" + res.msg);
            return;
          }
          this.$message({
            message: "举报成功！有后续我们将会通知您!",
            type: "success",
          });
          this.$emit("close", true);
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
  },
};
</script>
<style scoped lang="less">
@import "../assets/css/common.less";
#report {
  position: relative;
  height: 376px;
  span {
    color: @font-color;
    vertical-align: top;
  }
  textarea {
    border: 1px solid @msg-color;
    width: 500px;
    height: 300px;
  }
  .el-button {
    position: absolute;
    bottom: 0;
    right: 34px;
  }
}
</style>