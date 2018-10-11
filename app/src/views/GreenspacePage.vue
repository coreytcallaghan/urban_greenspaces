<template lang='pug'>
div.container
  section.hero
    .hero-body
      nav.level
        
        .title {{name}}
        .level-item.has-text-centered
          div
            p.heading Checklists
            p.title {{ totalLists }}
        .level-item.has-text-centered
          div
            p.heading Species
            p.title  {{ speciesAll }}
        .level-item.has-text-centered
          div
            p.heading Species 95
            p.title  {{ species95 }}
  .columns
    .column.is-third
      .box
        l-map.my-map(
          :center='center',
          :zoom='zoom',
          style="height: 400px;"
          ref="map")
          l-tile-layer(:url="url", :attribution="attribution")
          l-geo-json(:geojson='geojson', v-if="geojson !== ''")
    .column.is-third(v-show='!enoughLists')
      .box
        .title Insufficient data
    .column.is-third(v-show='enoughLists')
      .box
        img.image.accum(:src='accum')
    .column.is-third(v-show='enoughLists')
      .box
        img.image.accum(:src='listsTime')
  .columns
    .column.is-half
      .box.content(v-html="methods")
    .column.is-half(v-show='enoughLists')
      .box
        table.table.is-fullwidth(v-if='enoughLists')
          thead
            tr
              th Rank
              th Species
              th Reporting rate (%)
          tbody
            tr(v-for="(sp, rank) in species", :key='rank')
              td {{rank + 1}}
              td {{sp.Species}}
              td {{sp['Reporting rate (%)']}}
</template>

<script>
import Vue from 'vue'
import { LMap, LTileLayer, LGeoJson, LMarker } from 'vue2-leaflet'
import { getGeoJson, getSpecies, getMethods, getMetadata } from '../components/getGreenspaces'
import map from './../components/mapOpts'
import center from '@turf/center'
import snarkdown from 'snarkdown'
// import  from './'
export default {
  components: { LMap, LTileLayer, LMarker, LGeoJson },
  data () {
    return {
      id: '',
      url: map.url,
      geojson: '',
      center: [0, 0],
      zoom: 14,
      attribution: map.attribution,
      name: '',
      state: '',
      country: '',
      accum: '',
      listsTime: '',
      species: [],
      methods: '',
      totalLists: null,
      speciesAll: null,
      species95: null,
      enoughLists: false,
      error: false
    }
  },
  mounted () {
    this.id = this.$route.params.id
    getGeoJson(this.id).then(data => {
      this.geojson = data
      this.center = center(data).geometry.coordinates.reverse()
    })
    var split = this.id.split('-')
    this.name = split[2].split('_').map(x => x[0].toLocaleUpperCase() + x.substring(1, x.length))
      .join(' ')
    this.country = split[0].toLocaleUpperCase()
    this.state = split[1].toLocaleUpperCase()
    this.accum = `https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/greenspaces/${this.id}/accum_curves-${this.id}.png`
    this.listsTime = `https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/greenspaces/${this.id}/lists_time-${this.id}.png`
    getMetadata(this.id).then(resp => {
      console.log(resp.data)
      this.totalLists = resp.data[0].lists_total
      this.enoughLists = resp.data[0].enough_lists
      this.species95 = resp.data[0].species_95
      this.speciesAll = resp.data[0].species_all
    })
    getSpecies(this.id).then(resp => {
      this.species = resp.data
    }).catch(err => {
      this.error = true
    })
    getMethods().then(resp => {
      this.methods = snarkdown(resp.data)
    }).catch(err => {
      this.methods = err.message
      this.error = true
    })
  }
}
</script>

<style>
.accum {
  height: 400px;
}
</style>
