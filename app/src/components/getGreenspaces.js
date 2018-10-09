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
// store.clear()
const api = setup({
  cache: {
    maxAge: 30 * 60 * 1000,
    store
  }
})
export const greenspaces = () =>
  api.get('https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/greenspace_centers.geojson')
    .then(resp => resp.data)

export const getGeoJson = id =>
  api.get(`https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/greenspaces/${id}/${id}.geojson`).then(resp => resp.data)

export const getREADME = () =>
  api.get('https://api.github.com/repos/coreytcallaghan/urban_greenspaces/readme', {
    headers: { Accept: 'application/vnd.github.VERSION.html' }
  })

export const getMethods = () =>
  api.get('https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/methods.md')

export const getSpecies = (id) =>
  api.get(`https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/greenspaces/${id}/${id}.json`)
