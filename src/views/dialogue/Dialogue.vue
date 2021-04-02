<template>
  <div id="dialogue">
    <top></top>
    <div class="content">
      <div class="content_flex">
        <div class="user_list">
          <p>30天内联系人</p>
          <div class="list">
            <div class="list_box" v-for="i in 5" :key="i">
              <div
                class="imgs"
                :style="{ backgroundImage: 'url(' + imgSrc + ')' }"
              >
              </div>
              <div class="user">
                <p class="user_name">林先生</p>
                <p class="user_data">
                  闽江学院<el-divider direction="vertical"></el-divider>招聘者
                </p>
              </div>
              <p class="time">11:20</p>
            </div>
          </div>
        </div>
        <div class="dialog_box">
          <div class="box_data">
            <p class="job_master">林先生<span>闽江学院</span></p>
            <p class="job_data">
              沟通职位<span class="job_name">软件开发校招实习生</span
              ><span class="job_money">时薪20/小时</span>
            </p>
          </div>
          <div class="box">这是聊天的</div>
          <div class="dialog_input">
            <el-button>发送</el-button>
            <el-divider></el-divider>
            <p class="icon">
              <img src="@/assets/imgs/face.png" />
              <img class="photo" src="@/assets/imgs/photo.png" />
            </p>
            <div class="inp">
              <textarea></textarea>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Top from "../../components/top.vue";
import "./dialogue.less";
export default {
  name: "dialogue",
  components: {
    Top,
  },
  data() {
    return {
      imgSrc: require("@/assets/imgs/user.jpg"),
    };
  },
};
</script>