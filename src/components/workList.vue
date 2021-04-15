<template>
  <div id="workList">
    <div class="list" v-show="jobList.length > 0">
      <ul>
        <li v-for="(item, index) in jobList" :key="index">
          <div>
            <span class="work_NO">{{ index + 1 }}、</span>
            <div class="list_base">
              <router-link
                :to="{
                  name: jobList.role != 'merchant' ? 'Job' : 'PushJob',
                  params: { id: item.id },
                }"
              >
                <span class="work_name">{{ item.title }}</span>
                <span class="work_place"
                  >[{{ item.workplace }}]</span
                ></router-link
              >
              <span class="work_master" v-if="jobList.type == 'home'"
                >发布者：{{ item.publisher.realName || "发布者" }}</span
              >
              <span class="work_data" v-if="jobList.type == 'join'">{{
                $utils.returnData(item.createTime)
              }}</span>
              <span @click="checkId(item.publisherId,item.id)" class="dia">
                <span class="work_say" v-if="jobList.type == 'home'">
                  <i class="el-icon-chat-dot-round"></i>立即沟通</span
                ></span
              >
              <i
                class="el-icon-delete out_job"
                v-if="jobList.type == 'join'"
                @click="outJob(item.status, item.id)"
              ></i>
            </div>
            <div class="list_secondary">
              <span class="work_money">{{ item.hourlyWage }}/小时</span>
              <span class="work_time">工作时间：{{ item.duration }}小时</span>
              <div class="work_state">
                已报名：<span>{{ item.participantNumber }}</span
                >/{{ item.limit }}
              </div>
            </div>
            <!-- 1:招聘，2进行，0：结束 -->
            <img v-show="item.status == 0" src="@/assets/imgs/over.png" />
            <img v-show="item.status == 1" src="@/assets/imgs/no.png" />
            <img v-show="item.status == 2" src="@/assets/imgs/ing.png" />
          </div>
        </li>
      </ul>
    </div>
    <div class="page">
      <el-pagination
        @current-change="currentChange"
        background
        :hide-on-single-page="true"
        layout="prev, pager, next"
        :total="jobList.totalRows"
      >
      </el-pagination>
    </div>
    <div class="noList" v-show="jobList.length < 1">
      <i class="el-icon-document-delete"></i>暂时没有数据~
    </div>
  </div>
</template>
<script>
export default {
  name: "workList",
  data() {
    return {};
  },
  props: {
    jobList: {
      type: Array,
      default: () => [],
    },
  },
  mounted() {},
  methods: {
    // 退出兼职
    outJob(satus, id) {
      if (satus != 1) {
        this.$message({
          message: "只能退出未开始的兼职工作！",
          type: "warning",
        });
        return;
      }
      this.$confirm("是否退出该兼职?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          this.$api
            .outJob({
              pid: id,
            })
            .then((res) => {
              this.$message({
                message: "退出该兼职工作成功！",
                type: "success",
              });
            });
          // 应该马上删除改兼职
          this.jobList = this.jobList.filter((item) => item.id != id);
        })
        .catch(() => {});
    },
    // 更换页码执行
    currentChange(num) {
      this.$emit("changePage", {
        type: this.$route.name,
        page: num,
        campus: this.jobList.campus,
        keyword: this.jobList.keyword,
      });
    },
    checkId(userId,jobId) {
      if (this.$store.state.userData == {}) {
        this.$message.error("需要登录才能使用此功能哦~");
        return;
      }
      if (userId == this.$store.state.userData.id) {
        this.$message.error("不可以跟自己对话哦~");
        return false;
      }
      this.$router.push({
        name: "Dialogue",
        params: { id: jobId },
      });
    },
  },
};
</script>
<style scoped lang="less">
@import "../assets/css/common.less";
#workList {
  .list {
    ul {
      li {
        padding: 10px 37px;
        box-sizing: border-box;
        height: 80px;
        background-color: #fff;
        position: relative;
        margin: 10px 0;
        a {
          text-decoration: none;
        }
        .work_NO {
          position: absolute;
          top: 19px;
          left: 9px;
          color: @base-color;
        }
        .list_base {
          display: inline-block;
          .dia{
            cursor: pointer;
          }
          .work_name,
          .work_place,
          .work_say {
            color: @base-color;
            font-size: 14px;
            font-weight: 400;
            line-height: 32px;
            .el-icon-chat-dot-round {
              margin-right: 3px;
            }
          }
          .work_name {
            width: 5em;
            white-space: nowrap;
            text-overflow: ellipsis;
            overflow: hidden;
            height: 32px;
            vertical-align: top;
            display: inline-block;
          }
          .work_master,
          .work_data {
            color: @msg-color;
            margin: 0 30px;
          }
        }
        .out_job {
          position: absolute;
          right: 50px;
          top: 5px;
          color: #f95500;
          font-size: 20px;
          cursor: pointer;
        }
        .list_secondary {
          margin-top: 4px;
          .work_money,
          .work_time {
            color: #f95500;
          }
          .work_time {
            margin-left: 10px;
          }
          .work_state {
            display: inline-block;
            position: absolute;
            color: @msg-color;
            right: 0;
            span {
              color: @base-color;
            }
          }
        }
        img {
          position: absolute;
          top: 0;
          right: 0;
          width: 39px;
          height: 39px;
        }
      }
    }
  }
  .page {
    margin-bottom: 50px;
    text-align: center;
    width: 100%;
    background-color: #fff;
    ::v-deep {
      .el-pagination.is-background .el-pager li:not(.disabled) {
        background-color: #fff; // 进行修改未选中背景和字体
      }
      .el-pagination.is-background .el-pager li:not(.disabled).active {
        background-color: @base-color; // 进行修改选中项背景和字体
        color: #fff;
      }
      .btn-next,
      .btn-prev {
        background-color: #fff;
      }
    }
  }
  .noList {
    text-align: center;
    color: @msg-color;
  }
}
</style>
