<template lang="html">
  <div class="editor">
    <div ref="toolbar" class="toolbar">
    </div>
    <div ref="editor" class="text">
    </div>
  </div>
</template>

<script>
import E from "wangeditor";
export default {
  name: "editoritem",
  data() {
    return {
      // uploadPath,
      editor: null,
      info_: null,
    };
  },
  model: {
    prop: "value",
    event: "change",
  },
  props: {
    value: {
      type: String,
      default: "",
    },
    isdis: {
      type: Boolean,
      default: false,
    },
    isClear: {
      type: Boolean,
      default: false,
    },
  },
  watch: {
    isClear(val) {
      // 触发清除文本域内容
      if (val) {
        this.editor.txt.clear();
        this.info_ = null;
      }
    },
    value: function (value) {
      if (value !== this.editor.txt.html()) {
        this.editor.txt.html(this.value);
      }
    },
    //value为编辑框输入的内容，这里我监听了一下值，当父组件调用得时候，如果给value赋值了，子组件将会显示父组件赋给的值
    isdis(val) {
      this.editor.$textElem.attr("contenteditable", !val);
    },
  },
  mounted() {
    this.seteditor();
    this.editor.txt.html(this.value);
  },
  methods: {
    seteditor() {
      this.editor = new E(this.$refs.toolbar, this.$refs.editor);
      this.editor.config.uploadImgShowBase64 = true; // base 64 存储图片
      this.editor.config.uploadVideoServer =
        process.env.VUE_APP_FOREGROUND + "/open/file/video"; //服务地址  从env从获取
      this.editor.config.uploadVideoParams = {
        authorization: this.$store.state.accessToken,
      }; //用户token-> authorization
      this.editor.config.uploadVideoMaxSize = 200 * 1024 * 1024; //限制最大视频大小为200mb
      this.editor.config.uploadVideoAccept = ["mp4"]; //限制文件类型为mp4
      // 配置菜单
      this.editor.config.menus = [
        "head", // 标题
        "bold", // 粗体
        "fontSize", // 字号
        "italic", // 斜体
        "underline", // 下划线
        "strikeThrough", // 删除线
        "foreColor", // 文字颜色
        "backColor", // 背景颜色
        "link", // 插入链接
        "list", // 列表
        "emoticon", // 表情
        "image", // 插入图片
        "video", //插入视频
        "undo", // 撤销
        "redo", // 重复
        "fullscreen", // 全屏
      ];

      this.editor.config.uploadImgHooks = {
        fail: (xhr, editor, result) => {
          // 插入图片失败回调
        },
        success: (xhr, editor, result) => {
          // 图片上传成功回调
        },
        timeout: (xhr, editor) => {
          // 网络超时的回调
        },
        error: (xhr, editor) => {
          // 图片上传错误的回调
        },
        customInsert: (insertImg, result, editor) => {
          let url = result.url;
          insertImg(url);
        },
      };
      this.editor.config.onchange = (html) => {
        this.info_ = html; // 绑定当前逐渐地值
        this.$emit("change", this.info_); // 将内容同步到父组件中
      };

      // 创建富文本编辑器
      this.editor.create();
      this.editor.$textElem.attr("contenteditable", !this.isdis);
    },
  },
};
</script>

<style lang="css">
.editor {
  width: 100%;
  margin: 0 auto;
  position: relative;
  z-index: 0;
}
.toolbar {
  border: 1px solid #ccc;
}
.text {
  border: 1px solid #ccc;
  min-height: 350px;
}
</style>