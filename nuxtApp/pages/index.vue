<template>
  <div id="app">
    <div class="app-container" id="app-container">
      <div class="app-top" id="app-top">
          <div class="user-name">
            测试1
          </div>
          <div class="desc">
            hello 小猿码社
          </div>
          <div class="qrcode">
            <qrcode-vue :value="value" :size="size" level="H"></qrcode-vue>
          </div>
      </div>
    </div>
    <div class="save-btn" @click="saveImage">
      点击保存图片
    </div>
    <div class="created">
      <p>生成的截图：</p>
      <img class="image" :src="saveImageData"/>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import DomToImage from 'dom-to-image'
import * as rasterizeHTML from 'rasterizehtml'
import html2canvas from 'html2canvas'
import QrcodeVue from 'qrcode.vue';
import axios from "~/plugins/axios.js";

export default {
  name: 'App',
  components:{
    QrcodeVue:QrcodeVue
  },
  data(){
    return {
      saveImageData:"",
      value:"刘硕",
      size:100
    }
  },
  methods:{
    saveImage(){
      const image = document.getElementById("test");
      const appContainer = document.getElementById("app-top");
      DomToImage.toJpeg(appContainer)
      .then((res=>{
        console.log(res);
        const image = res;
        this.saveImageData = image;
        this.$bridge.callhandler("jsCallOc",image.replace("data:image/jpeg;base64,",""),(responseData)=>{
          console.log("responseData",responseData);
        })
      })).catch(error=>{
        console.log(error);
      })
    }
  },
  mounted() {
    const bridge = require("~/assets/js/bridge.js");
    // require("~/assets/js/eruda.js");
    Vue.prototype.$bridge = bridge.default;
    this.$bridge.registerhandler('ocCallJs', (data, responseCallback) => {
        alert(data)
        responseCallback(data)
    });
  }
}
</script>

<style lang="scss">
@import "~assets/css/mixin.scss";
.app-container{
  padding: px2rem(60) 0 0 0;
  .app-top {
    text-align: center;
    background: white;
    border-radius: 5px;
    font-size: px2rem(32);
    padding: px2rem(30) 0 px2rem(30) 0;
    .user-name {
      font-size: px2rem(32);
      color: #333;
    }
    .desc {
      font-size: px2rem(26);
      color: #555;
    }
  }
  .qrcode {
    margin-top: px2rem(30);
  }
  .app-bottom{
    margin: 0 px2rem(30);
    background: white;
    border-top: 1px dashed red;
    border-radius: 5px;
  }
}
.save-btn {
  margin: 0 auto;
  margin-top: px2rem(30);
  width: px2rem(240);
  height: px2rem(80);
  line-height:px2rem(80);
  background: yellow;
  border-radius: 2.5px;
  text-align: center;
  font-size: px2rem(32);
}
.created {
  text-align: center;
  .image {
    // margin: 0 px2rem(30);
    width: px2rem(750);
  }
}
</style>
