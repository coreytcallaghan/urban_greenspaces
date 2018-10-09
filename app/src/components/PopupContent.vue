<template lang="pug">
div
  h3.title {{ name }}
  img.main-popup(src='aus-nsw-randwick_environment_park.png')
</template>

<script>
export default {
  name: 'PopupContent',
  props: ['name']
};
</script>
<style>
.main-popup {
  width: 300px;
}
</style>

