<template>
  <div id="student">
    <div class="student_base">
      <div class="imgs">
        <router-link to="/userData">
          <img src="@/assets/imgs/user.jpg" />
        </router-link>
        <p>{{ userData.nickName }}</p>
      </div>
      <div class="student_data">
        <div class="rows"><router-link to="/userData">
          <span>参与过的兼职记录</span>
          <div>
            {{ userData.joinCount || 0 }}<i class="el-icon-arrow-right"></i>
          </div>
          </router-link>
        </div>
        <div class="rows" v-if="userData.role == 'merchant'"><router-link to="/userData">
          <span>发布过的兼职记录</span>
          <div>32<i class="el-icon-arrow-right"></i></div>
          </router-link>
        </div>
      </div>
    </div>
    <div class="work_list">
      <p class="list_title">正在进行中的兼职列表</p>
      <ul v-for="(item,i) in jobList" :key="i">
        <li>
          {{i+1}}、
          <p class="list_data">{{item.title}}</p>
          <span class="list_time">{{item.startTime}}</span>
        </li>
      </ul>
      <div v-show="jobList.length<1" class="no">暂时没有数据，快去兼职吧~
      </div>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      userData: {},
      imgSrc: require("@/assets/imgs/user.jpg"),
      jobList: [],
    };
  },
  mounted() {
    this.setData();
  },
  methods: {
    setData() {
      if (this.$store.state) {
        this.userData = this.$store.state.userData;
        this.$store.state.avatar
          ? (this.imgSrc = require(this.$store.state.avatar))
          : "";
      }
    },
    // 获取兼职列表
    getJobHis() {
      this.$api
        .getJobHis()
        .then((res) => {
          if (!res.success) {
            this.$message.error("获取用户兼职历史失败，原因为：" + res.msg);
            return;
          }
          this.jobList = res.data;
        })
        .catch((err) => {
          this.$message.error("获取用户兼职历史失败，原因为：" + err);
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
    height: 223px;
    background-color: #fff;
    .imgs {
      padding: 21px 0;
      text-align: center;
      margin-bottom: 10px;
      img {
        border-radius: 50%;
        width: 60px;
        height: 60px;
        display: inline-block;
        cursor: pointer;
      }
      p {
        margin-top: 10px;
      }
    }
    .student_data {
      .rows {
        cursor: pointer;
        position: relative;
        margin-bottom: 22px;
        a{
          color:@font-color;
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
    min-height: 410px;
    margin-top: 20px;
    padding: 18px 23px;
    .list_title {
    }
    .no{
      text-align: center;
      color:@msg-color;
      margin-top:20px;
    }
    ul {
      li {
        position: relative;
        //   height:40px;
        margin: 20px 0;
        .list_data {
          width: 5em;
          white-space: nowrap;
          text-overflow: ellipsis;
          overflow: hidden;
          display: inline-block;
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