var req = require.context('./', false, /\.geojson$/)
export default req.keys().map(f => f.substr(2, f.length - 10))
