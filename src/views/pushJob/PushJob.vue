<template>
  <div id="pushJob">
    <top></top>
    <div class="content">
      <p class="content_title">发布信息</p>
      <div class="forms">
        <el-form ref="form" :model="form" label-width="60px" :rules="rules">
          <p class="title">工作信息</p>
          <el-form-item prop="name" label=" ">
            <el-input
              v-model="form.name"
              placeholder="请输入工作标题"
              maxlength="15"
              show-word-limit
            ></el-input>
          </el-form-item>

          <el-form-item label="*" style="display: inline-block">
            <el-select
              v-model="form.school"
              placeholder="请选择发布学校"
              style="width: 174px"
            >
              <el-option
                :label="item.name"
                :value="item.name"
                :sId="item.id"
                :sType="item.type"
                v-for="(item, i) in schoolList"
                :key="i"
              ></el-option>
            </el-select> </el-form-item
          ><el-form-item
            prop="num"
            class="num"
            label=" "
            style="display: inline-block"
          >
            <el-input
              v-model="form.num"
              placeholder="请输入人数限制"
              style="width: 210px"
            ></el-input> </el-form-item
          ><el-form-item
            prop="money"
            class="money"
            label=" "
            style="display: inline-block"
          >
            <el-input
              v-model="form.money"
              placeholder="请输入时薪"
              style="width: 210px"
            ></el-input>
          </el-form-item>

          <el-form-item prop="place" label=" ">
            <el-input
              v-model="form.place"
              placeholder="请输入工作地点"
              label=" "
              maxlength="25"
              show-word-limit
            ></el-input>
          </el-form-item>

          <el-form-item prop="data" label="*" style="display: inline-block">
            <el-date-picker
              v-model="form.date"
              type="datetime"
              placeholder="请选择开始时间"
                  :picker-options="pickerOptions"

            >
            </el-date-picker>
              <!-- <el-date-picker
              v-model="form.time"
              type="datetime"
              placeholder="请输入兼职时间"
              style="width: 200px"
            >
            </el-date-picker> -->
          </el-form-item>

          <el-form-item prop="time" label=" " style="display: inline-block">
            <el-input
              v-model="form.time"
              placeholder="请输入兼职时间"
              style="width: 200px"
              value-format="yyyy-MM-dd"
              format="yyyy-MM-dd"
            ></el-input>
          </el-form-item>

          <el-form-item label=" ">
            <el-upload
              class="upload-demo"
              action="#"
              :before-upload="beforeAvatarUpload"
            >
              <el-button><i class="el-icon-link"></i>点击上传附件</el-button>
            </el-upload>
            <span class="fileName">{{ fileName }}</span>
          </el-form-item>
          <p class="content_title">工作内容</p>
          <el-form-item label=" ">
            <el-input
              type="textarea"
              v-model="form.content"
              maxlength="150"
              show-word-limit
            ></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="pushJob">发布</el-button>
            <el-button @click="reset">取消</el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>
  </div>
</template>
<script>
import Top from "../../components/top.vue";
export default {
  name: "PushJob",
  components: {
    Top,
  },
  data() {
    return {
      schoolList: [],
      formData: new FormData(),
      form: {
        name: "",
        school: "",
        num: "",
        money: "",
        place: "",
        date: "",
        time: "",
        content: "",
      },
      files: null,
      fileName: "",
      rules: {
        name: [
          { required: true, message: "请输入工作标题", trigger: "blur" },
          {
            min: 2,
            max: 10,
            message: "长度在 2 到 10 个字符",
            trigger: "blur",
          },
        ],
        num: [
          {
            required: true,
            message: "请输入人数限制",
            trigger: "blur",
          },
          {
            trigger: "blur",
            type: "number",
            message: "人数限制必须为数字",
            transform: (value) => Number(value),
          },
        ],
        money: [
          {
            required: true,
            message: "请输入时薪",
            trigger: "blur",
          },
          {
            trigger: "blur",
            type: "number",
            message: "时薪必须为数字",
            transform: (value) => Number(value),
          },
        ],
        place: [
          { required: true, message: "请输入工作地点", trigger: "blur" },
          {
            min: 2,
            max: 15,
            message: "长度在 2 到 15 个字符",
            trigger: "blur",
          },
        ],
        time: [
          {
            required: true,
            message: "请输入时间",
            trigger: "blur",
          },
          {
            trigger: "blur",
            type: "number",
            message: "兼职时间必须是数字",
            transform: (value) => Number(value),
          },
        ],
      },
      pickerOptions:{
        disabledDate (time) {return time.getTime() < Date.now()}
      }
    };
  },
  mounted() {
    this.getSchoolList();
  },
  methods: {
    // 获取学校列表
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
    // 文件上传前阻止文件上传，一起提交
    beforeAvatarUpload(file) {
      this.fileName = file.name;
      this.formData.set("file", file);
      return false;
    },
    // 取消发布
    reset() {
      console.log(this.$utils.returntimes(this.form.date));
      // this.formData=new FormData();
    },
    // 发布兼职
    pushJob() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          let data = {
            campus: this.form.school,
            content: this.form.content,
            duration: parseInt(this.form.time),
            file: this.files,
            hourlyWage: parseInt(this.form.money),
            limit: parseInt(this.form.num),
            startTime: this.$utils.returntimes(this.form.date),
            title: this.form.name,
            workplace: this.form.place,
          };
          this.formData.set("campus", this.form.school);
          this.formData.set("content", this.form.content);
          this.formData.set("duration", parseInt(this.form.time));
          this.formData.set("hourlyWage", parseInt(this.form.money));
          this.formData.set("limit", parseInt(this.form.num));
          this.formData.set(
            "startTime",
            this.$utils.returntimes(this.form.date)
          );
          this.formData.set("title", this.form.name);
          this.formData.set("workplace", this.form.place);
          this.$api
            .pushJob(this.formData)
            .then((res) => {
              if (!res.success) {
                this.$message.error("发布兼职失败，原因为：" + res.msg);
                return;
              }
              this.$message({
                message: "发布招聘信息成功！将为您跳转至首页！",
                type: "success",
              });
              setTimeout(() => {
                this.$router.push("/");
              }, 2000);
            })
            .catch((err) => {
              this.$message.error("兼职发布失败");
            });
        }
      });
    },
  },
};
</script>
<style scoped lang="less">
@import "../../assets/css/common.less";
#pushJob {
  .content {
    width: 70%;
    min-width: 800px;
    margin: 0 auto;
    margin-top: 80px;
    .content_title {
      font-size: 16px;
      line-height: 54px;
      color: @font-color;
    }
    .forms {
      margin-top: 10px;
      .title {
        color: @font-color;
      }

      /deep/.el-input__inner:after {
        content: "*";
        color: red;
        font-size: 14px;
      }
      /deep/.el-form-item__label {
        color: red;
      }
      /deep/.el-textarea__inner {
        height: 200px;
      }
      button {
        width: 200px;
      }
    }
  }
}
</style>