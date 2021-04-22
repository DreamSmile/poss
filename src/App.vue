<template>
  <div id="app">
    <router-view />
  </div>
</template>
<script>
// import { addAdminRouter } from "@/router/index.js";
export default {
  name: "App",
  created() {
    // addAdminRouter(); //动态路由
  },
};
</script>

<style lang="less">
#app {
  font-family: Microsoft YaHei, Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  font-weight: 400;
}
</style>
