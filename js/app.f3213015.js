(function(t){function e(e){for(var n,i,o=e[0],c=e[1],l=e[2],p=0,h=[];p<o.length;p++)i=o[p],a[i]&&h.push(a[i][0]),a[i]=0;for(n in c)Object.prototype.hasOwnProperty.call(c,n)&&(t[n]=c[n]);u&&u(e);while(h.length)h.shift()();return r.push.apply(r,l||[]),s()}function s(){for(var t,e=0;e<r.length;e++){for(var s=r[e],n=!0,o=1;o<s.length;o++){var c=s[o];0!==a[c]&&(n=!1)}n&&(r.splice(e--,1),t=i(i.s=s[0]))}return t}var n={},a={1:0},r=[];function i(e){if(n[e])return n[e].exports;var s=n[e]={i:e,l:!1,exports:{}};return t[e].call(s.exports,s,s.exports,i),s.l=!0,s.exports}i.m=t,i.c=n,i.d=function(t,e,s){i.o(t,e)||Object.defineProperty(t,e,{configurable:!1,enumerable:!0,get:s})},i.r=function(t){Object.defineProperty(t,"__esModule",{value:!0})},i.n=function(t){var e=t&&t.__esModule?function(){return t["default"]}:function(){return t};return i.d(e,"a",e),e},i.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},i.p="/urban_greenspaces/";var o=window["webpackJsonp"]=window["webpackJsonp"]||[],c=o.push.bind(o);o.push=e,o=o.slice();for(var l=0;l<o.length;l++)e(o[l]);var u=c;r.push([4,0]),s()})({4:function(t,e,s){t.exports=s("Vtdi")},GmcL:function(t,e,s){},Vtdi:function(t,e,s){"use strict";s.r(e);s("VRzm");var n=s("Kw5r"),a=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("div",{attrs:{id:"app"}},[s("my-header"),s("router-view")],1)},r=[],i=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("section",{staticClass:"hero is-success"},[s("div",{staticClass:"hero-head"},[s("header",{staticClass:"navbar"},[s("div",{staticClass:"container"},[s("div",{staticClass:"navbar-brand"},[s("router-link",{staticClass:"navbar-item",attrs:{to:"/"}},[s("div",{staticClass:"title"},[s("span",{staticClass:"fas fa-dove"}),t._v(" Urban Greenspaces "),s("span",{staticClass:"fas fa-tree"})])]),t._m(0)],1),s("div",{staticClass:"navbar-menu"},[s("div",{staticClass:"navbar-end"},[s("router-link",{staticClass:"navbar-item is-size-4",attrs:{to:"/about"}},[t._v("About")]),t._m(1)],1)])])])])])},o=[function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("span",{staticClass:"navbar-burger burger",attrs:{"data-target":"navbarMenuHeroC"}},[s("span"),s("span"),s("span")])},function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("a",{staticClass:"navbar-item is-size-4",attrs:{href:"https://github.com/coreytcallaghan/urban_greenspaces/"}},[s("span",{staticClass:"fab fa-github"})])}],c={},l=c,u=s("KHd+"),p=Object(u["a"])(l,i,o,!1,null,null,null),h=p.exports,d={components:{"my-header":h}},f=d,m=(s("ZL7j"),Object(u["a"])(f,a,r,!1,null,null,null)),v=m.exports,g=s("jE9Z"),_=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("my-map")},b=[],C=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("div",[s("l-map",{ref:"map",staticClass:"my-map",staticStyle:{height:"600px"},attrs:{zoom:t.zoom,center:t.center}},[s("l-tile-layer",{attrs:{url:t.url,attribution:t.attribution}}),t._l(t.geojsons,function(t,e){return s("l-geo-json",{key:e,attrs:{geojson:t}})})],2),s("section",{staticClass:"section container"},[t.statistics?s("nav",{staticClass:"level"},[s("div",{staticClass:"level-item has-text-centered"},[s("div",[s("p",{staticClass:"heading"},[t._v("Greenspaces")]),s("p",{staticClass:"title"},[t._v(t._s(t.statistics.count))])])]),s("div",{staticClass:"level-item has-text-centered"},[t.search?s("div",[s("p",{staticClass:"heading"},[t._v("Matches")]),s("p",{staticClass:"title"},[t._v(t._s(t.results.length))])]):t._e()]),s("div",{staticClass:"level-item has-text-centered"},[s("div",[s("p",{staticClass:"heading"},[t._v("Countries")]),s("p",{staticClass:"title"},[t._v(t._s(t.statistics.numCountries))])])])]):t._e(),s("div",{staticClass:"field"},[s("div",{staticClass:"control has-icons-left"},[s("input",{directives:[{name:"model",rawName:"v-model",value:t.search,expression:"search"}],staticClass:"input is-rounded is-large",attrs:{placeholder:"Search Greenspaces"},domProps:{value:t.search},on:{input:function(e){e.target.composing||(t.search=e.target.value)}}}),t._m(0)])]),s("div",{staticClass:"container"},[s("table",{staticClass:"table is-fullwidth has-text-centered"},[t._m(1),s("tbody",t._l(this.results,function(e,n){return s("tr",{key:e.id},[s("td",[t._v(t._s(e.country))]),s("td",[t._v(t._s(e.state))]),s("td",[t._v(t._s(e.name))]),s("td",[s("a",{attrs:{href:e.download,target:"_blank"}},[t._v("Download Link")])]),s("td",[s("a",{staticClass:"button",class:{"is-info":e.displayed},on:{click:function(s){t.toggleVis(e.index)}}},[e.displayed?s("div",[t._v("Remove from map")]):s("div",[t._v("Add to map")])])])])}))])])])],1)},y=[function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("span",{staticClass:"icon is-left"},[s("i",{staticClass:"fas fa-search"})])},function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("thead",[s("tr",[s("th",[t._v("Country")]),s("th",[t._v("State/Province")]),s("th",[t._v("Name")]),s("th",[t._v("GeoJson Download Link")]),s("th")])])}],j=(s("rGqo"),s("pIFo"),s("SRfc"),s("OG14"),s("RY4O")),w=(s("vDqi"),s("8u8D")),E=s("SPBs"),x=s.n(E),O=(s("KKXr"),s("f3/d"),s("oAJy")),L=s.n(O),G=s("bw2g"),M=L.a.createInstance({driver:[L.a.INDEXEDDB,L.a.LOCALSTORAGE],name:"my-cache"}),D=Object(G["setup"])({cache:{maxAge:18e5,store:M}}),$=function(){return D.get("https://api.github.com/repos/coreytcallaghan/urban_greenspaces/contents/geojson_greenspace_files").then(function(t){return t.data.filter(function(t){return t.name.match(/\.geojson$/)}).map(function(t){t.name=t.name.replace(/\.geojson$/,"");var e=t.name.split("-");return{id:t.name,name:e[2].split("_").map(function(t){return t[0].toLocaleUpperCase()+t.substring(1,t.length)}).join(" "),country:e[0].toLocaleUpperCase(),state:e[1].toLocaleUpperCase(),download:t.download_url}})})},k=function(t){return D.get(t).then(function(t){return t.data})},A=function(){return D.get("https://api.github.com/repos/coreytcallaghan/urban_greenspaces/readme",{headers:{Accept:"application/vnd.github.VERSION.html"}})},R={components:{LMap:j["LMap"],LTileLayer:j["LTileLayer"],LGeoJson:j["LGeoJson"]},data:function(){return{center:[-33.95,151.2],zoom:13,url:"http://{s}.tile.osm.org/{z}/{x}/{y}.png",attribution:'&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',greenspaces:[],results:[],statistics:{},geojsons:[],search:""}},methods:{refreshGeojsons:function(){this.greenspaces?this.geojsons=w["a"].filter(this.greenspaces,function(t){return t.displayed}).map(function(t){return t.geojson}):this.geojsons=[]},calcStats:function(){this.statistics={count:this.greenspaces.length,numCountries:w["a"].uniq(this.greenspaces.map(function(t){return t.country})).length}},toggleVis:function(t){var e=this,s=!(arguments.length>1&&void 0!==arguments[1])||arguments[1],n=this.greenspaces[t];n.displayed||n.geojson?(n.displayed&&s&&(this.center=n.center),n.displayed=!n.displayed,s&&this.refreshGeojsons()):k(n.download).then(function(t){n.geojson=t,n.displayed=!n.displayed;var a=x()(t).geometry.coordinates;n.center=[a[1],a[0]],n.displayed&&s&&(e.center=n.center),s&&e.refreshGeojsons()})}},watch:{search:w["a"].debounce(function(){var t=this,e=[],s=this.search.trim(),n=s.match(/(.+):/);n?(e=[n[1]],s=s.replace(/.+:/,"").trim()):e=["state","name","country"],this.$search(s,this.greenspaces,{keys:e,defaultAll:!0}).then(function(e){t.results=0==e.length?t.greenspaces:e})},400)},mounted:function(){var t=this;$().then(function(e){e.forEach(function(e,s){e.displayed=!1,e.geojson=null,e.index=s,t.greenspaces.push(e)}),t.calcStats()}),this.results=this.greenspaces}},P=R,S=(s("mIwK"),Object(u["a"])(P,C,y,!1,null,null,null)),I=S.exports,z={name:"home",components:{"my-map":I}},J=z,K=Object(u["a"])(J,_,b,!1,null,null,null),U=K.exports,V=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("section",{staticClass:"section"},[s("div",{staticClass:"container is-size-5"},[s("div",{staticClass:"content",domProps:{innerHTML:t._s(t.README)}})])])},T=[],q={data:function(){return{README:""}},mounted:function(){var t=this;A().then(function(e){t.README=e.data}).catch(function(e){return t.README=e.message})}},N=q,H=(s("emOn"),Object(u["a"])(N,V,T,!1,null,null,null)),Z=H.exports;n["a"].use(g["a"]);var B=new g["a"]({routes:[{path:"/",name:"home",component:U},{path:"/about",name:"about",component:Z}]}),X=s("4R65"),Y=s.n(X),F=s("lq/x");n["a"].use(F["a"]),n["a"].config.productionTip=!1,delete Y.a.Icon.Default.prototype._getIconUrl,Y.a.Icon.Default.mergeOptions({iconRetinaUrl:s("WE1v"),iconUrl:s("Y5fm"),shadowUrl:s("4rkx")}),new n["a"]({router:B,render:function(t){return t(v)}}).$mount("#app")},ZL7j:function(t,e,s){"use strict";var n=s("bP1M"),a=s.n(n);a.a},bP1M:function(t,e,s){},emOn:function(t,e,s){"use strict";var n=s("GmcL"),a=s.n(n);a.a},mIwK:function(t,e,s){"use strict";var n=s("mpKJ"),a=s.n(n);a.a},mpKJ:function(t,e,s){}});
//# sourceMappingURL=app.f3213015.js.map