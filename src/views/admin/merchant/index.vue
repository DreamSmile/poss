<template>
  <div id="merchant">
    <!-- 头部查询 -->
    <div class="search">
      <el-select v-model="select" placeholder="选择学校">
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
      >
      </el-input>
      <el-button
        type="primary"
        slot="append"
        icon="el-icon-search"
        @click="selUser"
        >查询</el-button
      >
    </div>
    <!-- 表格 -->
    <div class="merchant_table">
      <el-table :data="merChantList" border style="width: 100%">
        <el-table-column prop="id" label="id"> </el-table-column>
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
              :type="scope.row.role === 'merchant' ? 'success' : 'primary'"
              disable-transitions
              >{{ scope.row.role === "merchant" ? "商家" : "普通用户" }}</el-tag
            >
          </template>
        </el-table-column>
        <el-table-column prop="status" sortable label="状态">
          <template slot-scope="scope">
            <el-tag
              :type="scope.row.status ? 'succes' : 'danger'"
              disable-transitions
              >{{ scope.row.status ? "正常" : "已注销" }}</el-tag
            >
          </template>
        </el-table-column>
        <el-table-column fixed="right" label="操作" width="220">
          <template slot-scope="scope">
            <el-button @click="lookByUser(scope.row)" type="button" size="small"
              >详情</el-button
            >
            <el-button
              type="success"
              size="small"
              @click="certifyopenBox(scope.row)"
              >证明</el-button
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
      <!-- 查看用户 -->
      <el-dialog
        title="用户详情"
        :visible.sync="dialogVisible"
        width="500px"
        height="500px"
      >
        <admin-userinfo :userData="userData"></admin-userinfo>
      </el-dialog>
      <!-- 查看商家证明 -->
      <el-dialog
      top="40vh"
        :title="'商家证明 (' + certify.realName + ')'"
        :visible.sync="certifyOPen"
        width="450px"
      >
        <div class="certify">
          <el-button
            type="primary"
            icon="el-icon-postcard"
            plain
            @click="lookFile(certify.idCardFront)"
            >身份证正面</el-button
          >
          <el-button
            type="primary"
            icon="el-icon-postcard"
            plain
            @click="lookFile(certify.idCardBack)"
            >身份证背面</el-button
          >
          <el-button
            type="success"
            icon="el-icon-tickets"
            plain
            @click="lookFile(certify.merchantCertify)"
            >商家证明</el-button
          >
        </div>
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
import adminUserinfo from "../../../components/admin/adminUserinfo.vue";
export default {
  components: { adminUserinfo },
  name: "Merchant",
  data() {
    return {
      merChantList: [], //商家列表
      banOpen: false,
      dialogVisible: false,
      certifyOPen: false,
      certify: {
        idCardFront: "",
        idCardBack: "",
        merchantCertify: "",
      },
      userName: "",
      select: "",
      userData: {}, //传给组件的数据
      ban: {
        duration: "oneday",
        id: "",
        nickName: "",
      },
      schoolList: [],
    };
  },
  mounted() {
    this.getSchoolList();

    this.merchantAxios({
      campus: "",
      keyword: "",
      pageNumber: 1,
    });
  },
  methods: {
    // 商家列表axios
    merchantAxios(data) {
      this.$adminApi
        .getMerchantByPage({
          campus: data.campus,
          keyword: data.keyword,
          paginationInfo: {
            order: {
              direction: "asc",
              property: "nickName",
            },
            pageNumber: data.pageNumber,
            pageSize: 5,
          },
        })
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.$message.error(res.msg);
            return;
          }
          this.merChantList = res.data.content;
        });
    },
    // 根据学校和用户名称查询信息
    selUser() {
      this.merchantAxios({
        campus: this.select,
        keyword: this.userName,
        pageNumber: 1,
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
    // 查看商家证明
    certifyopenBox(data) {
      this.$adminApi
        .getCertifyById({
          mercahntId: data.id,
        })
        .then((res) => {
          console.log(res);
          if (!res.success) {
            this.$message.error(res.msg);
            return;
          }
          this.certifyOPen = true;
          this.certify = {
            realName: res.data.realName,
            idCardFront: res.data.idCardFront,
            idCardBack: res.data.idCardBack,
            merchantCertify: res.data.merchantCertify,
          };
        });
    },
    // 查看文件
    lookFile(url) {
      let deUrl = decodeURIComponent(url);
      let Base64 = require("js-base64").Base64;
      window.open(
        "http://www.yggdrasill.vip:8012/onlinePreview?url=" +
          encodeURIComponent(Base64.encode(deUrl))
      );
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
                for (let j = 0; j < this.merChantList.length; j++) {
                  //将对应数据按钮变为封禁
                  if (this.merChantList[j].id == data.id) {
                    this.merChantList[j].isBanned = false;
                  }
                }
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
              if (!res.success) {
                this.$message.error(res.msg);
                return;
              }
              this.$message({
                message: "封禁成功",
                type: "success",
              });
              this.banOpen = false;
              for (let j = 0; j < this.merChantList.length; j++) {
                //将对应数据按钮变为解封
                if (this.merChantList[j].id == this.ban.id) {
                  this.merChantList[j].isBanned = true;
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
  },
};
</script>
<style scoped lang="less">
/deep/.el-dialog__body {
  padding-top: 0;
}
.search {
  margin-bottom: 20px;
  box-sizing: border-box;
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