<template>
  <div id="userData">
    <top message="基本信息"></top>
    <div class="content">
      <el-container>
        <el-aside width="200px"
          ><ul>
            <li><router-link to="/userBase">基本信息</router-link></li>
            <li>
              <router-link to="/userJoin">参加过的兼职</router-link>
            </li>
            <li>
              <router-link to="/userRelease">发布过的兼职</router-link>
            </li>
          </ul></el-aside
        >
        <el-main><router-view></router-view></el-main>
      </el-container>
    </div>
  </div>
</template>
<script>
export default {
  data(){
    return{
      userData:{}
    }
  },
  mounted(){
    //  v-if="$store.userData.role=='merchant'"
    this.userData=$store.userData;
    console.log('这是用户信息');
    console.log(this.userData);
  }
}
</script>
<style scoped lang="less">
@import "../../assets/css/common.less";


#userData {
  .content {
    width: 80%;
    min-width: 900px;
    margin: 0 auto;
    margin-top: 50px;
    box-sizing: border-box;
    display: flex;
    .el-container {
      ul {
        margin: 20px;
        li {
          height: 50px;
          a {
            color: @user-color;
            text-decoration: none;
            font-size: 16px;
            font-weight: 400;
          }
          /deep/.router-link-exact-active,
          .router-link-active {
            color: @base-color;
          }
        }
      }
    }
  }
}
</style>
<script>
import top from "../../components/top";
export default {
  name: "userData",
  components: {
    top,
  },
};
</script>