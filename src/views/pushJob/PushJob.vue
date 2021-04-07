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
           

            <el-select v-model="form.school" placeholder="请选择发布学校" style="width: 174px">
                <el-option
                  :label="item.name"
                  :value="item.name"
                  :sId="item.id"
                  :sType="item.type"
                  v-for="(item, i) in schoolList"
                  :key="i"
                ></el-option>
              </el-select>
            
             </el-form-item
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
              v-model="form.data"
              type="date"
              placeholder="请选择开始时间"
            >
            </el-date-picker>
          </el-form-item>

          <el-form-item prop="time" label=" " style="display: inline-block">
            <el-input
              v-model="form.time"
              placeholder="请输入兼职时间"
              style="width: 200px"
            ></el-input>
          </el-form-item>

          <el-form-item label=" ">
            <el-upload
              class="upload-demo"
              action="#"
              :on-preview="handlePreview"
              :on-remove="handleRemove"
              multiple
              :limit="3"
              :on-exceed="handleExceed"
            >
              <el-button><i class="el-icon-link"></i>点击上传附件</el-button>
            </el-upload>
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
            <el-button type="primary">发布</el-button>
            <el-button>取消</el-button>
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
      schoolList:[],
      form: {
        name: "",
        school: "",
        num: "",
        money: "",
        place: "",
        data: "",
        time: "",
        content: "",
      },
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
    };
  },
  mounted(){
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
    handleRemove(file, fileList) {
      console.log(file, fileList);
    },
    handlePreview(file) {
      console.log(file);
    },
    handleExceed(files, fileList) {
      this.$message.warning(
        `当前限制选择 3 个文件，本次选择了 ${files.length} 个文件，共选择了 ${
          files.length + fileList.length
        } 个文件`
      );
    },
    beforeRemove(file, fileList) {
      return this.$confirm(`确定移除 ${file.name}？`);
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
      button{
        width:200px;
      }
    }
  }
}
</style>