<template>
  <div id="school">
    <el-button type="primary" @click="schoolOpen = true">增加</el-button>
    <!-- 表格 -->
    <el-table :data="schoolList" style="width: 100%" height="550">
      <el-table-column prop="id" sortable label="id"> </el-table-column>
      <el-table-column prop="name" sortable label="学校名称"> </el-table-column>
      <el-table-column prop="type" sortable label="学历"> </el-table-column>
      <el-table-column prop="description" sortable label="备注">
      </el-table-column>
      <el-table-column fixed="right" label="操作" width="220">
        <template>
          <el-button type="button" size="small">详情</el-button>
        </template>
      </el-table-column>
    </el-table>
    <!-- 增加学校 -->
    <el-dialog
      title="添加学校"
      :visible.sync="schoolOpen"
      width="442px"
      height="246px"
    >
      <el-form ref="form" :model="add" label-width="80px" class="form">
        <el-form-item label="名称：">
          <el-input v-model="add.name" placeholder="请输入学校名称"></el-input>
        </el-form-item>
        <el-form-item label="类型：">
          <el-radio-group v-model="add.type" size="medium">
            <el-radio border label="本科"></el-radio>
            <el-radio border label="专科"></el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="描述：">
          <el-input
            v-model="add.description"
            placeholder="请输入学校描述"
          ></el-input>
        </el-form-item>
        <el-form-item>
          <el-button class="ban_btn" type="primary" @click="addSchool"
            >添加</el-button
          >
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
        name: "",
        type: "",
        description: "",
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
      console.log(this.add);
    },
  },
};
</script>
<style>
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}
::-webkit-scrollbar-thumb {
  background-color: #a1a3a9;
  border-radius: 3px;
}
</style>