<template>
  <div class="user_profile">
    <div class="imgs" :style="{ backgroundImage: 'url(' + imgSrc + ')' }"></div>
    <div class="user_summary">
      <span>{{ userData.nickName }}</span>
      <i
        :class="
          userData.sex == null || 'man' ? 'el-icon-male' : 'el-icon-female'
        "
      ></i>
      <button>成为商家</button>
      <el-divider></el-divider>
      <div class="box_first">
        <p class="box_number">{{ userData.joinCount }}</p>
        <p class="box_msg">参加过的兼职</p>
      </div>
      <div class="box_second">
        <p class="box_number">32</p>
        <p class="box_msg">发布过的兼职</p>
      </div>
      <p class="msg">
        个性签名：{{ userData.signature || "该用户很懒，还没有写个性签名~" }}
      </p>
    </div>
  </div>
</template>
<script>
export default {
  name: "userBaseData",
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
      if (this.$store.state) {
        this.userData = this.$store.state.userData;
        this.$store.state.avatar
          ? (this.imgSrc = require(this.$store.state.avatar))
          : console.log("头像信息无");
      }
    },
  },
};
</script>
<style scoped lang="less">
@import "../assets/css/common.less";
.user_profile {
  margin-bottom: 30px;
  display: flex;
  .imgs {
    width: 188px;
    height: 188px;
    overflow: hidden;
    text-align: center;
    display: inline-block;
    background-size: cover;
    background-position: 50%;
    background-color: #ddd;
  }
  .user_summary {
    display: inline-block;
    margin-left: 20px;
    flex: 1;
    position: relative;
    span {
      color: @font-color;
      font-size: 20px;
      font-weight: bold;
      line-height: 54px;
    }
    .el-icon-male,
    .el-icon-female {
      color: @base-color;
      font-weight: bold;
      margin-left: 10px;
    }
    button {
      position: absolute;
      right: 0;
      top: 10px;
      border: 1px solid @base-color;
      background-color: #fff;
      color: @base-color;
      padding: 8px 24px;
      cursor: pointer;
    }
    button:hover {
      background-color: #ecf5ff;
    }
    .el-divider {
      margin: 0;
    }
    .box_second:after {
      content: "";
      width: 1px;
      height: 50px;
      position: absolute;
      top: 75px;
      left: 97px;
      background: #dcdfe6;
    }
    .box_first,
    .box_second {
      text-align: center;
      display: inline-block;
      width: 6em;
      margin-right: 20px;

      .box_number {
        font-size: 24px;
        line-height: 70px;
        color: @base-color;
      }
      .box_msg {
        font-size: 12px;
        color: @font-color;
        line-height: 30px;
      }
    }
    .box_second {
      margin-left: 10px;
    }
    .msg {
      color: @msg-color;
      font-size: 12px;
      line-height: 48px;
    }
  }
}
</style>