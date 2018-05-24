<template lang="pug">
div
  l-map.my-map(
    style="height: 600px;"
    ref="map",
    :zoom=13,
    :center="center")
    l-tile-layer(:url="url", :attribution="attribution")
    l-geo-json(:geojson='g' key="i" v-for="(g, i) in greenspaces")
</template>

<script>
import { LMap, LTileLayer, LGeoJson } from 'vue2-leaflet'
import greenspaces from '../../../geojson_greenspace_files'
import axios from 'axios'
var urlBuilder = file => {
  return `https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/geojson%20greenspace%20files/${file}`
}
export default {
  components: { LMap, LTileLayer, LGeoJson },
  data () {
    return {
      center: [-33.9, 151.2],
      url: 'http://{s}.tile.osm.org/{z}/{x}/{y}.png',
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
      greenspaces: []
    }
  },//
  // 'https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/geojson%20greenspace%20files/aus-nsw-baker_park.geojson'
  mounted () {
    axios.get(urlBuilder('aus-nsw-randwick_barracks.geojson'))
      .then(resp => {
        this.greenspaces.push(resp.data)
      })
      .catch(err => console.log(err))
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
