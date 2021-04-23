<template>
  <div id="user">
    <div class="search">
      <el-select v-model="select" placeholder="选择学校" size="mini">
        <el-option label="全部学校" value=""></el-option>
        <el-option
          :label="item.name"
          :value="item.name"
          :sId="item.id"
          :sType="item.type"
          v-for="(item, i) in schoolList"
          :key="i"
        ></el-option>
      </el-select>
      <el-input
        placeholder="请输入用户名称"
        v-model="userName"
        autocomplete="off"
        size="mini"
      >
      </el-input>
      <el-button
        type="primary"
        slot="append"
        icon="el-icon-search"
        size="mini"
        @click="selUser"
        >查询</el-button
      >
    </div>
    <!-- 表格 -->
    <div class="user_table">
      <el-table :data="userList" border style="width: 100%">
        <el-table-column prop="avatar" label="头像" width="70px">
          <template slot-scope="scope">
            <div
              class="imgs"
              :style="{
                backgroundImage:
                  'url(' + scope.row.avatar ||
                  require('@/assets/imgs/user.jpg') + ')',
              }"
            ></div>
          </template>
        </el-table-column>
        <el-table-column prop="nickName" sortable label="名称">
        </el-table-column>
        <el-table-column prop="campus" sortable label="学校">
          <template slot-scope="scope">
            {{ scope.row.campus || "未知" }}
          </template>
        </el-table-column>
        <el-table-column prop="role" sortable label="权限">
          <template slot-scope="scope">
            <el-tag
              :type="scope.row.role === '普通用户' ? 'primary' : 'success'"
              disable-transitions
              >{{ scope.row.role }}</el-tag
            >
          </template>
        </el-table-column>
        <el-table-column prop="status" sortable label="状态">
          <template slot-scope="scope">
            <el-tag
              :type="scope.row.isBanned ? 'danger' : 'succes'"
              disable-transitions
              >{{ scope.row.isBanned ? "封禁中" : "正常" }}</el-tag
            >
          </template>
        </el-table-column>
        <el-table-column fixed="right" label="操作" width="150">
          <template slot-scope="scope">
            <el-button @click="lookByUser(scope.row)" type="button" size="small"
              >查看</el-button
            >
            <el-button
              :type="scope.row.isBanned ? 'warning' : 'danger'"
              @click="setUserStatus(scope.row)"
              size="small"
              >{{ scope.row.isBanned ? "解封" : "封禁" }}</el-button
            >
          </template>
        </el-table-column>
      </el-table>
      <!-- 页码 -->
      <div class="page">
        <el-pagination
          @current-change="currentChange"
          background
          :hide-on-single-page="true"
          layout="prev, pager, next"
          :total="userList.totalRows"
        >
        </el-pagination>
      </div>
      <!-- 查看用户 -->
      <el-dialog
        title="用户详情"
        :visible.sync="dialogVisible"
        width="500px"
        height="500px"
      >
        <admin-userinfo :userData="userData"></admin-userinfo>
      </el-dialog>
      <!-- 封禁用户界面 -->
      <el-dialog
        title="封禁用户"
        :visible.sync="banOpen"
        width="442px"
        height="246px"
      >
        <el-form ref="form" :model="ban" label-width="90px" class="form">
          <el-form-item label="用户名称：">
            <span> {{ ban.nickName }} </span>
          </el-form-item>
          <el-form-item label="封号时长：">
            <el-select v-model="ban.duration" placeholder="请选择封号时长">
              <el-option label="一天" value="oneday"></el-option>
              <el-option label="一周" value="sevenday"></el-option>
              <el-option label="一月" value="onemonth"></el-option>
            </el-select>
          </el-form-item>
          <el-button class="ban_btn" type="primary" @click="banUser"
            >确定</el-button
          >
        </el-form>
      </el-dialog>
    </div>
  </div>
</template>
<script>
import adminUserinfo from "../../../components/admin/adminUserinfo";

