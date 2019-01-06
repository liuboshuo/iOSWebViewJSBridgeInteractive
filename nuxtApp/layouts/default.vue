<template>
  <div class="layout">
    <nuxt/>
  </div>
</template>

<style lang="scss">

@import "~assets/css/mixin.scss";

html , body {
  margin: 0;
  padding: 0;
  background: #800080;
}
.layout {
  width: px2rem(750);
  min-width: px2rem(750);
  max-width: px2rem(750);
  margin: 0 auto;
}
</style>
