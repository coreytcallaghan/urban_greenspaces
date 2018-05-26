<template lang="pug">
div
  l-map.my-map(
    style="height: 600px;"
    ref="map",
    :zoom=13,
    :center="center")
    l-tile-layer(:url="url", :attribution="attribution")
    l-geo-json(:geojson='g' :key="i" v-for="(g, i) in geojsons")
  
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
        input.input.is-rounded.is-large(placeholder='Search Greenspaces',
            v-model='search')
        span.icon.is-left
          i.fas.fa-search
    .container
      table.table.is-fullwidth.has-text-centered
        thead
          tr
            th Country
            th State/Province
            th Name
            th GeoJson Download Link
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
              


</template>

<script>
import Vue from 'vue'
import { LMap, LTileLayer, LGeoJson } from 'vue2-leaflet'
import axios from 'axios'
import { _ } from 'vue-underscore'
import center from '@turf/center'
import { greenspaces, getGeoJson } from './getGreenspaces'
export default {
  components: { LMap, LTileLayer, LGeoJson },
  data () {
    return {
      center: [-33.95, 151.2],
      url: 'http://{s}.tile.osm.org/{z}/{x}/{y}.png',
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
      greenspaces: [],
      results: [],
      statistics: {},
      geojsons: [],
      search: ''
    }
  },
  methods: {
    refreshGeojsons () {
      if (this.greenspaces) {
        this.geojsons = _.filter(this.greenspaces, g => g.displayed)
          .map(g => g.geojson)
      } else {
        this.geojsons = []
      }
    },
    calcStats () {
      this.statistics = {
        count: this.greenspaces.length,
        numCountries: _.uniq(this.greenspaces.map(x => x.country)).length
      }
    },
    toggleVis (index, reload = true) {
      var greenspace = this.greenspaces[index]
      if (!greenspace.displayed && !greenspace.geojson) {
        getGeoJson(greenspace.download).then(data => {
          greenspace.geojson = data
          greenspace.displayed = !greenspace.displayed
          var c = center(data).geometry.coordinates
          // leaflet center wants lat lng geojson is lng lat
          greenspace.center = [c[1], c[0]]
          if (greenspace.displayed && reload) this.center = greenspace.center
          if (reload) this.refreshGeojsons()
        })
      } else {
        if (greenspace.displayed && reload) this.center = greenspace.center
        greenspace.displayed = !greenspace.displayed
        if (reload) this.refreshGeojsons()
      }
    }
  },
  watch: {
    search: _.debounce(function () {
      var keys = []
      var search = this.search.trim()
      var match = search.match(/(.+):/)
      if (match) {
        keys = [match[1]]
        search = search.replace(/.+:/, '').trim()
      } else {
        keys = ['state', 'name', 'country']
      }
      this.$search(search, this.greenspaces, {
        keys: keys,
        defaultAll: true
      }).then(results => {
        this.results = results.length == 0 ? this.greenspaces : results
      })
    }, 400)
  },
  mounted () {
    // get the greenspaces
    greenspaces().then(resp => {
      resp.forEach((g, index) => {
        g.displayed = false
        g.geojson = null
        g.index = index
        this.greenspaces.push(g)
      })
      this.toggleVis(0)

      this.calcStats()
    })
    this.results = this.greenspaces
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
