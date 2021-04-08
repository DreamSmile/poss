<template>
  <div id="toBusiness">
    <div class="bg">
      <div class="content">
        <!-- 左边：固定 -->
        <div class="content_left">
          <img src="../assets/imgs/login/logo.png" />
          <div class="left_box">
            <i class="el-icon-document"></i>
            <div>
              <p class="box_title">沟通</p>
              <p class="box_msg">在线职位及沟通</p>
            </div>
          </div>
          <div class="left_box">
            <i class="el-icon-document"></i>
            <div>
              <p class="box_title">任性选</p>
              <p class="box_msg">各大职位由你选</p>
            </div>
          </div>
        </div>
        <div class="content_right">
          <p class="title">成为商家</p>
          <el-steps :active="active" finish-status="success">
            <el-step @click.native="step(0)"></el-step>
            <el-step @click.native="step(1)"></el-step>
            <el-step @click.native="step(2)"></el-step>
          </el-steps>
          <div class="tabs">
            <div v-show="active == 0">
              <el-form
                label-position="top"
                label-width="80px"
                :model="firstForm"
                ref="firstForm"
                class="demo-dynamic"
              >
                <el-form-item
                  label="真实姓名"
                  prop="name"
                  :rules="[
                    {
                      required: true,
                      message: '请输入真实姓名',
                      trigger: 'blur',
                    },
                    {
                      min: 1,
                      max: 6,
                      message: '长度在 1 到 6 个字符',
                      trigger: 'blur',
                    },
                  ]"
                >
                  <el-input
                    placeholder="请输入您的真实姓名"
                    v-model="firstForm.name"
                    :validate-event="false"
                  ></el-input> </el-form-item
              ></el-form>
            </div>
            <div v-show="active == 1" class="sfz">
              <p class="tab_title">身份证正反面</p>
              <el-upload :before-upload="beforeupload" action="#">
                <div class="upload_demo">
                  <div class="upload_text">点击上传身份证正面</div>
                </div>
              </el-upload>
              <el-upload action="#" :before-upload="beforeupload">
                <div class="upload_demo">
                  <div class="upload_text">点击上传身份证背面</div>
                </div>
              </el-upload>
            </div>
            <div v-show="active == 2" class="sjzm">
              <p class="tab_title">商家证明</p>
              <el-upload action="#" :before-upload="beforeupload">
                <div class="upload_demo">
                  <div class="upload_text">点击上传商家证明</div>
                </div>
              </el-upload>
            </div>
          </div>
          <el-button
            class="btn"
            type="primary"
            v-show="active != 2"
            @click="next"
            >下一步</el-button
          >
          <el-button
            class="btn"
            type="primary"
            v-show="active == 2"
            @click="sub"
            >提交</el-button
          >
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: "ToBusiness",
  data() {
    return {
      active: 0,
      firstForm: {
        name: "",
      },
      secondForm: {},
      fileList: [], //存放要上传文件的数据
      moreFile: new FormData(), //传到接口的文件数据
    };
  },
  methods: {
    next() {
      if (this.active == 0) {
        this.$refs.firstForm.validate((valid) => {
          if (valid) {
            this.active = 1;
          }
        });
      } else if (this.active == 1) {
        this.active++;
      }
    },
    // 点击步骤
    step(num) {
      this.active = num;
    },
    // 上传身份证正面
    beforeupload(file) {
      this.fileList.push({
        file: file,
      });
      return false;
    },
    // 提交商家信息
    sub() {
      if (this.fileList.length < 3) {
        this.$message.error("请上传完整的商家证明！");
        return false;
      }
      if (!this.firstForm.name) {
        this.$message.error("请填写真实姓名！");
        return false;
      }
      this.$api
        .toBusiness({
          idCardBack: this.fileList,
          idCardFront: this.fileList,
          mercahntCertify: this.fileList,
          realName: this.firstForm.name,
        })
        .then((res) => {
          if (!res.success) {
            this.$message.error("文件上传失败！原因为：" + res.msg);
            this.fileList = [];
            this.firstForm.name = "";
            return;
          }
          this.$message({
            message: "商家申请提交成功！",
            type: "success",
          });
          this.$emit("business", true);
        })
        .catch((err) => {
          this.$message.error(err);
        });
    },
  },
};
</script>
<style scoped lang="less">
@import "../assets/css/common.less";
#toBusiness {
  .bg {
    .content {
      background-color: #fff;
      border-radius: 20px;
      padding: 65px;
      box-sizing: border-box;
      display: flex;
      display: -webkit-flex;
      display: -moz-box;
      .content_left {
        width: 290px;
        height: 100%;
        img {
          width: 173.3px;
        }
        .left_box {
          margin: 40px 0;
          .el-icon-document {
            color: #d8d8d8;
            font-size: 18px;
            margin-right: 20px;
            display: inline-block;
            vertical-align: middle;
          }
          div {
            display: inline-block;
            vertical-align: middle;
            .box_title {
              font-size: 20px;
              font-family: Microsoft YaHei;
              font-weight: 400;
              line-height: 35px;
              color: #162343;
            }
            .box_msg {
              font-size: 15px;
              font-family: Microsoft YaHei;
              font-weight: 400;
              line-height: 35px;
              color: #c1ccde;
            }
          }
        }
      }
      .content_right {
        flex: 1;
        position: relative;
        .title {
          font-weight: bold;
          color: @font-color;
          font-size: 17px;
        }
        .el-steps {
          margin: 20px 0;
          /deep/.el-step__icon {
            cursor: pointer;
          }
        }
        .tabs {
          div {
            /deep/.el-form-item__label {
              color: @msg-color;
            }
          }
          .sfz {
            position: relative;
            .tab_title {
              color: @msg-color;
              padding-left: 14px;
              margin-bottom: 14px;
            }
            .tab_title:after {
              content: "*";
              color: red;
              position: absolute;
              left: 0;
              top: 0px;
            }
            div {
              display: inline-block;
              width: 158px;
              text-align: center;
            }
            .upload_demo {
              width: 150px;
              height: 100px;
              border: 1px solid rgba(193, 204, 222, 0.5);
              text-align: center;
              .upload_text {
                color: @msg-color;
                line-height: 100px;
              }
            }
          }
          .sjzm {
            position: relative;
            .tab_title {
              color: @msg-color;
              padding-left: 14px;
              margin-bottom: 14px;
            }
            .tab_title:after {
              content: "*";
              color: red;
              position: absolute;
              left: 0;
              top: 0px;
            }
            div {
              width: 100%;
              /deep/.el-upload {
                display: block;
              }
            }
            .upload_demo {
              height: 100px;
              border: 1px solid rgba(193, 204, 222, 0.5);
              text-align: center;
              .upload_text {
                color: @msg-color;
                line-height: 100px;
              }
            }
          }
        }
        .btn {
          width: 100%;
          position: absolute;
          bottom: 0;
          left: 0;
        }
      }
    }
  }
}
</style>