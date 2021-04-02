<template>
  <div id="userEdit">
    <top></top>
    <div class="content">
      <div
        class="imgs"
        :style="{ backgroundImage: 'url(' + imgSrc + ')' }"
      ></div>
      <!-- 基本信息修改 -->
      <el-form ref="form" :model="form" label-width="80px" size="mini">
        <div class="data_box">
          <p class="data_title">基本信息</p>
          <button class="keep" @click="keep">保存</button>
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
            ><router-link v-if="!form.mail" to="/mailPhoneConnect"
              >去绑定</router-link
            ><router-link v-else to="/MailPhoneEdit">修改</router-link>
          </el-form-item>
          <el-form-item label="手机号"
            ><span class="phone">{{ form.phone }}</span
            ><router-link v-if="!form.phone" to="/mailPhoneConnect"
              >去绑定</router-link
            >
            <router-link v-else to="/MailPhoneEdit">修改</router-link>
          </el-form-item>
          <el-form-item label="个性签名">
            <el-input type="textarea" v-model="form.autograph"></el-input>
          </el-form-item>
        </div>
        <!-- 教育背景 -->
        <div class="data_box">
          <p class="data_title">教育背景</p>
          <button class="keep" @click="keep">保存</button>
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
          mail: data.mail,
          phone: data.phoneNumber,
          autograph: data.signature,
          school: data.campusInfo ? data.campusInfo.name : null,
          education: data.campusInfo,
          major: data.major ? data.major : "",
        };
        this.$store.state.avatar
          ? (this.imgSrc = require(this.$store.state.avatar))
          : console.log("头像信息无");
      }
    },
    // 选择学校
    getSchoolList() {
      this.$api
        .getSchoolList()
        .then((res) => {
          if (!res.success) {
            this.$massage.error("获取学校列表失败！原因为：" + res.msg);
            return false;
          }
          this.schoolList = res.data;
        })
        .catch((err) => {
          this.$massage.error("获取学校列表失败！" + err);
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
      console.log(
        "学校：" +
          this.form.school +
          ",专业" +
          this.form.major +
          ",名字：" +
          this.form.name
      );
      console.log(
        "性别：" + this.form.sex + ",个性签名：" + this.form.autograph
      );
      let editData = {
        campus: this.form.school,
        major: this.form.major,
        nickName: this.form.name,
        sex: this.form.sex,
        signature: this.form.autograph,
      };
      this.$api
        .changeBaseData({
          editData,
        })
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.$massage.error("修改信息出错，原因为：" + res.msg);
            this.setData();
            return;
          }
          this.$message({
            message: "修改信息成功！",
            type: "success",
          });
          // 将数据修改到vux中去，未未写这部分代码
          Object.assign(this.$store.userData, editData);
        })
        .catch((err) => {
          console.log(err);
          this.$message.error('修改信息请求失败！');
        });
    },
  },
};
</script>