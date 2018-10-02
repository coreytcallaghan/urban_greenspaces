<template lang="pug">
div
  .container
    l-map.my-map(
      style="height: 500px;"
      ref="map",
      :zoom="zoom",
      :center="center")
      l-tile-layer(:url="url", :attribution="attribution")
      l-geo-json(:geojson='g.geojson', :key="i", v-if="g.displayed", :options='geojsonOptions', v-for="(g, i) in greenspaces")
        popup-content(content="Circle")
    
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
          //td select
            input(type='checkbox')
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
import { LMap, LTileLayer, LGeoJson } from 'vue2-leaflet'
import axios from 'axios'
import { _ } from 'vue-underscore'
import center from '@turf/center'
import PopupContent from './PopupContent'
import { greenspaces, getGeoJson } from './getGreenspaces'
// import  from './'
function onEachFeature (feature, layer) {
  let PopupCont = Vue.extend(PopupContent);
  let popup = new PopupCont({ propsData: { type: feature.geometry.type, text: feature.properties.popupContent } });
  layer.bindPopup(popup.$mount().$el);
}
export default {
  components: { LMap, LTileLayer, LGeoJson, PopupContent },
  data () {
    return {
      center: [-33.95, 151.2],
      zoom: 14,
      url: 'https://api.mapbox.com/v4/mapbox.streets-basic/{z}/{x}/{y}.png?access_token=pk.eyJ1Ijoiam9obi13aWxzaGlyZSIsImEiOiJjajIyZ2Y4dG0wMGZmMnhvNHN2aWVwdWo4In0.Znb0T9ndyQHmKZmx9VGMQw',
      attribution: "&copy; <a href='https://www.mapbox.com/about/maps/'>Mapbox</a> © <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a> <strong><a href='https://www.mapbox.com/map-feedback/' target='_blank'>Improve this map</a></strong>",
      greenspaces: [],
      results: [],
      statistics: {},
      status: 'Try searching $add state:NSW then press enter to execute, $reset removes all greenspaces.',
      geojsonOptions: {
        style: {
          color: '#333',
          weight: 2
        },
        onEachFeature
      },
      search: ''
    }
  },
  methods: {
    calcStats () {
      this.statistics = {
        count: this.greenspaces.length,
        numCountries: _.uniq(this.greenspaces.map(x => x.country)).length
      }
    },
    setCenter (center) {
      this.$refs.map.setCenter(center, this.zoom)
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
          if (reload) this.setCenter(greenspace.center)
        })
      } else {
        if (!greenspace.displayed) {
          if (reload) this.setCenter(greenspace.center)
        }
        greenspace.displayed = !greenspace.displayed
      }
    },
    searchFun (go = false) {
      var keys = []
      var action = 'search'
      var search = this.search.trim()
      if (search === '$reset') {
        this.greenspaces.forEach(g => { g.displayed = false })
        return
      }
      var commandMatch = search.match(/^\$([^ ]+)/)
      if (commandMatch) {
        action = commandMatch[1]
        search = search.replace(/^\$[^ ]+/, '').trim()
      }

      var match = search.match(/(.+):/)
      if (match) {
        keys = [match[1]]
        search = search.replace(/.+:/, '').trim()
      } else {
        keys = ['state', 'name', 'country']
      }
      if (action === 'search') {
        this.$search(search, this.greenspaces, {
          keys: keys,
          defaultAll: true
        }).then(results => {
          this.results = results.length == 0 ? this.greenspaces : results
        })
      } else if (action === 'add') {
        var out = this.greenspaces.filter(g =>
          keys.map(k => g[k].toLowerCase()).reduce((l, r) => l + '-' + r).match('^' + search.toLowerCase())
        )
        this.results = out
        if (out.length > 100) {
          this.status = 'Please refine your search to include less than 100 greenspaces.'
          return
        }
        if (go) {
          this.results.forEach(g => g.displayed = false)
          this.results.forEach((g, i) => this.toggleVis(g.index, i === this.results.length - 1))
        }
      }
    }
  },
  watch: {
    search: _.debounce(function () { this.searchFun(false) }, 400)
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
      const numToAdd = 0
      this.toggleVis(this.greenspaces.findIndex(x => x.id === 'aus-nsw-randwick_environment_park'))
      this.greenspaces.slice(0, numToAdd).forEach((g, i) => {
        this.toggleVis(g.index)
      })
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
