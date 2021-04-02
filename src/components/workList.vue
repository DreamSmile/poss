<template>
  <div id="workList">
    <div class="list" v-show="jobList.length > 0">
      <ul>
        <li v-for="(item, index) in jobList" :key="index">
          <router-link :to="{ name: 'Job', params: { id: item.id } }">
            <div>
              <span class="work_NO">{{ index + 1 }}、</span>
              <div class="list_base">
                <span class="work_name">{{ item.title }}</span
                ><span class="work_place">[{{ item.workplace }}]</span>
                <span class="work_master">发布者：陈先生</span>
                <span class="work_say"
                  ><i class="el-icon-chat-dot-round"></i>立即沟通</span
                >
              </div>
              <div class="list_secondary">
                <span class="work_money">{{ item.hourlyWage }}/小时</span>
                <span class="work_time">工作时间：{{ item.duration }}小时</span>
                <div class="work_state">
                  已报名：<span>{{ item.participantNumber }}</span
                  >/{{ item.limit }}
                </div>
              </div>
              <img src="@/assets/imgs/no.png" />
            </div>
          </router-link>
        </li>
      </ul>
    </div>
    <div class="page" v-show="jobList.length > 10">
      <el-pagination background layout="prev, pager, next" :total="10">
      </el-pagination>
    </div>
    <div class="noList" v-show="jobList.length < 1">
      <i class="el-icon-document-delete"></i>暂时没有数据~
    </div>
  </div>
</template>
<script>
export default {
  name: "workList",
  data() {
    return {};
  },
  props: {
    jobList: {
      type: Array,
      default: () => [],
    },
  },
  mounted() {
  },
};
</script>
<style scoped lang="less">
@import "../assets/css/common.less";
#workList {
  .list {
    ul {
      li {
        padding: 13px 37px;
        box-sizing: border-box;
        height: 80px;
        background-color: #fff;
        position: relative;
        margin: 10px 0;
        a {
          text-decoration: none;
        }
        .work_NO {
          position: absolute;
          top: 19px;
          left: 9px;
          color: @base-color;
        }
        .list_base {
          display: inline-block;
          .work_name,
          .work_place,
          .work_say {
            color: @base-color;
            font-size: 14px;
            font-weight: 400;
            line-height: 32px;
            .el-icon-chat-dot-round {
              margin-right: 3px;
            }
          }
          .work_master {
            color: @msg-color;
            margin: 0 30px;
          }
        }
        .list_secondary {
          .work_money,
          .work_time {
            color: #f95500;
          }
          .work_state {
            display: inline-block;
            position: absolute;
            color: @msg-color;
            right: 0;
            span {
              color: @base-color;
            }
          }
        }
        img {
          position: absolute;
          top: 0;
          right: 0;
          width: 39px;
          height: 39px;
        }
      }
    }
  }
  .page {
    margin-bottom: 50px;
    text-align: center;
    width: 100%;
    background-color: #fff;
    ::v-deep {
      .el-pagination.is-background .el-pager li:not(.disabled) {
        background-color: #fff; // 进行修改未选中背景和字体
      }
      .el-pagination.is-background .el-pager li:not(.disabled).active {
        background-color: @base-color; // 进行修改选中项背景和字体
        color: #fff;
      }
      .btn-next,
      .btn-prev {
        background-color: #fff;
      }
    }
  }
  .noList {
    text-align: center;
    color: @msg-color;
  }
}
</style>
