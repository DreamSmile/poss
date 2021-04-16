<template>
  <div class="user_profile">
    <div
      class="imgs"
      :style="{
        backgroundImage:
          'url(' + this.$store.state.userData.avatar ||
          require('@/assets/imgs/user.jpg') + ')',
      }"
    ></div>
    <div class="user_summary">
      <span>{{ $store.state.userData.nickName || "无" }}</span>
      <i
        :class="
          $store.state.userData.sex == null || $store.state.userData.sex == '男'
            ? 'el-icon-male'
            : 'el-icon-female'
        "
      ></i>
      <button
        type="button"
        @click="isGobusiness"
        v-if="
          !this.$store.state.userData.applying &&
          $store.state.userData.role != 'merchant'
        "
      >
        成为商家
      </button>
      <button
        type="button"
        v-if="
          this.$store.state.userData.applying &&
          $store.state.userData.role != 'merchant'
        "
      >
        申请商家中
      </button>
      <el-divider></el-divider>
      <div class="box_first">
        <p class="box_number">{{ $store.state.userData.joinCount || 0 }}</p>
        <p class="box_msg">参加过的兼职</p>
      </div>

      <div class="box_second" v-if="$store.state.userData.role == 'merchant'">
        <p class="box_number">{{ $store.state.userData.publishCount || 0 }}</p>
        <p class="box_msg">发布过的兼职</p>
      </div>
      <p class="msg">
        个性签名：{{
          $store.state.userData.signature || "该用户很懒，还没有写个性签名~"
        }}
      </p>
    </div>
    <!-- 成为商家画面 -->
    <el-dialog :visible.sync="dialogVisible" width="780px" height="524px">
      <div class="business_box">
        <to-business @business="isBusiness"></to-business>
      </div>
    </el-dialog>
  </div>
</template>
<script>
import toBusiness from "./toBusiness";
export default {
  name: "userBaseData",
  components: {
    toBusiness,
  },
  data() {
    return {
      dialogVisible: false,
      business: false,
    };
  },
  mounted() {},
  methods: {
    // 接收子组件的值，将申请商家按钮变为提示正在申请
    isBusiness(data) {
      this.business = data;
      this.dialogVisible = false;
    },
    // 检测是否有资格申请商家
    isGobusiness() {
      this.$api
        .isGobusiness()
        .then((res) => {
          if (!res.success) {
            this.$message.error("申请成为商家失败原因为：" + res.msg);
            return;
          }
          this.dialogVisible = true;
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
    .el-icon-female {
      color: #fd6847;
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
  .el-dialog__wrapper {
    /deep/.el-dialog {
      border-radius: 20px !important;
    }
  }
}
</style>