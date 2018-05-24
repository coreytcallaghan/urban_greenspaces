<template lang="pug">
div
  l-map.my-map(
    style="height: 600px;"
    ref="map",
    :zoom=13,
    :center="center")
    l-tile-layer(:url="url", :attribution="attribution")
    l-geo-json(:geojson='g' :key="i" v-for="(g, i) in geojsons")
  
    
  section.hero
    .hero-body
      nav.level(v-if='statistics')
        .level-item.has-text-centered
          div
            p.heading Greenspaces
            p.title {{statistics.count}}
        .level-item.has-text-centered
          div
            p.heading Countries
            p.title {{statistics.numCountries}}
      .container
        table.table.is-fullwidth.centered
          thead
            tr
              th Country
              th State/Province
              th Name
              th Displayed
              th GeoJson Download Link
              th
          tbody
            tr(v-for='(g, i) in greenspaces' :key='g.id')
              td {{g.country}}
              td {{g.state}}
              td {{g.name}}
              td {{g.displayed}}
              td 
                a(:href="g.download" target="_blank") Download Link
              td 
                a.button(@click='toggleVis(g.id)') Add to map
              

</template>

<script>
import Vue from 'vue'
import { LMap, LTileLayer, LGeoJson } from 'vue2-leaflet'
import axios from 'axios'
import { _ } from 'vue-underscore'

import { greenspaces, getGeoJson } from './getGreenspaces'
export default {
  components: { LMap, LTileLayer, LGeoJson },
  data () {
    return {
      center: [-33.95, 151.2],
      url: 'http://{s}.tile.osm.org/{z}/{x}/{y}.png',
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
      greenspaces: {},
      statistics: {},
      geojsons: []
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
        count: _.keys(this.greenspaces).length,
        numCountries: _.uniq(_.map(this.greenspaces, x => x.country)).length
      }
    },
    toggleVis (id, reload = true) {
      var greenspace = this.greenspaces[id]
      if (!greenspace.displayed && !greenspace.geojson) {
        getGeoJson(greenspace.download).then(data => {
          greenspace.geojson = data
          greenspace.displayed = !greenspace.displayed
          if (reload) this.refreshGeojsons()
        })
      } else {
        if (reload) this.refreshGeojsons()
        greenspace.displayed = !greenspace.displayed
      }
    }
  },
  mounted () {
    // get the greenspaces
    greenspaces().then(resp => {
      var nsw = resp.filter(x => x.state.match(/NSW/))
      resp.forEach(g => {
        g.displayed = false
        g.geojson = null
        this.greenspaces[g.id] = g
      })
      nsw.forEach((g, i) => {
        this.toggleVis(g.id, i == nsw.length - 1)
      })
      this.calcStats()
    })
    //var nsw = greenspaces.filter(x => x.match(/aus-nsw/))
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
