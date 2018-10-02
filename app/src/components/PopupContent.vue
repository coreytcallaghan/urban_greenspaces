<template lang="pug">
div
  h3.title Randwick Environment Park
  img.main-popup(src='aus-nsw-randwick_environment_park.png')
</template>

<script>
export default {
  name: 'PopupContent',
  props: {
    data: {
      type: Object,
      default: () => ({ type: '', color: '#ffffff' })
    }
  }
};
</script>
<style>
.main-popup {
  width: 300px;
}
</style>

