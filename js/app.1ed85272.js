(function(t){function e(e){for(var a,r,c=e[0],o=e[1],l=e[2],p=0,h=[];p<c.length;p++)r=c[p],n[r]&&h.push(n[r][0]),n[r]=0;for(a in o)Object.prototype.hasOwnProperty.call(o,a)&&(t[a]=o[a]);u&&u(e);while(h.length)h.shift()();return i.push.apply(i,l||[]),s()}function s(){for(var t,e=0;e<i.length;e++){for(var s=i[e],a=!0,c=1;c<s.length;c++){var o=s[c];0!==n[o]&&(a=!1)}a&&(i.splice(e--,1),t=r(r.s=s[0]))}return t}var a={},n={1:0},i=[];function r(e){if(a[e])return a[e].exports;var s=a[e]={i:e,l:!1,exports:{}};return t[e].call(s.exports,s,s.exports,r),s.l=!0,s.exports}r.m=t,r.c=a,r.d=function(t,e,s){r.o(t,e)||Object.defineProperty(t,e,{configurable:!1,enumerable:!0,get:s})},r.r=function(t){Object.defineProperty(t,"__esModule",{value:!0})},r.n=function(t){var e=t&&t.__esModule?function(){return t["default"]}:function(){return t};return r.d(e,"a",e),e},r.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},r.p="/urban_greenspaces/";var c=window["webpackJsonp"]=window["webpackJsonp"]||[],o=c.push.bind(c);c.push=e,c=c.slice();for(var l=0;l<c.length;l++)e(c[l]);var u=o;i.push([9,0]),s()})({"6k2t":function(t,e,s){},"89Td":function(t,e,s){"use strict";var a=s("6k2t"),n=s.n(a);n.a},9:function(t,e,s){t.exports=s("Vtdi")},GmcL:function(t,e,s){},Vtdi:function(t,e,s){"use strict";s.r(e);s("VRzm");var a=s("Kw5r"),n=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("div",{attrs:{id:"app"}},[s("my-header"),s("router-view")],1)},i=[],r=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("section",{staticClass:"hero is-success"},[s("div",{staticClass:"hero-head"},[s("header",{staticClass:"navbar"},[s("div",{staticClass:"container"},[s("div",{staticClass:"navbar-brand"},[s("router-link",{staticClass:"navbar-item",attrs:{to:"/"}},[s("div",{staticClass:"title is-3"},[s("span",{staticClass:"fas fa-dove"}),t._v(" Greenspace bird calculator"),s("span",{staticClass:"fas fa-tree"})])]),t._m(0)],1),s("div",{staticClass:"navbar-menu"},[s("div",{staticClass:"navbar-end"},[s("router-link",{staticClass:"navbar-item is-size-4",attrs:{to:"/about"}},[t._v("About")]),t._m(1)],1)])])])])])},c=[function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("span",{staticClass:"navbar-burger burger",attrs:{"data-target":"navbarMenuHeroC"}},[s("span"),s("span"),s("span")])},function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("a",{staticClass:"navbar-item is-size-4",attrs:{href:"https://github.com/coreytcallaghan/urban_greenspaces/"}},[s("span",{staticClass:"fab fa-github"})])}],o={},l=o,u=s("KHd+"),p=Object(u["a"])(l,r,c,!1,null,null,null),h=p.exports,m={components:{"my-header":h}},d=m,v=(s("ZL7j"),Object(u["a"])(d,n,i,!1,null,null,null)),g=v.exports,_=s("jE9Z"),f=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("my-map")},b=[],C=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("div",[s("div",{staticClass:"container"},[s("l-map",{ref:"map",staticClass:"my-map",staticStyle:{height:"600px"},attrs:{zoom:t.zoom,center:t.center}},[s("l-tile-layer",{attrs:{url:t.url,attribution:t.attribution}}),s("v-geo-search",{attrs:{options:t.geosearchOptions}}),s("l-marker-clusterer",{attrs:{options:t.zoomOptions}},t._l(t.greenspaces,function(e,a){return s("l-marker",{key:a,attrs:{"lat-lng":{lat:e.lat,lng:e.lon},icon:t.icon(e.enough_lists),opacity:e.opacity}},[s("l-popup",[e.enough_lists?s("div",[s("router-link",{attrs:{to:{name:"greenspacePage",params:{id:e.id}}}},[s("b",[t._v(t._s(e.name))])]),t._v(", has "+t._s(e.lists_total)+" checklists! Check out its "),s("router-link",{attrs:{to:{name:"greenspacePage",params:{id:e.id}}}},[t._v("greenspace page!")])],1):s("div",[t._v("Unfortunately, "),s("b",[t._v(t._s(e.name)+" ")]),t._v("doesn't have enough checklists, only "+t._s(e.lists_total)+" checklists recorded.")])])],1)}))],1)],1),s("section",{staticClass:"section container"},[t.statistics?s("nav",{staticClass:"level"},[s("div",{staticClass:"level-item has-text-centered"},[s("div",[s("p",{staticClass:"heading"},[t._v("Greenspaces")]),s("p",{staticClass:"title"},[t._v(t._s(t.greenspaces.length))])])])]):t._e(),s("div",{staticClass:"field"},[s("div",{staticClass:"control has-icons-left"},[s("input",{directives:[{name:"model",rawName:"v-model",value:t.search,expression:"search"}],staticClass:"input is-rounded is-medium",attrs:{placeholder:"Search Greenspaces"},domProps:{value:t.search},on:{keyup:function(e){if(!("button"in e)&&t._k(e.keyCode,"enter",13,e.key,"Enter"))return null;t.searchFun(!0)},input:function(e){e.target.composing||(t.search=e.target.value)}}}),t._m(0)]),s("div",{staticClass:"help"},[t._v(t._s(this.status))])]),s("div",{staticClass:"table-container"},[s("table",{staticClass:"table"},[t._m(1),s("tbody",t._l(t.results,function(e,a){return s("tr",{key:e.i},[s("td",[e.enough_lists?s("span",{staticClass:"tag is-success"},[t._v("Sufficient data")]):s("span",{staticClass:"tag is-warning"},[t._v("Insufficient data")])]),s("td",[s("b",[t._v(t._s(e.name))])]),s("td",[t._v(t._s(e.country+", "+e.state))]),s("td",[t._v(t._s(e.lists_total))]),s("td",[t._v(t._s(e.species_all))]),s("td",[t._v(t._s(e.species_95))]),s("td",[e.enough_lists?s("router-link",{attrs:{to:"/greenspace/"+e.id}},[t._v("Greenspace page")]):t._e()],1),s("td",[s("a",{attrs:{href:"https://github.com/coreytcallaghan/urban_greenspaces/tree/master/greenspaces/"+e.id,target:"_blank"}},[t._v("Github Page")])]),s("td",[s("a",{staticClass:"button",on:{click:function(s){t.setCenter([e.lat,e.lon])}}},[t._v("Center ")])])])}))])])])])},y=[function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("span",{staticClass:"icon is-left"},[s("i",{staticClass:"fas fa-search"})])},function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("thead",[s("tr",[s("th"),s("th",[t._v("Name")]),s("th",[t._v("Location")]),s("th",[t._v("Total lists")]),s("th",[t._v("Species all")]),s("th",[t._v("Species on most checklists")]),s("th"),s("th"),s("th")])])}],w=(s("Vd3H"),s("OG14"),s("RY4O")),k=s("yp/A"),x=s.n(k),O=(s("vDqi"),s("8u8D")),j=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("div",[s("h3",{staticClass:"title"},[t._v(t._s(t.name))]),s("img",{staticClass:"main-popup",attrs:{src:"aus-nsw-randwick_environment_park.png"}})])},E=[],M={name:"PopupContent",props:["name"]},I=M,P=(s("XLm7"),Object(u["a"])(I,j,E,!1,null,null,null)),S=P.exports,$=s("oAJy"),G=s.n($),A=s("bw2g"),z=G.a.createInstance({driver:[G.a.INDEXEDDB,G.a.LOCALSTORAGE],name:"my-cache"}),T=Object(A["setup"])({cache:{maxAge:18e5,store:z}}),R=function(){return T.get("https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/greenspace_centers.geojson").then(function(t){return t.data})},D=function(t){return T.get("https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/greenspaces/".concat(t,"/").concat(t,".geojson")).then(function(t){return t.data})},N=function(){return T.get("https://api.github.com/repos/coreytcallaghan/urban_greenspaces/readme",{headers:{Accept:"application/vnd.github.VERSION.html"}})},Z=function(){return T.get("https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/methods.md")},J=function(t){return T.get("https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/greenspaces/".concat(t,"/").concat(t,".json"))},K=function(t){return T.get("https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/greenspaces/".concat(t,"/metadata-").concat(t,".json"))},U={url:"https://api.mapbox.com/v4/mapbox.streets-basic/{z}/{x}/{y}.png?access_token=pk.eyJ1Ijoiam9obi13aWxzaGlyZSIsImEiOiJjajIyZ2Y4dG0wMGZmMnhvNHN2aWVwdWo4In0.Znb0T9ndyQHmKZmx9VGMQw",attribution:"&copy; <a href='https://www.mapbox.com/about/maps/'>Mapbox</a> © <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a> <strong><a href='https://www.mapbox.com/map-feedback/' target='_blank'>Improve this map</a></strong>"},V=s("xuDP"),H=s("zCu8"),X={components:{LMap:w["LMap"],LTileLayer:w["LTileLayer"],LMarker:w["LMarker"],PopupContent:S,LPopup:w["LPopup"],LCircleMarker:w["LCircleMarker"],"l-marker-clusterer":x.a,VGeoSearch:H["a"]},data:function(){return{center:[-33.88,151.209],zoom:12,url:U.url,attribution:U.attribution,greenspaces:[],results:[],statistics:{},status:"",search:"",icon:function(t){return L.divIcon({className:t?"myIcon myIconGreen":"myIcon myIconRed"})},geosearchOptions:{provider:new V["OpenStreetMapProvider"]},zoomOptions:{disableClusteringAtZoom:12,spiderfyOnMaxZoom:!1}}},methods:{calcStats:function(){this.statistics={count:this.greenspaces.length}},setCenter:function(t){this.$refs.map.setCenter(t,16),this.$refs.map.setZoom(16)},toggleVis:function(t){!(arguments.length>1&&void 0!==arguments[1])||arguments[1]},searchFun:function(){var t=this;""!==this.search?this.$search(this.search,this.greenspaces,{shouldSort:!0,threshold:.6,location:0,distance:100,maxPatternLength:32,minMatchCharLength:1,keys:["name","id"]}).then(function(e){t.results=e}):this.results=this.greenspaces}},watch:{search:O["a"].debounce(function(){this.searchFun(!1)},100)},mounted:function(){var t=this;R().then(function(e){t.greenspaces=e.features.map(function(t){return t.properties.enough_lists=Boolean(t.properties.enough_lists),t.properties.color=t.properties.enough_lists?"green":"red",t.properties.opacity=t.properties.enough_lists?.6:.2,t.properties.radius=t.properties.enough_lists?10:5,t.properties}).filter(function(t){return"AUS"===t.country}).sort(function(t,e){return e.lists_total-t.lists_total}),t.results=t.greenspaces})}},B=X,W=(s("mIwK"),Object(u["a"])(B,C,y,!1,null,null,null)),F=W.exports,Y={name:"home",components:{"my-map":F}},q=Y,Q=Object(u["a"])(q,f,b,!1,null,null,null),tt=Q.exports,et=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("section",{staticClass:"section"},[s("div",{staticClass:"container is-size-5"},[s("div",{staticClass:"content",domProps:{innerHTML:t._s(t.README)}})])])},st=[],at={data:function(){return{README:""}},mounted:function(){var t=this;N().then(function(e){t.README=e.data}).catch(function(e){return t.README=e.message})}},nt=at,it=(s("emOn"),Object(u["a"])(nt,et,st,!1,null,null,null)),rt=it.exports,ct=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("div",{staticClass:"container"},[s("section",{staticClass:"hero"},[s("div",{staticClass:"hero-body"},[s("nav",{staticClass:"level"},[s("div",{staticClass:"title"},[t._v(t._s(t.name))]),s("div",{staticClass:"level-item has-text-centered"},[s("div",[s("p",{staticClass:"heading"},[t._v("Checklists")]),s("p",{staticClass:"title"},[t._v(t._s(t.totalLists))])])]),s("div",{staticClass:"level-item has-text-centered"},[s("div",[s("p",{staticClass:"heading"},[t._v("Species")]),s("p",{staticClass:"title"},[t._v(" "+t._s(t.speciesAll))])])]),s("div",{staticClass:"level-item has-text-centered"},[s("div",[s("p",{staticClass:"heading"},[t._v("Species 95")]),s("p",{staticClass:"title"},[t._v(" "+t._s(t.species95))])])])])])]),s("div",{staticClass:"columns"},[s("div",{staticClass:"column is-third"},[s("div",{staticClass:"box"},[s("l-map",{ref:"map",staticClass:"my-map",staticStyle:{height:"400px"},attrs:{center:t.center,zoom:t.zoom}},[s("l-tile-layer",{attrs:{url:t.url,attribution:t.attribution}}),""!==t.geojson?s("l-geo-json",{attrs:{geojson:t.geojson}}):t._e()],1)],1)]),s("div",{directives:[{name:"show",rawName:"v-show",value:!t.enoughLists,expression:"!enoughLists"}],staticClass:"column is-third"},[t._m(0)]),s("div",{directives:[{name:"show",rawName:"v-show",value:t.enoughLists,expression:"enoughLists"}],staticClass:"column is-third"},[s("div",{staticClass:"box"},[s("img",{staticClass:"image accum",attrs:{src:t.accum}})])]),s("div",{directives:[{name:"show",rawName:"v-show",value:t.enoughLists,expression:"enoughLists"}],staticClass:"column is-third"},[s("div",{staticClass:"box"},[s("img",{staticClass:"image accum",attrs:{src:t.listsTime}})])])]),s("div",{staticClass:"columns"},[s("div",{staticClass:"column is-half"},[s("div",{staticClass:"box content",domProps:{innerHTML:t._s(t.methods)}})]),s("div",{directives:[{name:"show",rawName:"v-show",value:t.enoughLists,expression:"enoughLists"}],staticClass:"column is-half"},[s("div",{staticClass:"box"},[t.enoughLists?s("table",{staticClass:"table is-fullwidth"},[t._m(1),s("tbody",t._l(t.species,function(e,a){return s("tr",{key:a},[s("td",[t._v(t._s(a+1))]),s("td",[t._v(t._s(e.Species))]),s("td",[t._v(t._s(e["Reporting rate (%)"]))])])}))]):t._e()])])])])},ot=[function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("div",{staticClass:"box"},[s("div",{staticClass:"title"},[t._v("Insufficient data")])])},function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("thead",[s("tr",[s("th",[t._v("Rank")]),s("th",[t._v("Species")]),s("th",[t._v("Reporting rate (%)")])])])}],lt=(s("KKXr"),s("SPBs")),ut=s.n(lt),pt=s("7N6H"),ht={components:{LMap:w["LMap"],LTileLayer:w["LTileLayer"],LMarker:w["LMarker"],LGeoJson:w["LGeoJson"]},data:function(){return{id:"",url:U.url,geojson:"",center:[0,0],zoom:14,attribution:U.attribution,name:"",state:"",country:"",accum:"",listsTime:"",species:[],methods:"",totalLists:null,speciesAll:null,species95:null,enoughLists:!1,error:!1}},mounted:function(){var t=this;this.id=this.$route.params.id,D(this.id).then(function(e){t.geojson=e,t.center=ut()(e).geometry.coordinates.reverse()});var e=this.id.split("-");this.name=e[2].split("_").map(function(t){return t[0].toLocaleUpperCase()+t.substring(1,t.length)}).join(" "),this.country=e[0].toLocaleUpperCase(),this.state=e[1].toLocaleUpperCase(),this.accum="https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/greenspaces/".concat(this.id,"/accum_curves-").concat(this.id,".png"),this.listsTime="https://raw.githubusercontent.com/coreytcallaghan/urban_greenspaces/master/greenspaces/".concat(this.id,"/lists_time-").concat(this.id,".png"),K(this.id).then(function(e){console.log(e.data),t.totalLists=e.data[0].lists_total,t.enoughLists=e.data[0].enough_lists,t.species95=e.data[0].species_95,t.speciesAll=e.data[0].species_all}),J(this.id).then(function(e){t.species=e.data}).catch(function(e){t.error=!0}),Z().then(function(e){t.methods=Object(pt["a"])(e.data)}).catch(function(e){t.methods=e.message,t.error=!0})}},mt=ht,dt=(s("89Td"),Object(u["a"])(mt,ct,ot,!1,null,null,null)),vt=dt.exports;a["a"].use(_["a"]);var gt=new _["a"]({routes:[{path:"/",name:"home",component:tt},{path:"/about",name:"about",component:rt},{path:"/greenspace/:id",name:"greenspacePage",component:vt}]}),_t=s("4R65"),ft=s.n(_t),bt=s("lq/x");a["a"].use(bt["a"]),a["a"].config.productionTip=!1,delete ft.a.Icon.Default.prototype._getIconUrl,ft.a.Icon.Default.mergeOptions({iconRetinaUrl:s("WE1v"),iconUrl:s("Y5fm"),shadowUrl:s("4rkx")}),new a["a"]({router:gt,render:function(t){return t(g)}}).$mount("#app")},XLm7:function(t,e,s){"use strict";var a=s("kXBO"),n=s.n(a);n.a},ZL7j:function(t,e,s){"use strict";var a=s("bP1M"),n=s.n(a);n.a},bP1M:function(t,e,s){},emOn:function(t,e,s){"use strict";var a=s("GmcL"),n=s.n(a);n.a},kXBO:function(t,e,s){},mIwK:function(t,e,s){"use strict";var a=s("mpKJ"),n=s.n(a);n.a},mpKJ:function(t,e,s){}});
//# sourceMappingURL=app.1ed85272.js.map