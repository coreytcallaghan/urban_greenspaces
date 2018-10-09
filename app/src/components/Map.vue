<template lang="pug">
div
  .container
    l-map.my-map(
      style="height: 500px;"
      ref="map",
      :zoom="zoom",
      :center="center")
      l-tile-layer(:url="url", :attribution="attribution")
      l-marker(:lat-lng='[g.properties.lat,g.properties.lon]' v-for='(g, i) in greenspaces' :key='i' )
        l-popup
          router-link(:to="{ name: 'greenspacePage', params: { id: g.properties.id}}") {{ g.properties.name}}
    
  section.section.container
    nav.level(v-if='statistics')
      .level-item.has-text-centered
        div
          p.heading Greenspaces
          p.title {{statistics.count}}
      .level-item.has-text-centered
        div(v-if='search')
          p.heading Matches
          p.title {{results.length}}
      .level-item.has-text-centered
        div
          p.heading Countries
          p.title {{statistics.numCountries}}
    .field
      .control.has-icons-left
        input.input.is-rounded.is-medium(placeholder='Search Greenspaces',
            v-model='search'
            @keyup.enter='searchFun(true)')
        span.icon.is-left
          i.fas.fa-search
      .help {{ this.status}}
    table.table.is-fullwidth.is-bordered
      thead
        tr
          //th
          th Country
          th State/Province
          th Name
          th GeoJson Download Link
          th
          th
      tbody
        tr(v-for='(g, i) in this.results' ,:key='g.id')
          td {{g.country}}
          td {{g.state}}
          td {{g.name}}
          td 
            a(:href="g.download" target="_blank") Download Link
          td 
            a.button(:class="{'is-info':g.displayed}" @click='toggleVis(g.index)')
              div(v-if='g.displayed') Remove from map
              div(v-else) Add to map
          td
            a.button(v-if="g.center" @click='setCenter(g.center)') Center 

</template>

<script>
import Vue from 'vue'
import { LMap, LTileLayer, LPopup, LMarker } from 'vue2-leaflet'
import axios from 'axios'
import { _ } from 'vue-underscore'
import center from '@turf/center'
import PopupContent from './PopupContent'
import { greenspaces, getGeoJson } from './getGreenspaces'
import map from './mapOpts'
export default {
  components: { LMap, LTileLayer, LMarker, PopupContent, LPopup },
  data () {
    return {
      center: [-33.86, 151.209],
      zoom: 13,
      url: map.url,
      attribution: map.attribution,
      greenspaces: [],
      results: [],
      statistics: {},
      status: 'Try searching $add state:NSW then press enter to execute, $reset removes all greenspaces.',
      search: ''
    }
  },
  methods: {
    calcStats () {
      this.statistics = {
        count: this.greenspaces.length,
        // numCountries: _.uniq(this.greenspaces.map(x => x.country)).length
      }
    },
    setCenter (center) {
      this.$refs.map.setCenter(center, this.zoom)
    },
    toggleVis (index, reload = true) {
    },
    searchFun (go = false) {
    }
  },
  watch: {
    search: _.debounce(function () { this.searchFun(false) }, 100)
  },
  mounted () {
    var me = this
    greenspaces().then(ft => me.greenspaces = ft.features)

  }
}
</script>
<style>
@import "../../node_modules/leaflet/dist/leaflet.css";
.my-map {
  height: 400px;
  width: 100%;
}
</style>
