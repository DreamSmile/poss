<template>
  <div id="admin">
    <el-container class="content" ref="content">
      <!-- 顶部用户登录信息 -->
      <el-header class="header">
        <span class="title">兼职无忧后台管理</span>
        <div class="top_right">
          <router-link to="/">前台</router-link>
          <span
            v-if="$store.state.accessToken"
            :class="$store.state.diaData.length > 0 ? 'hasDia' : ''"
            ><router-link
              :to="{
                name: 'Dialogue',
                params: { id: 'topF' },
              }"
              ><i class="el-icon-bell"></i>消息</router-link
            ></span
          >
          <router-link to="/userData">
            <span class="user_name" v-if="$store.state.accessToken">{{
              $store.state.userData.nickName || ""
            }}</span>
            <el-dropdown v-if="$store.state.accessToken">
              <div
                v-if="$store.state.accessToken"
                class="imgs"
                :style="{
                  backgroundImage:
                    'url(' + this.$store.state.userData.avatar ||
                    require('@/assets/imgs/user.jpg') + ')',
                }"
              ></div>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item @click.native="signOut"
                  >退出</el-dropdown-item
                >
              </el-dropdown-menu>
            </el-dropdown>
          </router-link>
        </div>
      </el-header>
      <!-- 主体内容 -->
      <el-container class="main">
        <!-- 左侧导航栏 -->
        <el-aside width="250px" class="aside">
          <el-scrollbar wrap-style="overflow-x:hidden;height:100%；width:100%">
            <el-menu
              :default-active="this.$route.name"
              class="el-menu-vertical-demo aside_menu"
              background-color="#373c4c"
              text-color="#fff"
              router
            >
              <!-- 首页 -->
              <el-menu-item index="HomePage"
                ><i class="el-icon-document"></i>首页</el-menu-item
              >
              <!-- 用户管理 -->
              <el-menu-item index="UserIndex"
                ><i class="el-icon-document"></i>用户管理</el-menu-item
              >
              <!-- 商家管理 -->
              <el-menu-item index="MerchantIndex"
                ><i class="el-icon-document"></i>商家管理</el-menu-item
              >
              <!-- 商家申请 -->
              <el-menu-item index="ApplyMerchantIndex"
                ><i class="el-icon-document"></i>商家申请</el-menu-item
              >
              <!-- 学校管理 -->
              <el-menu-item index="SchoolIndex"
                ><i class="el-icon-document"></i>学校管理</el-menu-item
              >
              <!-- 举报管理 -->
              <el-menu-item index="ReportIndex"
                ><i class="el-icon-document"></i>举报管理</el-menu-item
              >
            </el-menu>
          </el-scrollbar>
        </el-aside>

        <!-- 主体 -->
        <el-main><router-view></router-view></el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script>
export default {
  name: "Admin",
  data() {
    return {
      adminName: "用户名称",
      nowDate: "现在时间",
    };
  },
  mounted() {
    this.getAdminData();
  },
  methods: {
    // 获取登录人员信息
    getAdminData() {},
    // 退出
    signOut() {
      this.$confirm("是否退出当前账号?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          this.$api
            .logout()
            .then((res) => {
              if (!res.success) {
                $alert("退出账号失败，原因为：" + res.msg);
                return;
              }
              this.$store.commit("clearAll");
              try {
                //使用trycatch 是因为如果在home页面退出，控制台会报错重复跳转路由
                this.$router.push("/");
              } catch (error) {}
              this.$socket.default.onClose();
            })
            .catch((err) => {
              console.log(err);
            });
        })
        .catch((err) => {});
    },
  },
};
</script>
<style scoped lang="less">
#admin {
  height: 100%;
  min-width: 1024px;
  background-color: #f3f4f8;
  .content {
    height: 100vh;
    .header {
      padding-left: 0;
      background-color: #333951ff;
      position: relative;

      .title {
        color: #fff;
        display: inline-block;
        font-size: 24px;
        font-weight: bold;
        width: 250px;
        text-align: center;
        line-height: 60px;
      }
      .top_right {
        display: inline-block;
        position: absolute;
        right: 10px;
        height: 60px;
        .el-icon-bell{
          margin-right:6px;
          font-size: 16px;
        }
        
        a {
          margin-left: 20px;
          line-height: 60px;
          color: #fff;
          text-decoration: none;
        }
        .user_name {
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          display: inline-block;
          vertical-align: middle;
          line-height: 60px;
        }
        .user_name:hover {
          color: #fff;
        }
        .imgs {
          width: 26px;
          height: 26px;
          border-radius: 50%;
          display: inline-block;
          margin-left: 14px;
          vertical-align: middle;
          background-size: cover;
          background-position: 50%;
          background-color: #ddd;
        }
      }
    }

    .main {
      height: calc(100% - 60px);
      ::v-deep.el-scrollbar__view {
        height: 100%;
        ul {
          height: 100%;
        }
      }
      ::v-deep.el-scrollbar {
        height: 100%;
      }
    }
  }
}
</style>
