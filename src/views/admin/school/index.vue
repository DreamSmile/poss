<template>
  <div id="school">
    <div class="work_space">
      <el-button type="primary" size="mini" @click="schoolOpen = true"
        >增加</el-button
      >
      <el-upload
        class="upload-demo"
        action="#"
        :before-upload="beforeAvatarUpload"
        :http-request="upFile"
        :show-file-list="false"
      >
        <el-button size="mini" type="primary" :loading="loading"

          >上传文件</el-button
        >
      </el-upload>
    </div>
    <!-- 表格 -->
    <el-table :data="schoolList" lazy style="width: 100%" height="550">
      <el-table-column prop="id" sortable label="id" width="100">
      </el-table-column>
      <el-table-column prop="name" sortable label="学校名称"> </el-table-column>
      <el-table-column prop="type" sortable label="学历"> </el-table-column>
      <el-table-column prop="description" sortable label="备注">
      </el-table-column>
    </el-table>
    <!-- 增加学校 -->
    <el-dialog
      title="添加学校"
      :visible.sync="schoolOpen"
      width="482px"
      height="246px"
      :before-close="clear"
    >
      <el-form
        ref="form"
        :model="add"
        label-width="100px"
        class="form"
        :rules="rules"
      >
        <el-form-item label="学校代码：" prop="id">
          <el-input
            v-model="add.id"
            placeholder="请输入学校代码"
            :validate-event="false"
          ></el-input>
        </el-form-item>
        <el-form-item label="学校名称：" prop="name">
          <el-input
            v-model="add.name"
            :validate-event="false"
            placeholder="请输入学校名称"
          ></el-input>
        </el-form-item>
        <el-form-item label="学校类型：" prop="type">
          <el-radio-group v-model="add.type" size="medium">
            <el-radio border label="本科"></el-radio>
            <el-radio border label="专科"></el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="学校描述：" prop="description">
          <el-input
            v-model="add.description"
            placeholder="请输入学校描述"
            :validate-event="false"
            type="textarea"
          ></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="addSchool">添加</el-button>
          <el-button @click="clear">取消</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
    <!-- 上传文件后，展示文件上传成功失败列表 -->
    <el-dialog title="添加学校详情" :visible.sync="fileOpen" width="482px">
      <el-form ref="fileform" label-width="90px" class="form">
        <p class="file_title">添加成功列表</p>
        <div v-if="fileList.length > 0">
          <el-form-item
            label="学校名称："
            v-for="(itemF, i) in fileList"
            :key="i"
          >
            {{ itemF.name }}
          </el-form-item>
        </div>
        <div v-else class="no_file">没有添加成功的数据~</div>
        <p class="file_title">添加失败列表</p>
        <div v-if="errFileList.length > 0">
          <el-form-item
            label="失败数据："
            v-for="(itemE, j) in errFileList"
            :key="j"
          >
            {{ itemE.name }}
            <p>原因：{{ itemE.type }}</p>
          </el-form-item>
        </div>
        <div v-else class="no_file">没有添加失败的数据~</div>
      </el-form>
    </el-dialog>
  </div>
