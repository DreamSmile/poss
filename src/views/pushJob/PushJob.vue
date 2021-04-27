<template>
  <div
    id="pushJob"
    v-loading="loading"
    element-loading-text="拼命加载中"
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.0)"
  >
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
              :default-value="form.date"
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

          <el-form-item label=" " style="display: inline-block">
            <el-button
              v-if="jobInfo.status == 1 && jobInfo.joinList.length > 0"
              @click="userList"
              >参与者申请列表</el-button
            >
          </el-form-item>
          <!-- 参与者界面 -->
          <el-dialog
            :visible.sync="dialogVisible"
            title="移除申请用户"
            width="380px"
          >
            <el-scrollbar style="height: 100%">
              <ul>
                <li v-for="(item, i) in jobInfo.joinList" :key="i">
                  <div
                    class="face"
                    :style="{
                      backgroundImage:
                        'url(' + item.avatar ||
                        require('@/assets/imgs/user.jpg') + ')',
                    }"
                  ></div>
                  <span class="name">{{ item.nickName }}</span>
                  <i class="el-icon-close del" @click="delUser(item.id, i)"></i>
                </li>
              </ul>
            </el-scrollbar>
          </el-dialog>

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
          <!-- <el-form-item label=" ">
            <el-input
              type="textarea"
              v-model="form.content"
              maxlength="150"
              show-word-limit
            ></el-input>
          </el-form-item> -->
          <el-form-item label=" ">
          <editor-bar
            v-model="form.content"
            :isClear="isClear"
            @change="change"
          >
          </editor-bar>
           </el-form-item> 
          <el-form-item>
            <el-button type="primary" v-if="isNew" @click="pushJob"
              >发布</el-button
            >
            <el-button
              type="primary"
              v-if="!isNew && this.jobInfo.status == 1"
              @click="pushJob"
              >修改</el-button
            >
            <el-button
              type="success"
              v-if="!isNew && this.jobInfo.status == 1"
              @click="ingJob"
              >开始</el-button
            >
            <el-button
              type="danger"
              v-if="!isNew && this.jobInfo.status != 0"
              @click="overJob"
              >结束</el-button
            >
            <el-button type="danger" v-if="!isNew" @click="delJob"
              >删除</el-button
            >
          </el-form-item>
        </el-form>
      </div>
    </div>
  </div>
