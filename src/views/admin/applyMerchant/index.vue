<template>
  <div class="applyMerchant">
    <!-- 表格 -->
    <div class="merchant_table">
      <el-table :data="applyList.content" border style="width: 100%">
        <el-table-column prop="user.avatar" label="头像" width="70px">
          <template slot-scope="scope">
            <div
              class="imgs"
              :style="{
                backgroundImage:
                  'url(' + scope.row.user.avatar ||
                  require('@/assets/imgs/user.jpg') + ')',
              }"
            ></div>
          </template>
        </el-table-column>
        <el-table-column prop="user.nickName" sortable label="名称">
        </el-table-column>
        <el-table-column prop="createTime" sortable label="申请时间">
        </el-table-column>
        <el-table-column fixed="right" label="操作" width="220">
          <template slot-scope="scope">
            <el-button
              type="success"
              size="small"
              @click="certifyopenBox(scope.row)"
              >查看证明</el-button
            >
            <el-button
              type="success"
              size="small"
              @click="handleApplyOpen(scope.row)"
              >处理</el-button
            >
          </template>
        </el-table-column>
      </el-table>
      <!-- 页码 -->
      <div class="page" v-show="applyList.totalRows > 0">
        <el-pagination
          @current-change="currentChange"
          background
          :hide-on-single-page="false"
          layout="prev, pager, next"
          :total="applyList.totalRows"
        >
        </el-pagination>
      </div>
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
      <!-- 处理申请页面 -->
      <el-dialog
        title="处理申请"
        :visible.sync="applyOpen"
        width="442px"
        height="246px"
        :before-close="handleClose"
      >
        <el-form
          ref="form"
          :model="handleapply"
          label-width="90px"
          class="form"
        >
          <el-form-item label="真实名称：">
            <span> {{ handleapply.realName }} </span>
          </el-form-item>
          <el-form-item label="申请意见：">
            <el-radio-group v-model="handleapply.opinion" size="medium">
              <el-radio border label="true">同意</el-radio>
              <el-radio border label="false">驳回</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="驳回理由：" v-if="handleapply.opinion != 'true'">
            <el-input
              type="textarea"
              maxlength="30"
              show-word-limit
              v-model="handleapply.reason"
              class="textarea"
            ></el-input>
          </el-form-item>
          <el-form-item>
            <el-button class="ban_btn" type="primary" @click="applyOpinion"
              >确定</el-button
            >
            <el-button class="reset_btn" @click="handleClose">取消</el-button>
          </el-form-item>
        </el-form>
      </el-dialog>
    </div>
  </div>
</template>
<script>
export default {
  name: "Apply",
  data() {
    return {
      applyList: {}, //表格中显示的申请列表
      certifyOPen: false,
      certify: {
        //商家证明页面
        idCardFront: "",
        idCardBack: "",
        merchantCertify: "",
      },
      applyOpen: false,
      handleapply: {
        //处理申请页面
        id: "",
        realName: "",
        opinion: "true",
        reason: "",
      },
    };
  },
  mounted() {
    this.setData();
    this.$socket.default.init();
  },
  methods: {
    setData() {
      this.applyAxios({
        pageNumber: 1,
        pageSize: 5,
      });
    },
    // 分页查询商家申请
    applyAxios(data) {
      this.$adminApi
        .getapplyByPage({
          pageNumber: data.pageNumber,
          pageSize: data.pageSize,
        })
        .then((res) => {
          if (!res.success) {
            this.$message.error(res.msg);
            return;
          }
          this.applyList = res.data;
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
    // 查看商家证明
    certifyopenBox(data) {
      this.certifyOPen = true;
      this.certify = {
        realName: data.content.realName,
        idCardFront: data.content.idCardFront,
        idCardBack: data.content.idCardBack,
        merchantCertify: data.content.merchantCertify,
      };
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
    // 打开处理申请页面
    handleApplyOpen(data) {
      Object.assign(this.handleapply, {
        id: data.id,
        realName: data.user.nickName,
        toUser: data.userId,
        opinion: "true",
      });
      this.applyOpen = true;
    },
    // 提交申请处理
    applyOpinion() {
      if (this.handleapply.opinion != "true" && this.handleapply.reason == "") {
        this.$message.error("请填写驳回意见，再提交~");
        return;
      }
      let info = {};
      let message = "同意";
      if (this.handleapply.opinion == "true") {
        info = {
          id: this.handleapply.id,
          opinion: true,
        };
      } else {
        info = {
          id: this.handleapply.id,
          opinion: false,
          reason: this.handleapply.reason,
        };
        message = "驳回";
      }
      this.$adminApi
        .handleApply(info)
        .then((res) => {
          if (!res.success) {
            this.$message.error(res.msg);
            return;
          }
          this.$message({
            message: message + "商家申请处理成功！",
            type: "success",
          });
          // 移除显示在页面上的数据
          this.applyList.content = this.applyList.content.filter(
            (item) => item.userId != this.handleapply.id
          );
          // msg: "管理员已拒绝了您本次的商家申请，原因为===>请重新发起"
          // nickName: "新的用户"
          // opinion: false
          // toUser: "8b54281e-7bff-4c83-ab24-0501d3704189"
          // 使用websocket传信息给用户，驳回信息
          try {
            this.$socket.default.socketsend({
              fromUser: this.$store.state.userData.id, //当前登录用户的id,
              toUser: this.handleapply.toUser, //接收人id
              content: res.data.msg,
            });
          } catch (error) {
            this.$message.error("未连接到websocket");
            console.log(err);
          }
          this.handleClose();
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },

    // 关闭处理申请页面前，将数据清空
    handleClose() {
      this.handleapply = {
        id: "",
        realName: "",
        opinion: true,
        reason: "",
      };
      this.applyOpen = false;
    },
    // 更换页码
    currentChange(num) {
      this.applyAxios({
        pageNumber: num,
        pageSize: 5,
      });
    },
  },
};
</script>
<style scoped lang="less">
.imgs {
  width: 30px;
  height: 30px;
  background-size: cover;
  background-position: 50%;
  background-color: #ddd;
}
/deep/textarea {
  height: 100px;
}
/deep/.el-dialog__body {
  padding: 0 20px 10px 20px;
  .form {
    .textarea {
      height: 100px;
    }
  }
}
.page {
  background-color: #fff;
  text-align: center;
  margin: 10px 0;
}
</style>