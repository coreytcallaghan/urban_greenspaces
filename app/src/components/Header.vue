<template lang="pug">
section.hero.is-success
  .hero-head
    header.navbar
      .container
        .navbar-brand
          router-link(to='/').navbar-item
            .title
              span.fas.fa-dove
              |  Urban Greenspaces 
              span.fas.fa-tree 

          span.navbar-burger.burger(data-target='navbarMenuHeroC')
            span
            span
            span
        .navbar-menu
          .navbar-end
            router-link.navbar-item.is-size-4(to='/about') About
</template>

<script>
export default {

}
</script>
