<template lang="pug">
section.hero.is-success
  .hero-head
    header.navbar
      .container
        .navbar-brand
          router-link(to='/').navbar-item
            .title.is-3
              span.fas.fa-dove
              |  Greenspace bird calculator
              span.fas.fa-tree
            
          span.navbar-burger.burger(data-target='navbarMenuHeroC')
            span
            span
            span
        .navbar-menu
          .navbar-end
            router-link.navbar-item.is-size-4(to='/about') About
            a.navbar-item.is-size-4(href='https://github.com/coreytcallaghan/urban_greenspaces/')
              span.fab.fa-github
</template>

<script>
export default {

}
</script>
