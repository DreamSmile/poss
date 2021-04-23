<template>
  <div id="school">
    <div class="work_space">
      <el-button type="primary" size="mini" @click="schoolOpen = true"
        >增加</el-button
      >
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
  </div>
</template>
<script>
export default {
  name: "school",
  data() {
    return {
      schoolList: [],
      schoolOpen: false,
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
            this.$messsge.error(res.msg);
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
<style>
.work_space {
  background-color: #fff;
  padding: 10px;
  margin-bottom: 10px;
}
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}
::-webkit-scrollbar-thumb {
  background-color: #a1a3a9;
  border-radius: 3px;
}
</style>