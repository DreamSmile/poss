<template>
  <div id="userData" :v-loading="loading">
    <p class="title">基本信息</p>
    <div class="block">
      <div class="rows">
        <span class="problem">id</span>
        <span class="answer">{{ userData.id }}</span>
      </div>
      <div class="rows">
        <span class="problem">用户名</span>
        <span class="answer">{{ userData.nickName }}</span>
      </div>
      <div class="rows">
        <span class="problem">性别</span>
        <span class="answer">{{ userData.sex || "无" }}</span>
      </div>
      <div class="rows">
        <span class="problem">签名</span>
        <span class="answer">{{ userData.signature || "无" }}</span>
      </div>
      <div class="rows">
        <span class="problem">手机</span>
        <span class="answer">{{ userData.phoneNumber || "无" }}</span>
      </div>
      <div class="rows">
        <span class="problem">邮箱</span>
        <span class="answer">{{ userData.email || "无" }}</span>
      </div>
    </div>
    <p class="title">教育信息</p>
    <div class="block">
      <div class="rows">
        <span class="problem">学校名称</span>
        <span class="answer">{{ campusInfo.mame || "未知" }}</span>
      </div>
      <div class="rows">
        <span class="problem">学历</span>
        <span class="answer">{{ campusInfo.type || "未知" }}</span>
      </div>
      <div class="rows">
        <span class="problem">专业</span>
        <span class="answer">{{ userData.major || "未知"}}</span>
      </div>
    </div>
    <p class="title">其他信息</p>
    <div class="block">
      <div class="rows">
        <span class="problem">参与兼职数</span>
        <span class="answer">{{ userData.joinCount || "0" }}</span>
      </div>
      <div class="rows" v-if="userData.role == 'merchant'">
        <span class="problem">发布兼职数</span>
        <span class="answer">{{ userData.publishCount || "0" }}</span>
      </div>
      <div class="rows">
        <span class="problem">正在申请商家</span>
        <span class="answer">{{ userData.applying ? "是" : "否" }}</span>
      </div>
    </div>
  </div>
</template>


<script>
export default {
  name: "UserData",
  props: {
    userData: {
      type: Object,
      default: () => {},
    },
  },
  data() {
    return {
      loading: true,
      campusInfo:{
        name:"",
        type:""
      }
    };
  },
  mounted() {
    this.setData();
  },
  methods: {
    // 根据传入的用户Id 获取用户其他信息
    setData() {
      this.loading = this.userData.loading;
      console.log(this.userData);
      this.campusInfo = this.userData.campusInfo;
    },
  },
};
</script>
<style scoped lang="less">
#userData {
  .title {
    font-weight: bold;
    font-size: 16px;
    line-height: 40px;
    border-bottom: 1px solid #ccc;
  }

  .block:hover {
    background-color: #f5f6f7;
  }
  .block {
    margin: 10px 0;

    .rows {
      line-height: 24px;
      .problem {
        color: #555666;
        width: 6em;
        overflow: hidden;
        display: inline-block;
        vertical-align: middle;
        // text-align-last: justify;
      }
      .answer {
        color: #162343;
        display: inline-block;
        vertical-align: middle;
      }
    }
  }
}
</style>