export default {
  components: { adminUserinfo },
  name: "user",
  data() {
    return {
      select: "", //查询学校名称
      schoolList: [],
      userName: "", //查询名称
      userList: [],
      dialogVisible: false,
      userData: {}, //传给子组件的用户详情
      banUserId: "", //要传入弹出层的封禁用户id
      banOpen: false,
      ban: {
        duration: "oneday",
        id: "",
        nickName: "",
      },
    };
  },
  mounted() {
    this.getUserList();
    this.getSchoolList();
  },
  methods: {
    // 获取用户列表
    getUserList() {
      this.getUserAxios({
        campus: "",
        keyword: "",
        pageNumber: 1,
        pageSize: 5,
      });
    },
    // 根据学校和用户名称查询信息
    selUser() {
      this.getUserAxios({
        campus: this.select,
        keyword: this.userName,
        pageNumber: 1,
        pageSize: 5,
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
        })
        .catch((err) => {
          this.$message.error("获取学校列表失败！" + err);
        });
    },
    // 根据传入信息，获取用户axios
    getUserAxios(data) {
      this.$adminApi
        .getUserByPage({
          campus: data.campus,
          keyword: data.keyword,
          paginationInfo: {
            order: {
              direction: "asc",
              property: "nickName",
            },
            pageNumber: data.pageNumber,
            pageSize: data.pageSize,
          },
        })
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.$messge.error(res.msg);
            return;
          }
          let editUserList = res.data.content;
          for (let i = 0; i < editUserList.length; i++) {
            if (editUserList[i].role == "user") {
              editUserList[i].role = "普通用户";
            } else if (editUserList[i].role == "merchant") {
              editUserList[i].role = "商家";
            } else if (editUserList[i].role == "admin") {
              editUserList[i].role = "管理员";
            } else {
              editUserList[i].role = "未知";
            }
          }
          this.userList = editUserList;
        })
        .catch((err) => {
          this.$messge.error(err);
        });
    },
    // 查看用户详情
    lookByUser(data) {
      this.$adminApi
        .getUserInfoById({
          userId: data.id,
        })
        .then((res) => {
          if (!res.success) {
            this.$message.error(res.msg);
            return;
          }
          this.userData = res.data;
          Object.assign(this.userData, { loading: false });
          this.dialogVisible = true;
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    // 根据用户状态封号或者解封
    setUserStatus(data) {
      if (data.isBanned) {
        //已经是被封禁用户，点击解禁
        this.$confirm("是否要解封该用户？", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning",
        })
          .then(() => {
            this.$adminApi
              .unsealUser({
                id: data.id,
              })
              .then((res) => {
                if (!res.success) {
                  this.$message.error(res.msg);
                  return;
                }
                this.$message({
                  message: "解除封禁成功",
                  type: "success",
                });
                for (let j = 0; j < this.userList.length; j++) {
                  //将对应数据按钮变为封禁
                  if (this.userList[j].id == data.id) {
                    this.userList[j].isBanned = false;
                  }
                }
                console.log(this.userList);
              })
              .catch((err) => {
                this.$message.error(err);
              });
          })
          .catch((err) => {});
      } else {
        this.banUserId = data.id;
        this.ban.nickName = data.nickName;
        this.ban.id = data.id;
        this.banOpen = true;
      }
    },
    // 封禁用户
    banUser() {
      this.$confirm("是否要封禁该用户？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          this.$adminApi
            .banUser({
              duration: this.ban.duration,
              userId: this.ban.id,
            })
            .then((res) => {
              console.log(res);
              if (!res.success) {
                this.$message.error(res.msg);
                retur;
              }
              this.$message({
                message: "封禁成功",
                type: "success",
              });
              this.banOpen = false;
              for (let j = 0; j < this.userList.length; j++) {
                //将对应数据按钮变为解封
                if (this.userList[j].id == this.ban.id) {
                  this.userList[j].isBanned = true;
                }
              }
              this.ban.duration = "oneday"; //重新将数据设置为默认一天
              this.ban.id = "";
            })
            .catch((err) => {
              this.$message.error(err);
            });
        })
        .catch((err) => {});
    },
    // 点击换页
    currentChange(num) {
      this.getUserAxios({
        campus: this.select,
        keyword: this.userName,
        pageNumber: num,
        pageSize: 5,
      });
    },
  },
};
</script>
<style scoped lang="less">
@import "../../../assets/css/common.less";
/deep/.el-dialog__body {
  padding-top: 0;
}
.imgs {
  width: 30px;
  height: 30px;
  background-size: cover;
  background-position: 50%;
  background-color: #ddd;
}
.search {
  margin-bottom: 10px;
  box-sizing: border-box;
  background-color: #fff;
  padding: 10px;
  /deep/.el-select {
    /deep/.el-input {
      width: 180px;
    }
  }
  /deep/.el-input {
    width: 194px;
    display: inline-block;
    margin-right: 20px;
  }
}

.form {
  height: 168px;
  .ban_btn {
    position: absolute;
    right: 26px;
  }
}
</style>