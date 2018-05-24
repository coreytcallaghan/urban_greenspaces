(function(t){function e(e){for(var a,o,i=e[0],c=e[1],l=e[2],p=0,d=[];p<i.length;p++)o=i[p],s[o]&&d.push(s[o][0]),s[o]=0;for(a in c)Object.prototype.hasOwnProperty.call(c,a)&&(t[a]=c[a]);u&&u(e);while(d.length)d.shift()();return r.push.apply(r,l||[]),n()}function n(){for(var t,e=0;e<r.length;e++){for(var n=r[e],a=!0,i=1;i<n.length;i++){var c=n[i];0!==s[c]&&(a=!1)}a&&(r.splice(e--,1),t=o(o.s=n[0]))}return t}var a={},s={1:0},r=[];function o(e){if(a[e])return a[e].exports;var n=a[e]={i:e,l:!1,exports:{}};return t[e].call(n.exports,n,n.exports,o),n.l=!0,n.exports}o.m=t,o.c=a,o.d=function(t,e,n){o.o(t,e)||Object.defineProperty(t,e,{configurable:!1,enumerable:!0,get:n})},o.r=function(t){Object.defineProperty(t,"__esModule",{value:!0})},o.n=function(t){var e=t&&t.__esModule?function(){return t["default"]}:function(){return t};return o.d(e,"a",e),e},o.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},o.p="/";var i=window["webpackJsonp"]=window["webpackJsonp"]||[],c=i.push.bind(i);i.push=e,i=i.slice();for(var l=0;l<i.length;l++)e(i[l]);var u=c;r.push([3,0]),n()})({3:function(t,e,n){t.exports=n("Vtdi")},Vtdi:function(t,e,n){"use strict";n.r(e);n("VRzm");var a=n("Kw5r"),s=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{attrs:{id:"app"}},[n("my-header"),n("router-view")],1)},r=[],o=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("section",{staticClass:"hero is-success"},[n("div",{staticClass:"hero-head"},[n("header",{staticClass:"navbar"},[n("div",{staticClass:"container"},[n("div",{staticClass:"navbar-brand"},[n("router-link",{staticClass:"navbar-item",attrs:{to:"/"}},[n("div",{staticClass:"title"},[n("span",{staticClass:"fas fa-dove"}),t._v(" Urban Greenspaces "),n("span",{staticClass:"fas fa-tree"})])]),t._m(0)],1),n("div",{staticClass:"navbar-menu"},[n("div",{staticClass:"navbar-end"},[n("router-link",{staticClass:"navbar-item is-size-4",attrs:{to:"/about"}},[t._v("About")])],1)])])])])])},i=[function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("span",{staticClass:"navbar-burger burger",attrs:{"data-target":"navbarMenuHeroC"}},[n("span"),n("span"),n("span")])}],c={},l=c,u=n("KHd+"),p=Object(u["a"])(l,o,i,!1,null,null,null),d=p.exports,f={components:{"my-header":d}},h=f,v=(n("ZL7j"),Object(u["a"])(h,s,r,!1,null,null,null)),m=v.exports,g=n("jE9Z"),_=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("my-map")},b=[],y=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",[n("l-map",{ref:"map",staticClass:"my-map",staticStyle:{height:"600px"},attrs:{zoom:13,center:t.center}},[n("l-tile-layer",{attrs:{url:t.url,attribution:t.attribution}}),t._l(t.geojsons,function(t,e){return n("l-geo-json",{key:e,attrs:{geojson:t}})})],2),n("section",{staticClass:"hero"},[n("div",{staticClass:"hero-body"},[t.statistics?n("nav",{staticClass:"level"},[n("div",{staticClass:"level-item has-text-centered"},[n("div",[n("p",{staticClass:"heading"},[t._v("Greenspaces")]),n("p",{staticClass:"title"},[t._v(t._s(t.statistics.count))])])]),n("div",{staticClass:"level-item has-text-centered"},[n("div",[n("p",{staticClass:"heading"},[t._v("Countries")]),n("p",{staticClass:"title"},[t._v(t._s(t.statistics.numCountries))])])])]):t._e(),n("div",{staticClass:"container"},[n("table",{staticClass:"table is-fullwidth centered"},[t._m(0),n("tbody",t._l(t.greenspaces,function(e,a){return n("tr",{key:e.id},[n("td",[t._v(t._s(e.country))]),n("td",[t._v(t._s(e.state))]),n("td",[t._v(t._s(e.name))]),n("td",[t._v(t._s(e.displayed))]),n("td",[n("a",{attrs:{href:e.download,target:"_blank"}},[t._v("Download Link")])]),n("td",[n("a",{staticClass:"button",on:{click:function(n){t.toggleVis(e.id)}}},[t._v("Add to map")])])])}))])])])])],1)},C=[function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("thead",[n("tr",[n("th",[t._v("Country")]),n("th",[t._v("State/Province")]),n("th",[t._v("Name")]),n("th",[t._v("Displayed")]),n("th",[t._v("GeoJson Download Link")]),n("th")])])}],j=(n("SRfc"),n("rGqo"),n("yt8O"),n("RY4O")),w=(n("vDqi"),n("8u8D")),O=(n("KKXr"),n("pIFo"),n("f3/d"),n("oAJy")),x=n.n(O),L=n("bw2g"),E=x.a.createInstance({driver:[x.a.INDEXEDDB,x.a.LOCALSTORAGE],name:"my-cache"}),k=Object(L["setup"])({cache:{maxAge:9e5,store:E}}),$=function(){return k.get("https://api.github.com/repos/coreytcallaghan/urban_greenspaces/contents/geojson_greenspace_files").then(function(t){return t.data.filter(function(t){return t.name.match(/\.geojson$/)}).map(function(t){t.name=t.name.replace(/\.geojson$/,"");var e=t.name.split("-");return{id:t.name,name:e[2].split("_").map(function(t){return t[0].toLocaleUpperCase()+t.substring(1,t.length)}).join(" "),country:e[0].toLocaleUpperCase(),state:e[1].toLocaleUpperCase(),download:t.download_url}})})},D=function(t){return k.get(t).then(function(t){return t.data})},G={components:{LMap:j["LMap"],LTileLayer:j["LTileLayer"],LGeoJson:j["LGeoJson"]},data:function(){return{center:[-33.95,151.2],url:"http://{s}.tile.osm.org/{z}/{x}/{y}.png",attribution:'&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',greenspaces:{},statistics:{},geojsons:[]}},methods:{refreshGeojsons:function(){this.greenspaces?this.geojsons=w["a"].filter(this.greenspaces,function(t){return t.displayed}).map(function(t){return t.geojson}):this.geojsons=[]},calcStats:function(){this.statistics={count:w["a"].keys(this.greenspaces).length,numCountries:w["a"].uniq(w["a"].map(this.greenspaces,function(t){return t.country})).length}},toggleVis:function(t){var e=this,n=!(arguments.length>1&&void 0!==arguments[1])||arguments[1],a=this.greenspaces[t];a.displayed||a.geojson?(n&&this.refreshGeojsons(),a.displayed=!a.displayed):D(a.download).then(function(t){a.geojson=t,a.displayed=!a.displayed,n&&e.refreshGeojsons()})}},mounted:function(){var t=this;$().then(function(e){var n=e.filter(function(t){return t.state.match(/NSW/)});e.forEach(function(e){e.displayed=!1,e.geojson=null,t.greenspaces[e.id]=e}),n.forEach(function(e,a){t.toggleVis(e.id,a==n.length-1)}),t.calcStats()})}},I=G,J=(n("mIwK"),Object(u["a"])(I,y,C,!1,null,null,null)),K=J.exports,M={name:"home",components:{"my-map":K}},S=M,U=Object(u["a"])(S,_,b,!1,null,null,null),P=U.exports,A=function(){var t=this,e=t.$createElement;t._self._c;return t._m(0)},R=[function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"about"},[n("h1",[t._v("This is an about page")])])}],V={},T=Object(u["a"])(V,A,R,!1,null,null,null),z=T.exports;a["a"].use(g["a"]);var q=new g["a"]({routes:[{path:"/",name:"home",component:P},{path:"/about",name:"about",component:z}]}),N=n("4R65"),Z=n.n(N);a["a"].config.productionTip=!1,delete Z.a.Icon.Default.prototype._getIconUrl,Z.a.Icon.Default.mergeOptions({iconRetinaUrl:n("WE1v"),iconUrl:n("Y5fm"),shadowUrl:n("4rkx")}),new a["a"]({router:q,render:function(t){return t(m)}}).$mount("#app")},ZL7j:function(t,e,n){"use strict";var a=n("bP1M"),s=n.n(a);s.a},bP1M:function(t,e,n){},mIwK:function(t,e,n){"use strict";var a=n("mpKJ"),s=n.n(a);s.a},mpKJ:function(t,e,n){}});
//# sourceMappingURL=app.965bca2b.js.map