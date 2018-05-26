<template lang='pug'>
section.section
  .container.is-size-5
    .content(v-html='README')
</template>

<script>
import { getREADME } from '../components/getGreenspaces'
export default {
  data () {
    return {
      README: ''
    }
  },
  mounted () {
    getREADME().then(resp => {
      this.README = resp.data
    })
      .catch(err => this.README = err.message)
  }
}
</script>
<style>
.octicon.octicon-link {
  display: none
}
</style>
