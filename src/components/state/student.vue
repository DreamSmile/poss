<template>
  <div id="student">
    <div class="student_base">
      <div class="imgs">
        <router-link to="/userData">
          <div
            class="img"
            :style="{
              backgroundImage:
                'url(' + this.$store.state.userData.avatar ||
                require('@/assets/imgs/user.jpg') + ')',
            }"
          ></div>
          <p>
            <i
              :class="
                $store.state.userData.role == 'merchant'
                  ? 'el-icon-takeaway-box icon'
                  : $store.state.userData.role == 'admin'
                  ? 'el-icon-edit icon'
                  : 'el-icon-user icon'
              "
            ></i
            >{{ $store.state.userData.nickName || "" }}
          </p>
        </router-link>
      </div>
      <div class="student_data">
        <div class="rows">
          <router-link to="/userJoin">
            <span>参与过的兼职记录</span>
            <div>
              {{ $store.state.userData.joinCount || 0
              }}<i class="el-icon-arrow-right"></i>
            </div>
          </router-link>
        </div>
        <div class="rows" v-show="$store.state.userData.role == 'merchant'">
          <router-link to="/userRelease">
            <span>发布过的兼职记录</span>
            <div>
              {{ $store.state.userData.publishCount || 0
              }}<i class="el-icon-arrow-right"></i>
            </div>
          </router-link>
        </div>
      </div>
    </div>
    <div class="work_list">
      <p class="list_title">正在进行中的兼职列表</p>
      <div v-show="jobList.length < 1" class="no">
        暂时没有数据，快去兼职吧~
      </div>
      <ul>
        <li v-for="(item, i) in jobList" :key="i">
          {{ i + 1 }}、
          <el-tooltip :content="item.title" placement="top">
            <span class="list_data">{{ item.title }}</span>
          </el-tooltip>
          <span class="list_time">{{ $utils.returnData(item.startTime) }}</span>
        </li>
      </ul>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      jobList: [],
    };
  },
  mounted() {
    if (this.$store.state.userData.role == "merchant") this.getPushJobHis();
    else this.getJobHis();
  },
  methods: {
    // 获取兼职列表
    getJobHis() {
      this.$api
        .getJobHis()
        .then((res) => {
          if (!res.success) {
            this.$message.error("获取用户兼职历史失败，原因为：" + res.msg);
            return;
          }
          for (let i = 0; i < res.data.length; i++) {
            if (res.data[i].status == 2) {
              this.jobList.push(res.data[i]);
            }
          }
        })
        .catch((err) => {
          this.$message.error("获取用户兼职历史失败，原因为：" + err);
        });
    },
    // 获取商家的兼职列表
    getPushJobHis() {
      this.$api
        .getPushJobHis()
        .then((res) => {
          if (!res.success) {
            this.$message.error(res.msg);
            return;
          }
          for (let i = 0; i < res.data.length; i++) {
            if (res.data[i].status == 2) {
              this.jobList.push(res.data[i]);
            }
          }
        })
        .catch((err) => {
          this.message.error(err);
        });
    },
  },
};
</script>
<style scoped lang="less">
@import "../../assets/css/common.less";
#student {
  margin-top: 20px;
  color: @font-color;
  .student_base {
    background-color: #fff;
    .imgs {
      padding: 21px 0;
      text-align: center;
      margin-bottom: 10px;
      /deep/a {
        text-decoration: none;
        color: @font-color;
      }
      a {
        .img  {
          width: 60px;
          height: 60px;
          overflow: hidden;
          text-align: center;
          display: inline-block;
          border-radius: 50%;
          background-size: cover; //主要是使用背景图的方式，如果图片丢失还不会有很丑的空缺
          background-position: 50%;
          background-color: #ddd;
        }
      }
      .icon {
        padding-right: 6px;
        color: @base-color;
      }
      p {
        margin-top: 10px;
        text-decoration: none;
        color: @font-color;
      }
    }
    .student_data {
      .rows {
        cursor: pointer;
        position: relative;
        padding-bottom: 22px;
        a {
          color: @font-color;
          text-decoration: none;
        }
        span {
          padding-left: 25px;
        }
        div {
          position: absolute;
          top: 0;
          right: 24px;
        }
      }
    }
  }
  .work_list {
    background-color: #fff;
    min-height: 354px;
    margin-top: 20px;
    padding: 18px 23px;
    margin-bottom: 20px;
    .list_title {
    }
    .no {
      text-align: center;
      color: @msg-color;
      margin-top: 20px;
    }
    ul::-webkit-scrollbar {
      width: 0;
    }
    ul {
      height: 354px;
      overflow: auto;
      -ms-overflow-style: none;
      overflow: -moz-scrollbars-none;
      li {
        position: relative;
        margin: 20px 0;
        .list_data {
          width: 5em;
          white-space: nowrap;
          text-overflow: ellipsis;
          overflow: hidden;
          display: inline-block;
          vertical-align: bottom;
        }
        .list_time {
          position: absolute;
          right: 3px;
        }
      }
    }
  }
}
</style>