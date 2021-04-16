<template>
  <div id="job">
    <top message="兼职详情"></top>
    <div class="content">
      <!-- 顶部招聘基础信息 -->
      <div class="content_banner">
        <div class="box">
          <div class="content_state">
            <span class="state">{{
              status == 1 ? "发布中" : status == 2 ? "进行中" : "已结束"
            }}</span>
            <span class="num"
              >限制人数<span>{{ jobData.participantNumber || 0 }}</span
              >/ {{ jobData.limit || 0 }}</span
            >
          </div>
          <div class="post">
            {{ jobData.title }}<span>{{ jobData.hourlyWage }}元/小时</span>
            <span class="createTime">开始时间：{{ jobData.createTime }}</span>
          </div>
          <div class="school">{{ jobData.workplace }}</div>
          <button type="button" @click="addJob" v-if="!jobData.join">
            立即加入
          </button>
          <button type="button" v-else>已申请</button>
        </div>
      </div>

      <!-- 底部招聘详细信息 -->
      <div class="job_box">
        <!-- 举报按钮 -->
        <div class="report" @click="dialogVisible = true">举报</div>
        <!-- 举报界面 -->
        <el-dialog
          title="选择举报类型"
          :visible.sync="dialogVisible"
          width="650px"
          height="800px"
          :before-close="handleClose"
        >
          <div class="report_box" v-if="reportType == null">
            <div
              class="rows"
              v-for="(item, i) in reportTypeList"
              :key="i"
              @click="reporttype(item.id)"
            >
              <div class="row_left">
                <p class="row_title">{{ item.name }}</p>
                <p class="row_msg">{{ item.description }}</p>
              </div>
              <i class="el-icon-arrow-right"></i>
              <el-divider></el-divider>
            </div>
          </div>
          <report-push
            v-if="reportType != null"
            :reportType="reportType"
            @close="close"
          ></report-push>
        </el-dialog>
        <!-- 举报界面结束 -->
        <div class="hr">
          <div
            class="imgs"
            :style="{ backgroundImage: 'url(' + imgSrc + ')' }"
          ></div>
          <div class="hr_data">
            <p class="hr_name">
              {{ jobData.merchantinfo.realName || "招聘者" }}
            </p>
            <router-link
              :to="{
                name: 'Dialogue',
                params: { id: jobData.id },
              }"
              ><p class="hr_state">
                <i class="el-icon-chat-dot-square"></i>刚刚在线
              </p></router-link
            >
          </div>
        </div>
        <!-- 职位描述 -->
        <div class="job_describe">
          <div class="job_describe_list describe_first">
            <p class="title">职位描述</p>
            <div class="box">
              <p class="box_title">岗位职责</p>
              <p class="list">
                {{ jobData.content }}
              </p>
            </div>
          </div>
          <div class="job_describe_list job_middle">
            <p class="title">负责人信息</p>
            <div class="box">
              <p class="list">
                负责人：{{ jobData.merchantinfo.realName || "--" }}
              </p>
              <p class="list">
                负责人手机号：{{ jobData.publisher.phoneNumber || "--" }}
              </p>
              <p class="list">
                负责人所属学校：{{ jobData.publisher.campusInfo.name || "--" }}
              </p>
            </div>
          </div>
          <div class="job_describe_list job_end">
            <p class="title">学校信息</p>
            <div class="box">
              <p class="list">
                {{ jobData.publisher.campusInfo.description || "学校简介空~" }}
              </p>
            </div>
          </div>
        </div>
      </div>
      <!-- 底部附件 -->
      <div class="job_file" v-if="jobData.attachmentName">
        <p>附件</p>
        <div class="file">
          <div class="file_name">
            <div class="imgs"><img src="@/assets/imgs/word.png" /></div>
            <span>{{ jobData.attachmentName }}</span>
          </div>
          <div class="file_look">
            <span class="look" @click="lookFile">查看</span>
            <a :href="jobData.attachment"><span class="download">下载</span></a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<style scoped lang="less">
</style>
<script>
// import {Base64} from '../../utils/base64Util'
import ReportPush from "../../components/ReportPush.vue";
import Top from "../../components/top.vue";
import "./job.less";
export default {
  name: "Job",
  data() {
    return {
      jobData: {},
      status: 1,
      imgSrc: require("@/assets/imgs/user.jpg"),
      fileUrl: "",
      dialogVisible: false, //举报界面
      reportTypeList: [], //举报类型，接口获取
      reportType: null,
    };
  },
  components: {
    Top,
    ReportPush,
  },
  mounted() {
    this.getData();
    this.getreport();
  },
  methods: {
    getData() {
      this.$api
        .getJobData({
          pid: this.$route.params.id,
        })
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.$message.error("获取兼职详情错误！原因为：" + res.msg);
            return false;
          }
          this.jobData = res.data;
          this.imgSrc = res.data.publisher.avatar;
          this.status = res.data.status;
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    addJob() {
      this.$confirm("是否申请加入该兼职?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }).then(() => {
        this.$api
          .addJob({
            pid: this.$route.params.id,
          })
          .then((res) => {
            if (!res.success) {
              this.$message.error("申请兼职失败！原因为：" + res.msg);
              return;
            }
            this.$message({
              message: "申请兼职成功！",
              type: "success",
            });
            this.jobData.join = true;
          })
          .catch((err) => {
            this.$$message.error(err);
          });
      });
    },
    // 获得举报类型
    getreport() {
      this.$api
        .reportList()
        .then((res) => {
          if (!res.success) {
            this.$message.error("获得举报类型失败，原因为：" + res.msg);
            return;
          }
          this.reportTypeList = res.data;
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    // 点击举报
    reporttype(type) {
      console.log(type);
      this.reportType = { type: type, jobId: this.$route.params.id };
    },
    // 关闭举报界面
    handleClose() {
      this.reportType = null;
      this.dialogVisible = false;
    },
    //接收子组件关闭页面
    close(val) {
      if (val) {
        this.handleClose();
      }
    },
    // 查看文件
    lookFile() {
      let url = this.jobData.attachment;
      let deUrl = decodeURIComponent(url);
      let Base64 = require("js-base64").Base64;
      window.open(
        "http://www.yggdrasill.vip:8012/onlinePreview?url=" +
          encodeURIComponent(Base64.encode(deUrl))
      );
    },
  },
};
</script>