</template>
<script>
import EditorBar from "../../components/wangEnduit";
import Top from "../../components/top.vue";
export default {
  name: "PushJob",
  components: {
    Top,
    EditorBar,
  },
  data() {
    return {
      isClear: false,
      detail: "", //富文本编辑器
      dialogVisible: false,
      loading: false,
      isNew: true,
      schoolList: [],
      jobInfo: {},
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
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() < Date.now();
        },
      },
    };
  },
  mounted() {
    this.getSchoolList();
    if (this.$route.params.id != 0) {
      this.isNew = false;
      this.setData(); //如果是修改兼职界面
    }
  },
  methods: {
    // 富文本编辑器
    change(val) {
      // console.log(val);
    },
    // 获取该兼职信息，方便修改
    setData() {
      this.$api
        .getJobData({
          pid: this.$route.params.id,
        })
        .then((res) => {
          if (!res.success) {
            this.$message.error("获取兼职详情错误！原因为：" + res.msg);
            return false;
          }
          this.form = {
            name: res.data.title,
            school: res.data.campus,
            num: res.data.limit,
            money: res.data.hourlyWage,
            place: res.data.workplace,
            date: res.data.startTime,
            time: res.data.duration,
            content: res.data.content,
          };
          this.fileName = res.data.attachmentName;
          this.jobInfo = res.data;
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
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
          if (this.$route.params.id == 0) {
            this.form.school = this.$store.state.userData.campusInfo.name;
          }
        })
        .catch((err) => {
          this.$message.error("获取学校列表失败！" + err);
        });
    },
    // 获取兼职参与者列表
    userList() {
      this.dialogVisible = true;
    },
    // 移除某员工
    delUser(userId, index) {
      this.$confirm("是否取消该学生兼职申请", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          this.$api
            .selUserById({
              pid: this.$route.params.id,
              userId: userId,
            })
            .then((res) => {
              if (!res.success) {
                this.$message.error(res.msg);
                return;
              }
              this.jobInfo.joinList.splice(index, 1);
              this.$message({
                message: "移除成功！",
                type: "success",
              });
            })
            .catch((err) => {
              this.$message.error(err);
            });
        })
        .catch(() => {});
    },
    // 文件上传前阻止文件上传，一起提交
    beforeAvatarUpload(file) {
      this.fileName = file.name;
      this.formData.set("file", file);
      return false;
    },
    // 取消发布
    reset() {},
    // 发布兼职，或者修改兼职
    pushJob() {
      this.loading = true;
      let jobId = this.$route.params.id;
      this.$refs.form.validate((valid) => {
        if (valid) {
          !this.isNew ? this.formData.set("id", jobId) : "";
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
          this.isNew
            ? this.pushJobAxios(this.formData)
            : this.editJobAxios(this.formData);
        }
      });
    },
    
    // 发布兼职
    pushJobAxios(data) {
      this.$api
        .pushJob(data)
        .then((res) => {
          this.loading = false;
          if (!res.success) {
            this.$alert("发布兼职失败，原因为：" + res.msg);
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
          this.loading = false;
          this.$alert("兼职发布失败");
        });
    },
    // 修改兼职
    editJobAxios(data) {
      let workDate = parseInt(
        this.$utils.timeOut(this.$utils.returntimes(this.form.date))
      );
      let nowDate = parseInt(this.$utils.getNowTime()) + 1000000;
      if (nowDate > workDate) {
        this.$alert("工作开始时间至少是当前时间一天后，请修改时间~");
        this.loading = false;
        return false;
      }
      this.$api
        .editJob(data)
        .then((res) => {
          this.loading = false;
          if (!res.success) {
            this.$message.error("修改兼职失败，原因为：" + res.msg);
            return;
          }
          this.$message({
            message: "修改聘信息成功！将为您跳转至首页！",
            type: "success",
          });
          setTimeout(() => {
            this.$router.push("/");
          }, 2000);
        })
        .catch((err) => {
          this.loading = false;
          this.$message.error("兼职修改失败，请重试~");
        });
    },
    // 将兼职状态改为开始兼职
    ingJob() {
      this.$confirm("此操作代表将本兼职状态改为进行中, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }).then(() => {
        this.loading = true;
        this.$api
          .ingJob({
            pid: this.$route.params.id,
          })
          .then((res) => {
            this.loading = false;
            if (!res.success) {
              this.$message.error(
                "兼职信息转为开始状态失败！原因为：" + res.msg
              );
              return;
            }
            this.$message({
              type: "success",
              message: "修改兼职信息状态成功!将为您跳转至首页！",
            });
            setTimeout(() => {
              this.$router.push("/");
            }, 2000);
          })
          .catch((err) => {
            this.loading = false;
            this.$message.error(err);
          });
      });
    },
    // 结束该兼职
    overJob() {
      this.$confirm("此操作代表该兼职关闭, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }).then(() => {
        this.loading = true;
        this.$api
          .overJob({
            pid: this.$route.params.id,
          })
          .then((res) => {
            this.loading = false;
            if (!res.success) {
              this.$message.error(
                "兼职信息转为结束状态失败！原因为：" + res.msg
              );
              return;
            }
            this.$message({
              type: "success",
              message: "修改兼职信息状态成功!将为您跳转至首页！",
            });
            setTimeout(() => {
              this.$router.push("/");
            }, 2000);
          })
          .catch((err) => {
            this.loading = false;
            this.$message.error(err);
          });
      });
    },
    // 删除兼职
    delJob() {
      this.$confirm("此操作将永久删除该兼职, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }).then(() => {
        this.loading = true;
        this.$api
          .delJob({
            pid: this.$route.params.id,
          })
          .then((res) => {
            this.loading = false;
            if (!res.success) {
              this.$message.error("兼职信息删除失败！原因为：" + res.msg);
              return;
            }
            this.$message({
              type: "success",
              message: "删除成功!将为您跳转至首页！",
            });
            setTimeout(() => {
              this.$router.push("/");
            }, 2000);
          })
          .catch((err) => {
            this.loading = false;
            this.$message.error(err);
          });
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
    margin-top: 60px;
    min-height: calc(100vh - 50px);
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
      /deep/.el-dialog__body {
        padding-top: 0;
        height: 250px;
      }
      /deep/.el-scrollbar__wrap {
        overflow-x: hidden;
      }
      ul {
        max-height: 350px;
        overflow-y: auto;
        height: 100%;
        li {
          position: relative;
          padding: 10px 0;
          .face {
            width: 32px;
            height: 32px;
            overflow: hidden;
            display: inline-block;
            border-radius: 50%;
            background-size: cover;
            background-position: 50%;
            background-color: #ddd;
            vertical-align: middle;
            margin-right: 20px;
          }
          .name {
            line-height: 32px;
            vertical-align: middle;
            color: @font-color;
          }
          .el-icon-close {
            position: absolute;
            right: 0;
            top: 16px;
            font-size: 16px;
          }
          .del {
            display: none;
          }
        }
        li:hover {
          background-color: rgb(236, 245, 255);
          .del {
            display: block;
          }
        }
      }

      /deep/.el-input__inner:after {
        content: "*";
        color: red;
        font-size: 14px;
      }
      /deep/.el-button--default {
        width: 200px;
      }
      /deep/.el-form-item__label {
        color: red;
      }
      /deep/.el-textarea__inner {
        height: 200px;
      }
      button {
        width: 100px;
      }
    }
  }
}
</style>