<template lang='pug'>
#app
  my-header
  router-view

</template>

<script>
import Header from '@/components/Header'
export default {
  components: { 'my-header': Header }
}
</script>
<style>
</style>
