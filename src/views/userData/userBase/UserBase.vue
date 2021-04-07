<template>
  <div id="userBase">
    <!-- 基本头像信息 -->
    <user-base-data></user-base-data>
    <!-- 基本信息 -->
    <div class="base_data">
      <p class="data_title">基本信息</p>
      <router-link to="/userEdit"><button>修改</button></router-link>
      <div class="rows first_row">
        <span class="row_problem">用户名</span
        ><span class="row_answer">{{userData.nickName || '无'}}</span>
      </div>
         <div class="rows first_row">
        <span class="row_problem">性别</span
        ><span class="row_answer">{{userData.sex || '无'}}</span>
      </div>
         <div class="rows first_row">
        <span class="row_problem">手机号</span
        ><span class="row_answer">{{userData.phoneNumber || '无'}}</span>
      </div>
         <div class="rows first_row">
        <span class="row_problem">邮箱</span
        ><span class="row_answer">{{userData.email || '无'}}</span>
      </div>
    </div>
    <!-- 教育背景 -->
    <div class="base_data">
      <p class="data_title">教育背景</p>
      <router-link to="/userEdit"> <button>修改</button></router-link>
      <div class="rows first_row">
        <span class="row_problem">毕业院校</span
        ><span class="row_answer">{{school.name || '无'}}</span>
      </div>
        <div class="rows first_row">
        <span class="row_problem">学历</span
        ><span class="row_answer">{{school.type || '无'}}</span>
      </div>
        <div class="rows first_row">
        <span class="row_problem">专业</span
        ><span class="row_answer">{{userData.major || '无'}}</span>
      </div>
    </div>
  </div>
</template>
<script>
import "./userbase.less";
import userBaseData from "@/components/userBaseData";
export default {
  components: {
    userBaseData,
  },
  data() {
    return {
      userData: {},
      school:{
        name:'',
        type:''
      }
    };
  },
  mounted() {
    this.setData();
  },
  methods: {
    setData() {
      if (this.$store.state) {
        console.log("用户基本信息设置数据");
        this.userData = this.$store.state.userData;
        this.$store.state.avatar
          ? (this.imgSrc = require(this.$store.state.avatar))
          : '';
          this.school=this.$store.state.userData.campusInfo?this.$store.state.userData.campusInfo:{'name':'','type':''};

      }
    },
  },
};
</script>
