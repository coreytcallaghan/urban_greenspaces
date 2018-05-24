import localforage from 'localforage'
import { setup } from 'axios-cache-adapter'

const store = localforage.createInstance({
  // List of drivers used
  driver: [
    localforage.INDEXEDDB,
    localforage.LOCALSTORAGE
  ],
  // Prefix all storage keys to prevent conflicts
  name: 'my-cache'
})

const api = setup({
  cache: {
    maxAge: 15 * 60 * 1000,
    store
  }
})
export const greenspaces = () =>
  api.get('https://api.github.com/repos/coreytcallaghan/urban_greenspaces/contents/geojson_greenspace_files')
    .then(resp => {
      return resp.data
        .filter(raw => raw.name.match(/\.geojson$/))
        .map(raw => {
          raw.name = raw.name.replace(/\.geojson$/, '')
          var split = raw.name.split('-')
          return {
            id: raw.name,
            name: split[2].split('_').map(x => x[0].toLocaleUpperCase() + x.substring(1, x.length)).join(' '),
            country: split[0].toLocaleUpperCase(),
            state: split[1].toLocaleUpperCase(),
            download: raw.download_url
          }
        })
    })

export const getGeoJson = url =>
  api.get(url).then(resp => resp.data)
