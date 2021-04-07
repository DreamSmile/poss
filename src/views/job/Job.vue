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
          </div>
          <div class="school">{{ jobData.workplace }}</div>
          <router-link to="/dialogue"><button type="button">立即沟通</button></router-link>
        </div>
      </div>
      <!-- 底部招聘详细信息 -->
      <div class="job_box">
        <!-- 举报按钮 -->
        <div class="report">举报</div>
        <div class="hr">
          <div
            class="imgs"
            :style="{ backgroundImage: 'url(' + imgSrc + ')' }"
          ></div>
          <div class="hr_data">
            <p class="hr_name">{{ jobData.publisher.nickName || "招聘者" }}</p>
            <p class="hr_state">刚刚在线</p>
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
                负责人：{{ jobData.publisher.nickName || "--" }}
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
            <span class="download" @click="downFile">下载</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<style scoped lang="less">
</style>
<script>
import Top from "../../components/top.vue";
import "./job.less";
export default {
  name: "Job",
  data() {
    return {
      jobData: {},
      status: 1,
      imgSrc: require("@/assets/imgs/user.jpg"),
    };
  },
  components: {
    Top,
  },
  mounted() {
    this.getData();
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
    // 查看文件
    lookFile() {
      let Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(input){var output="";var chr1,chr2,chr3,enc1,enc2,enc3,enc4;var i=0;input=Base64._utf8_encode(input);while(i<input.length){chr1=input.charCodeAt(i++);chr2=input.charCodeAt(i++);chr3=input.charCodeAt(i++);enc1=chr1>>2;enc2=((chr1&3)<<4)|(chr2>>4);enc3=((chr2&15)<<2)|(chr3>>6);enc4=chr3&63;if(isNaN(chr2)){enc3=enc4=64;}else if(isNaN(chr3)){enc4=64;}
output=output+this._keyStr.charAt(enc1)+this._keyStr.charAt(enc2)+this._keyStr.charAt(enc3)+this._keyStr.charAt(enc4);}
return output;},decode:function(input){var output="";var chr1,chr2,chr3;var enc1,enc2,enc3,enc4;var i=0;input=input.replace(/[^A-Za-z0-9\+\/\=]/g,"");while(i<input.length){enc1=this._keyStr.indexOf(input.charAt(i++));enc2=this._keyStr.indexOf(input.charAt(i++));enc3=this._keyStr.indexOf(input.charAt(i++));enc4=this._keyStr.indexOf(input.charAt(i++));chr1=(enc1<<2)|(enc2>>4);chr2=((enc2&15)<<4)|(enc3>>2);chr3=((enc3&3)<<6)|enc4;output=output+String.fromCharCode(chr1);if(enc3!=64){output=output+String.fromCharCode(chr2);}
if(enc4!=64){output=output+String.fromCharCode(chr3);}}
output=Base64._utf8_decode(output);return output;},_utf8_encode:function(string){string=string.replace(/\r\n/g,"\n");var utftext="";for(var n=0;n<string.length;n++){var c=string.charCodeAt(n);if(c<128){utftext+=String.fromCharCode(c);}
else if((c>127)&&(c<2048)){utftext+=String.fromCharCode((c>>6)|192);utftext+=String.fromCharCode((c&63)|128);}
else{utftext+=String.fromCharCode((c>>12)|224);utftext+=String.fromCharCode(((c>>6)&63)|128);utftext+=String.fromCharCode((c&63)|128);}}
return utftext;},_utf8_decode:function(utftext){var string="";var i=0;var c=c1=c2=0;while(i<utftext.length){c=utftext.charCodeAt(i);if(c<128){string+=String.fromCharCode(c);i++;}
else if((c>191)&&(c<224)){c2=utftext.charCodeAt(i+1);string+=String.fromCharCode(((c&31)<<6)|(c2&63));i+=2;}
else{c2=utftext.charCodeAt(i+1);c3=utftext.charCodeAt(i+2);string+=String.fromCharCode(((c&15)<<12)|((c2&63)<<6)|(c3&63));i+=3;}}
return string;}}
      console.log(Base64.encode(this.jobData.attachment));
      let url = this.jobData.attachment;
      // window.open(
      //   "http://192.168.37.39/:8012/onlinePreview?url=" +
      //     encodeURIComponent(Base64.encode(url))
      // );
      // !this.jobData.attachment
      //   ? window.open(
      //       "http://127.0.0.1:8012/onlinePreview?url=" +
      //         encodeURIComponent(base64Encode(this.jobData.attachment))
      //     )
      //   : this.$message.error("文件打开失败");
    },
    downFile() {
      window.open(this.jobData.attachment);
    },
  },
};
</script>