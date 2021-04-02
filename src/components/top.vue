<template>
  <div id="top">
    <div class="bg">
      <div class="inner">
        <img src="@/assets/imgs/logo.png" alt="boss直聘" />
        <div class="nav">
          <ul>
            <li><router-link to="/">首页</router-link></li>
            <li v-if="userData.role=='business'"><router-link to="/pushJob">发布</router-link></li>
          </ul>
        </div>
      </div>
      <!-- 右侧 -->
      <div class="navData">
        <!-- 未登录区 -->
        <div class="btns">
          <button v-if="!$store.state.accessToken">
            <router-link to="/register">注册</router-link>
          </button>
          <button v-if="!$store.state.accessToken">
            <router-link to="/login">登录</router-link>
          </button>
          <!-- 已登录区 -->
          <span v-if="$store.state.accessToken"><router-link to="/dialogue">聊天</router-link></span>
          <span v-if="$store.state.accessToken">{{userData.nickName}}</span>
          <router-link to="/userData">
            <div v-if="$store.state.accessToken"
              class="imgs"
              :style="{ backgroundImage: 'url(' + imgSrc + ')' }"
            ></div>
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: "Top",
  data() {
    return {
      userData: {},
      imgSrc: require("@/assets/imgs/user.jpg"),
    };
  },
  mounted() {
    this.setData();
  },
  methods: {
    setData() {
      // avatar:头像;campusInfo: 学校对象;email: 邮箱;id: 用户id joinCount: 参加兼职数；major: 专业
      // nickName: 用户名 phoneNumber: 电话 role: 身份  sex: 性别 signature: 签名 status: 状态
      if (this.$store.state) {
        this.userData = this.$store.state.userData;
        this.$store.state.avatar
          ? (this.imgSrc = require(this.$store.state.avatar))
          : '';
        // console.log(this.userData);
      }
    },
  },
};
</script>
<style scoped lang="less">
#top {
  width: 100%;
  height: 50px;
  position: fixed;
  top: 0;
  left: 0;
  background-color: #162343;
  z-index: 100;
  .bg {
    height: 50px;
    top: 0;
    left: 0;
    width: 80%;
    margin: 0 auto;
    min-width: 900px;
    z-index: 100;
    position: relative;
    .inner {
      box-sizing: border-box;
      position: absolute;
      top: 50%;
      margin-top: -25px;
      height: 100%;
      img {
        width: 140px;
        vertical-align: middle;
        display: inline-block;
        margin-right: 12px;
      }
      .nav {
        display: inline-block;
        vertical-align: middle;
        height: 100%;
        ul {
          text-align: center;
          height: 100%;
          li {
            font-size: 14px;
            float: left;
            color: #fff;
            font-weight: 400;
            width: 89px;
            background-color: transparent;
            font-weight: 400;
            height: 100%;
            margin-top: 15px;
            /deep/a {
              color: #fff;
              text-decoration: none;
            }
          }
        }
      }
    }
    .navData {
      position: absolute;
      right: 20px;
      height: 100%;
      line-height: 50px;
      top: 0;
      .btns {
        display: inline-block;
        button {
          margin: 0 13px;
          width: 54px;
          height: 20px;
          border: 1px solid #0eaaf5;
          opacity: 1;
          border-radius: 20px;
          background-color: transparent;
          /deep/a {
            color: #fff;
            text-decoration: none;
          }
        }
        /deep/.el-badge {
          color: #fff;
          margin: 0 16px;
          cursor: pointer;
          line-height: 48px;
        }
        span {
          color: #fff;
          cursor: pointer;
          line-height: 48px;
          display: inline-block;
          margin-left: 32px;
          font-size: 14px;
          font-weight: 400;
          /deep/a {
            color: #fff;
            text-decoration: none;
          }
        }
        .imgs {
          width: 26px;
          height: 26px;
          border-radius: 50%;
          display: inline-block;
          margin-left: 14px;
          vertical-align: middle;
          background-size: cover;
          background-position: 50%;
          background-color: #ddd;
        }
      }
    }
  }
}
</style>
