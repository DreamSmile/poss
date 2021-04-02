<template>
  <div id="student">
    <div class="student_base">
      <div class="imgs">
        <router-link to="/userData">
          <img src="@/assets/imgs/user.jpg" />
        </router-link>
        <p>张三</p>
      </div>
      <div class="student_data">
        <div class="rows">
          <span>参与过的兼职记录</span>
          <div>32<i class="el-icon-arrow-right"></i></div>
        </div>
        <div class="rows">
          <span>发布过的兼职记录</span>
          <div>32<i class="el-icon-arrow-right"></i></div>
        </div>
      </div>
    </div>
    <div class="work_list">
      <p class="list_title">正在进行中的兼职列表</p>
      <ul v-for="i in 5" :key="i">
        <li>
          1、
          <p class="list_data">悸动打范文芳起码</p>
          <span class="list_time">2021.04.22</span>
        </li>
      </ul>
    </div>
  </div>
</template>
<style scoped lang="less">
@import "../../assets/css/common.less";
#student {
  margin-top: 20px;
  color: @font-color;
  .student_base {
    height: 223px;
    background-color: #fff;
    .imgs {
      padding: 21px 0;
      text-align: center;
      margin-bottom: 10px;
      img {
        border-radius: 50%;
        width: 60px;
        height: 60px;
        display: inline-block;
        cursor: pointer;
      }
      p {
        margin-top: 10px;
      }
    }
    .student_data {
      .rows {
        cursor: pointer;
        position: relative;
        margin-bottom: 22px;
        span {
          padding-left: 25px;
        }
        div {
          position: absolute;
          top: 0;
          right: 24px;
        }
      }
    }
  }
  .work_list {
    background-color: #fff;
    min-height: 410px;
    margin-top: 20px;
    padding: 18px 23px;
    .list_title {
    }
    ul {
      li {
        position: relative;
        //   height:40px;
        margin: 20px 0;
        .list_data {
          width: 5em;
          white-space: nowrap;
          text-overflow: ellipsis;
          overflow: hidden;
          display: inline-block;
        }
        .list_time {
          position: absolute;
          right: 3px;
        }
      }
    }
  }
}
</style>