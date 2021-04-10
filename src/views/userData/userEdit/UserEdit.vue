<template>
  <div id="userEdit">
    <top message="修改信息"></top>
    <div class="content">
      <div class="imgs" :style="{ backgroundImage: 'url(' +this.$store.state.userData.avatar || require('@/assets/imgs/user.jpg') + ')' }">
        <el-upload
          class="avatar-uploader"
          action="#"
          :show-file-list="false"
          :on-success="handleAvatarSuccess"
          :before-upload="beforeAvatarUpload"
        >
          <div class="img_hover" @click="upImg">
            <i class="el-icon-upload"></i>
            <p>上传图片</p>
          </div>
        </el-upload>
      </div>

      <!-- 基本信息修改 -->
      <el-form ref="form" :model="form" label-width="80px" size="mini">
        <div class="data_box">
          <p class="data_title">基本信息</p>
          <el-form-item label="用户名">
            <el-input v-model="form.name"></el-input>
          </el-form-item>
          <el-form-item label="性别">
            <el-radio-group v-model="form.sex">
              <el-radio label="男">男</el-radio>
              <el-radio label="女">女</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="邮箱"
            ><span class="mail">{{ form.mail }}</span
            ><router-link v-if="!form.mail" to="/mailPhoneConnect/mail"
              >去绑定</router-link
            ><router-link v-else to="/MailPhoneEdit/mail">修改</router-link>
          </el-form-item>
          <el-form-item label="手机号"
            ><span class="phone">{{ form.phone }}</span
            ><router-link v-if="!form.phone" to="/mailPhoneConnect/phone"
              >去绑定</router-link
            >
            
            <router-link v-else to="/MailPhoneEdit/phone">修改</router-link>
          </el-form-item>
          <el-form-item label="个性签名">
            <el-input type="textarea" v-model="form.autograph"></el-input>
          </el-form-item>
        </div>
        <!-- 教育背景 -->
        <div class="data_box">
          <p class="data_title">教育背景</p>
          <button type="button" class="keep" @click="keep">保存</button>
          <el-form-item label="毕业院校">
            <el-select
              v-model="form.school"
              placeholder="请选择学校"
              @change="changeSchool"
            >
              <el-option
                :label="item.name"
                :value="item.name"
                :sId="item.id"
                :sType="item.type"
                v-for="(item, i) in schoolList"
                :key="i"
              ></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="学历">
            <span class="education">{{ form.education || "学历不详" }}</span>
          </el-form-item>
          <el-form-item label="专业">
            <el-input v-model="form.major"></el-input>
          </el-form-item>
        </div>
      </el-form>
    </div>
  </div>
</template>
<script>
import Top from "../../../components/top.vue";

import "./userEdit.less";
export default {
  name: "UserEdit",
  components: {
    Top,
  },
  inject: ["reload"],
  data() {
    return {
      imgSrc: require("@/assets/imgs/user.jpg"),
      schoolList: [],
      form: {
        name: "",
        sex: "男",
        mail: "",
        phone: "",
        autograph: "",
        school: "",
        education: "",
        major: "",
      },
    };
  },
  mounted() {
    this.setData();
    this.getSchoolList();
  },
  methods: {
    setData() {
      if (this.$store.state) {
        let data = this.$store.state.userData;
        this.form = {
          name: data.nickName,
          sex: data.sex ? data.sex : "男",
          mail: data.email,
          phone: data.phoneNumber,
          autograph: data.signature,
          school: data.campusInfo ? data.campusInfo.name : null,
          education: data.campusInfo ? data.campusInfo.type : "",
          major: data.major ? data.major : "",
        };
        this.$store.state.userData.avatar
          ? (this.imgSrc = this.$store.state.userData.avatar)
          : "";
      }
    },
    // 选择学校
    getSchoolList() {
      this.$api
        .getSchoolList()
        .then((res) => {
          if (!res.success) {
            this.$message.error("获取学校列表失败！原因为：" + res.msg);
            return false;
          }
          this.schoolList = res.data;
        })
        .catch((err) => {
          this.$message.error("获取学校列表失败！" + err);
        });
    },
    // 监听学校选择变化
    changeSchool(el) {
      this.schoolList.find((item) => {
        if (item.name == el) {
          this.form.education = item.type;
        }
      });
    },
    // 保存修改后的信息
    keep() {
      this.$api
        .changeBaseData({
          campus: this.form.school,
          major: this.form.major,
          nickName: this.form.name,
          sex: this.form.sex,
          signature: this.form.autograph,
        })
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.$message.error("修改信息出错，原因为：" + res.msg);
            this.setData();
            return;
          }
          this.$message({
            message: "修改信息成功！",
            type: "success",
          });
          // 将数据修改到vux中去，未未写这部分代码
          this.$store.commit("editUserData", {
            campus: this.form.school,
            major: this.form.major,
            nickName: this.form.name,
            sex: this.form.sex,
            signature: this.form.autograph,
          });
          console.log(this.form.name);
          // setTimeout(() => {
          //   this.$router.push("/userBase");
          // }, 2000);
        })
        .catch((err) => {
          this.$message.error("修改信息请求失败！");
          this.setData();
        });
    },
    // 上传头像
    upImg() {},
    // 确定上传前，检查图片格式
    beforeAvatarUpload(file) {
      const isLt2M = file.size / 1024 / 1024 < 2;

      if (file.type != "image/png" && file.type != "image/jpeg") {
        this.$message.error("上传头像图片只能是 JPG户或者PNG 格式!");
        return false;
      }
      if (!isLt2M) {
        this.$message.error("上传头像图片大小不能超过 2MB!");
        return false;
      }
      // 记重点！！！！一定要FormData序列化，不然传的不会是文件，会是文件id!!!!!
      const fd = new FormData();
      fd.append("file", file);
      this.$api
        .upImg(fd)
        .then((res) => {
          if (!res.success) {
            this.$message.error("头像修改失败，原因为：" + res.msg);
            return;
          }
          this.$message({
            message: "修改头像成功！即将跳入用户基本信息页",
            type: "success",
          });
           setTimeout(() => {
            this.$router.push("/userBase");
          }, 2000);
        })
        .catch((err) => {
          this.$message.error("上传头像错误！");
        });
      return false;
    },
    // 上传成功
    handleAvatarSuccess() {
      console.log("上传成功");
    },
  },
};
</script>