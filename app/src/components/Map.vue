<template lang="pug">
div
  .container
    l-map.my-map(
      style="height:600px;"
      ref="map",
      :zoom="zoom",
      :center="center")
      l-tile-layer(:url="url", :attribution="attribution")
      v-geo-search(:options='geosearchOptions')
      l-marker-clusterer(:options='zoomOptions')
        l-marker(:lat-lng='{lat:g.lat,lng:g.lon}',
                        :icon="icon(g.enough_lists)"
                        v-for='(g, i) in greenspaces' :key='i' ,
                        :opacity="g.opacity")
          l-popup
            div(v-if='g.enough_lists')
              router-link( :to="{ name: 'greenspacePage', params: { id: g.id}}")
                b {{ g.name }}
              | , has {{g.lists_total}} checklists! Check out its 
              router-link( :to="{ name: 'greenspacePage', params: { id: g.id}}") greenspace page!
            div(v-else) Unfortunately, 
              b {{ g.name }} 
              | doesn't have enough checklists, only {{g.lists_total}} checklists recorded.
    
  section.section.container
    nav.level(v-if='statistics')
      .level-item.has-text-centered
        div
          p.heading Greenspaces
          p.title {{ greenspaces.length }}
    .field
      .control.has-icons-left
        input.input.is-rounded.is-medium(placeholder='Search Greenspaces',
            v-model='search'
            @keyup.enter='searchFun(true)')
        span.icon.is-left
          i.fas.fa-search
      .help {{ this.status}}
    .table-container
      table.table
        thead
          tr
            th 
            th Name
            th Location
            th Total lists
            th Species all
            th Species on most checklists
            th
            th
            th
        tbody
          tr(v-for='(g, i) in results' ,:key='g.i')
            td 
              span.tag.is-success(v-if="g.enough_lists") Sufficient data
              span.tag.is-warning(v-else) Insufficient data
            td 
              b {{g.name}}
            td {{g.country + ', ' + g.state}}
            td {{g.lists_total}}
            td {{g.species_all}}
            td {{g.species_95}}
            td 
              router-link(v-if="g.enough_lists" :to="'/greenspace/' + g.id") Greenspace page
            td 
              a(:href="'https://github.com/coreytcallaghan/urban_greenspaces/tree/master/greenspaces/' + g.id" target="_blank") Github Page
            td
              a.button(@click='setCenter([g.lat,g.lon])') Center 

</template>

<script>
import Vue from 'vue'
import { LMap, LTileLayer, LPopup, LMarker, LCircleMarker, LDivIcon } from 'vue2-leaflet'
import Vue2LeafletMarkercluster from 'vue2-leaflet-markercluster'
import axios from 'axios'
import { _ } from 'vue-underscore'
import PopupContent from './PopupContent'
import { greenspaces, getGeoJson } from './getGreenspaces'
import map from './mapOpts'
import { OpenStreetMapProvider } from 'leaflet-geosearch'
import VGeoSearch from 'vue2-leaflet-geosearch'

export default {
  components: {
    LMap, LTileLayer, LMarker, PopupContent, LPopup, LCircleMarker,
    'l-marker-clusterer': Vue2LeafletMarkercluster,
    VGeoSearch  },
  data () {
    return {
      center: [-33.88, 151.209],
      zoom: 12,
      url: map.url,
      attribution: map.attribution,
      greenspaces: [],
      results: [],
      statistics: {},
      status: '',
      search: '',
      icon (suff) {
        return L.divIcon({ className: suff ? 'myIcon myIconGreen' : 'myIcon myIconRed' })
      },
      geosearchOptions: { // Important part Here
        provider: new OpenStreetMapProvider(),
      },
      zoomOptions: {
        disableClusteringAtZoom: 12,
        spiderfyOnMaxZoom: false      }
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
      this.$refs.map.setCenter(center, 16)
      this.$refs.map.setZoom(16)
    },
    toggleVis (index, reload = true) {
    },
    searchFun () {
      if (this.search === '') {
        this.results = this.greenspaces
        return
      }
      this.$search(this.search, this.greenspaces, {
        shouldSort: true,
        threshold: 0.6,
        location: 0,
        distance: 100,
        maxPatternLength: 32,
        minMatchCharLength: 1,
        keys: [
          "name",
          "id"
        ]
      }).then(results => {
        this.results = results
      })
    }
  },
  watch: {
    search: _.debounce(function () { this.searchFun(false) }, 100)
  },
  mounted () {
    greenspaces().then(ft => {
      this.greenspaces = ft.features.map(f => {
        f.properties.enough_lists = Boolean(f.properties.enough_lists)
        f.properties.color = f.properties.enough_lists ? 'green' : 'red'
        f.properties.opacity = f.properties.enough_lists ? 0.6 : 0.2
        f.properties.radius = f.properties.enough_lists ? 10 : 5
        return f.properties
      }).filter(g => g.country === 'AUS')
        .sort((a, b) => b.lists_total - a.lists_total)
      this.results = this.greenspaces
    })
  }
}
</script>
<style>
@import "../../node_modules/leaflet/dist/leaflet.css";
@import "~leaflet.markercluster/dist/MarkerCluster.css";
@import "~leaflet.markercluster/dist/MarkerCluster.Default.css";
@import "~leaflet-geosearch/assets/css/leaflet.css";
.my-map {
  height: 600px;
  width: 100%;
}
.myIcon {
  border: 5px solid rgba(255, 255, 255, 0.5);
  color: blue;
  font-weight: bold;
  text-align: center;
  border-radius: 50%;
  line-height: 30px;
}
.myIconGreen {
  border: 20px solid rgba(255, 255, 255, 0.5);
  background-color: #23d160;
  opacity: 0.7;
}
.myIconRed {
  opacity: 0.5;
  background-color: yellow;
}
</style>