</template>
<script>
export default {
  name: "school",
  data() {
    return {
      schoolList: [],
      loading:false,
      schoolOpen: false,
      fileOpen: false,
      btnClass: "el-icon-folder-add",
      fileEl: null,
      fileList: [], //上传成功后的文件，
      errFileList: [], //上传失败文件列表
      add: {
        id: "",
        name: "",
        type: "",
        description: "",
      },
      rules: {
        id: [
          { required: true, message: "请输入学校代码", trigger: "blur" },
          {
            trigger: "blur",
            type: "number",
            message: "学校代码必须为数字",
            transform: (value) => Number(value),
          },
        ],
        name: [
          { required: true, message: "请输入学校名称", trigger: "blur" },
          {
            min: 4,
            max: 10,
            message: "长度在 4 到 10 个字符",
            trigger: "blur",
          },
        ],
        type: [
          { required: true, message: "请选择学校类型", trigger: "change" },
        ],
        description: [
          { required: true, message: "请填写学校描述", trigger: "blur" },
          {
            min: 4,
            max: 10,
            message: "长度在 4 到 20 个字符",
            trigger: "blur",
          },
        ],
      },
    };
  },
  mounted() {
    this.setData();
  },
  methods: {
    setData() {
      this.$api
        .getSchoolList()
        .then((res) => {
          if (!res.success) {
            this.$message.error(res.msg);
            return;
          }
          this.schoolList = res.data;
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    // 增加学校
    addSchool() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.$adminApi
            .addSchool({
              description: this.add.description,
              id: this.add.id,
              name: this.add.name,
              type: this.add.type,
            })
            .then((res) => {
              if (!res.success) {
                this.$message.error(res.msg);
                return;
              }
              this.$message({
                message: "增加学校成功！",
                type: "success",
              });
              this.schoolList.push({
                description: this.add.description,
                id: this.add.id,
                name: this.add.name,
                type: this.add.type,
              });
              this.clear();
            })
            .catch((err) => {
              this.$message.error(err);
            });
        }
      });
    },
    // 文件上传前判断文件格式
    beforeAvatarUpload(file) {
      console.log(file);
      const isLt2M = file.size / 1024 / 1024 < 2;
      if (!isLt2M) {
        this.$message.error("txt文件不允许超过2MB!");
        return false;
      }
      if (file.type != "text/plain") {
        this.$message.error("请上传txt文件~");
        return false;
      }
      this.fileEl = new FormData();
      this.fileEl.set("file", file);
    },
    // 自定义上传文件
    upFile() {
      this.loading=true;
      this.$adminApi
        .upSchoolFile(this.fileEl)
        .then((res) => {
          this.successUp(res);
        })
        .catch((err) => {
          this.errorUp(err);
        });
    },
    // 文件上传成功
    successUp(res, file, fileList) {
      this.loading=false;
      console.log("文件上传成功");
      console.log(res);
      if (!res.success) {
        this.$message.error(res.msg);
        return;
      }
      let err = res.data.errList;
      let success = res.data.list;
      let fileName = "";
      for (let i = 0; i < success.length; i++) {
        fileName += success[i].name + "，";
        this.schoolList.push(success[i]);
      }
      fileName = fileName.substring(0, fileName.length - 1); //将最后一个逗号去除
      this.fileList = success;
      this.errFileList = err;
      this.$alert(
        "增加 " +
          success.length +
          "个文件成功~ " +
          err.length +
          " 个文件失败~",
        "文件上传",
        {
          confirmButtonText: "查看详情",
          callback: (action) => {
            this.fileOpen = true;
          },
        }
      );
    },
    // 文件上传失败
    errorUp(err, file, fileList) {
      // this.btnClass = "el-icon-folder-add";
      this.loading=false;
      console.log("文件上传失败");
      console.log(err);
      this.$message.error(err);
    },
    // 清除学校增加页面的数据
    clear() {
      this.schoolOpen = false;
      this.add = {
        id: "",
        name: "",
        type: "",
        description: "",
      };
      this.$nextTick(() => {
        this.$refs.form.resetFields();
      });
    },
  },
};
</script>
<style scoped lang="less">
.work_space {
  background-color: #fff;
  padding: 10px;
  margin-bottom: 10px;
}
.upload-demo {
  display: inline-block;
  margin-left: 10px;
}
/deep/.el-dialog__body {
  padding-top: 10px;
  height: 364px;
  overflow: auto;
}
/deep/.el-form-item {
  margin-bottom: 3px;
}
.no_file {
  margin: 10px 0;
  color: #8392a7;
}
.file_title {
  padding-left: 6px;
  border-left: 2px solid #0073cc;
  font-size: 16px;
}
/* ::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}
::-webkit-scrollbar-thumb {
  background-color: #a1a3a9;
  border-radius: 3px;
} */
</style>