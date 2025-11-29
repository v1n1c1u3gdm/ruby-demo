<template>
  <div :class="['layout-wrapper js-container', { 'is-menu': isMenuOpen }]">
    <nav class="menu" aria-label="Menu lateral">
      <ul class="navbar__menu">
        <li
          v-for="link in navLinks"
          :key="link.label"
          :class="{ active: link.active }"
        >
          <a
            :href="link.href"
            :target="link.external ? '_blank' : '_self'"
            rel="noopener"
            @click="handleMenuLinkClick"
          >
            {{ link.label }}
          </a>
        </li>
      </ul>
    </nav>

    <div class="content">
      <header class="top">
        <div class="top__item" aria-hidden="true"></div>

        <div class="top__item top__item--right">
          <button
            type="button"
            class="menu-toggle js-menu-toggle"
            :class="{ 'is-active': isMenuOpen }"
            aria-label="Menu"
            :aria-expanded="isMenuOpen ? 'true' : 'false'"
            @click.prevent="handleMenuToggle"
          >
            <span class="menu-toggle-box">
              <span class="menu-toggle-inner">Menu</span>
            </span>
          </button>
        </div>
      </header>

      <main class="main">
        <div class="main__left">
          <figure class="hero">
            <img :src="hero.image" alt="Vinicius Menezes" loading="eager" />
            <div class="hero-overlay">
              <h1>Risadas, ódio e sangue</h1>
              <hr class="divider" />
              <p class="hero-subtitle">Bem-vindo, Bienvenido, Welcome</p>
            </div>
          </figure>
        </div>

        <div class="main__right">
          <div class="feed">
            <article
              v-for="post in posts"
              :key="post.title"
              class="feed__item"
            >
              <header>
                <h2>
                  <a :href="post.url" target="_blank" rel="noopener">
                    {{ post.title }}
                  </a>
                </h2>
                <div class="post__meta">
                  <time :datetime="post.datetime">{{ post.date }}</time>
                </div>
              </header>
              <p>{{ post.excerpt }}</p>
            </article>

            <nav class="pagination desc">
              <a class="btn" href="https://viniciusmenezes.com/page/2/" target="_blank" rel="noopener">
                Previous
              </a>
            </nav>
          </div>

          <footer class="footer">
            <div class="footer__copyright">
              Do primeiro e único... VGDM ®
            </div>
            <div class="footer__social">
              <a
                v-for="social in socials"
                :key="social.label"
                :href="social.href"
                :class="['social-icon', social.variant]"
                target="_blank"
                rel="noopener"
                :aria-label="social.label"
              >
                <i :class="social.icon"></i>
              </a>
            </div>
          </footer>
        </div>
      </main>
    </div>
  </div>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      isMenuOpen: false,
      hero: {
        image: 'https://viniciusmenezes.com/media/website/IMG_20220624_123059.jpg'
      },
      navLinks: [
        { label: 'inicio', href: 'https://viniciusmenezes.com/', active: true },
        { label: 'profissional', href: 'https://www.linkedin.com/in/menezesvinicius/', external: true },
        { label: 'sobre', href: 'https://viniciusmenezes.com/authors/vinicius-menezes/' },
        { label: 'postagens por tipo', href: 'https://viniciusmenezes.com/tags/' },
        { label: 'drive', href: 'https://viniciusmenezes.com/share/' },
        { label: 'estudos', href: 'https://viniciusmenezes.com/bookstack', external: true }
      ],
      posts: [
        {
          title: 'Como é bom voltar a sentir o coração bater',
          date: 'Domingo, 24 agosto 2025',
          datetime: '2025-08-24T01:40',
          excerpt: 'É o casamento certo; O trabalho certo As amizades certas A moto certa. A vida vale a pena',
          url: 'https://viniciusmenezes.com/como-e-bom-voltar-a-sentir-o-coracao-bater/'
        },
        {
          title: 'Sentimentos',
          date: 'Quarta-feira, 4 junho 2025',
          datetime: '2025-06-04T23:08',
          excerpt: '"Weltschmerz" (alemão para "dor do mundo") é um termo literário que descreve uma sensação de tristeza e cansaço diante da vida, causada pela percepção de que a…',
          url: 'https://viniciusmenezes.com/sentimentos/'
        },
        {
          title: 'Estatísticas "relevanciadas"',
          date: 'Sábado, 31 maio 2025',
          datetime: '2025-05-31T19:35',
          excerpt: 'Elevadas a relevantes',
          url: 'https://viniciusmenezes.com/estatisticas-relevanciadas/'
        },
        {
          title: 'Linux, git e... subsurface?',
          date: 'Quarta-feira, 21 maio 2025',
          datetime: '2025-05-21T14:43',
          excerpt: 'Engraçado as percepções sobre curva de adoção do git.',
          url: 'https://viniciusmenezes.com/linux-git-e-subsurface/'
        },
        {
          title: 'Desafio à Manu',
          date: 'Domingo, 4 maio 2025',
          datetime: '2025-05-04T00:11',
          excerpt: 'Fui um provento estatístico, uma improbabilidade tornada carne, um instante onde o acaso vestiu identidade. Consumi uma vida anterior — feita de histórias, erros, legados e moléculas…',
          url: 'https://viniciusmenezes.com/desafio-a-manu/'
        },
        {
          title: 'Dominando o domínio: usando dig e nslookup para diagnosticar DNS com precisão',
          date: 'Quinta-feira, 17 abril 2025',
          datetime: '2025-04-17T22:47',
          excerpt: 'Esse artigo faz parte de uma série de artigos que pretendo lançar no blog da empresa em que trabalho Na versão para pessoas não técnicas, explicamos que…',
          url: 'https://viniciusmenezes.com/dominando-o-dominio-usando-dig-e-nslookup-para-diagnosticar-dns-com-precisao/'
        },
        {
          title: 'Seu site aponta pro lugar certo? Descubra com nslookup',
          date: 'Quinta-feira, 17 abril 2025',
          datetime: '2025-04-17T22:40',
          excerpt: 'Esse artigo faz parte de uma série de artigos que pretendo lançar no blog da empresa em que trabalho Você contratou um domínio, pagou a hospedagem, o…',
          url: 'https://viniciusmenezes.com/seu-site-aponta-pro-lugar-certo-descubra-com-nslookup/'
        }
      ],
      socials: [
        { label: 'Twitter', href: 'https://twitter.com/v1n1c1u5gdm', icon: 'fab fa-twitter', variant: 'twitter' },
        { label: 'Instagram', href: 'https://www.instagram.com/vm3n3z35/', icon: 'fab fa-instagram', variant: 'instagram' },
        { label: 'LinkedIn', href: 'https://www.linkedin.com/in/menezesvinicius/', icon: 'fab fa-linkedin', variant: 'linkedin' }
      ]
    }
  },
  methods: {
    handleMenuToggle() {
      this.isMenuOpen = !this.isMenuOpen
    },
    handleMenuLinkClick() {
      this.isMenuOpen = false
    },
    setBodyScrollState(active) {
      if (typeof document === 'undefined') return
      document.body.classList.toggle('no-scroll', active)
    }
  },
  watch: {
    isMenuOpen(value) {
      this.setBodyScrollState(value)
    }
  },
  mounted() {
    this.setBodyScrollState(this.isMenuOpen)
  },
  beforeDestroy() {
    this.setBodyScrollState(false)
  }
}
</script>

<style scoped>
.layout-wrapper {
  position: relative;
  min-height: 100vh;
  background: var(--white);
  color: var(--text-color);
}

.menu {
  position: fixed;
  top: 0;
  right: 0;
  width: var(--side-nav-width);
  height: 100vh;
  background: var(--side-nav-bg);
  padding: 2rem;
  overflow-y: auto;
  transform: translateX(var(--side-nav-width));
  transition: transform 0.3s ease;
  z-index: 2100;
}

.layout-wrapper.is-menu .menu {
  transform: translateX(0);
}

.navbar__menu {
  list-style: none;
  margin: 0;
  padding: 0;
}

.navbar__menu li {
  color: var(--side-nav-link);
  font-family: var(--menu-font);
  letter-spacing: 1px;
  padding: 0.35rem 0;
  text-transform: uppercase;
}

.navbar__menu li a {
  color: inherit;
}

.navbar__menu li a:hover,
.navbar__menu li.active a {
  color: var(--side-nav-link-hover);
  text-decoration: none;
}

.content {
  min-height: 100vh;
  background: var(--white);
  transition: transform 0.5s cubic-bezier(0, 0.98, 1, 1);
  will-change: transform;
  overflow-x: hidden;
}

.layout-wrapper.is-menu .content {
  transform: translateX(calc(-1 * var(--side-nav-width)));
}

.top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem 4%;
  position: relative;
  z-index: 3;
  border-bottom: 1px solid var(--hero-border-color);
  color: var(--white);
}

.logo {
  color: inherit;
  font-weight: var(--headings-weight);
  text-transform: uppercase;
  text-decoration: none;
}

.top__item {
  display: flex;
  align-items: center;
}

.top__item--right {
  justify-content: flex-end;
}

.menu-toggle {
  background: transparent;
  border: none;
  cursor: pointer;
  padding: 0;
  width: 1.5rem;
  height: 1.5rem;
  position: relative;
  z-index: 2200;
}

.menu-toggle-box {
  width: 1.5rem;
  height: 16px;
  display: inline-block;
  position: relative;
}

.menu-toggle-inner,
.menu-toggle-inner::before,
.menu-toggle-inner::after {
  width: 1.5rem;
  height: 2px;
  background-color: var(--white);
  position: absolute;
  transition: transform 0.15s ease, opacity 0.15s ease, top 0.15s ease, bottom 0.15s ease;
}

.menu-toggle-inner {
  top: 50%;
  transform: translateY(-50%);
  text-indent: -9999px;
}

.menu-toggle-inner::before,
.menu-toggle-inner::after {
  content: '';
  left: 0;
}

.menu-toggle-inner::before {
  top: -6px;
}

.menu-toggle-inner::after {
  bottom: -6px;
}

.menu-toggle.is-active .menu-toggle-inner {
  transform: rotate(45deg);
}

.menu-toggle.is-active .menu-toggle-inner::before {
  top: 0;
  opacity: 0;
}

.menu-toggle.is-active .menu-toggle-inner::after {
  bottom: 0;
  transform: rotate(-90deg);
}

.main {
  display: flex;
  flex-direction: column;
}

.main__left {
  position: relative;
}

.hero {
  height: 420px;
  margin: 0;
  position: relative;
}

.hero img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.hero-overlay {
  position: absolute;
  inset: 0;
  background: var(--hero-overlay);
  padding: 2rem;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
}

.hero-overlay h1 {
  color: var(--white);
  font-weight: var(--headings-weight);
  margin-bottom: 0.5rem;
}

.divider {
  border-top: 1px solid rgba(255, 255, 255, 0.3);
  width: 100%;
  margin: 1rem 0;
}

.hero-subtitle {
  color: var(--white);
  font-size: 1rem;
  margin: 0;
}

.main__right {
  padding: 2rem 4%;
  background: var(--white);
  color: var(--text-color);
}

.feed__item {
  padding-bottom: 3rem;
  border-bottom: 1px solid var(--lighter);
}

.feed__item:last-of-type {
  border-bottom: none;
}

.feed__item h2 a {
  color: var(--headings-color);
}

.feed__item h2 a:hover {
  color: var(--color);
  text-decoration: none;
}

.post__meta {
  color: var(--gray-1);
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.pagination {
  margin-top: 2rem;
}

.btn {
  border: 1px solid var(--gray-2);
  color: var(--dark);
  padding: 0.5rem 1.5rem;
  text-transform: uppercase;
  font-size: 0.75rem;
  background: transparent;
}

.btn:hover {
  border-color: var(--color);
  color: var(--color);
  text-decoration: none;
}

.footer {
  border-top: 1px solid var(--lighter);
  margin-top: 3rem;
  padding-top: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
}

.footer__social .social-icon {
  margin-right: 0.75rem;
  color: var(--gray-2);
  font-size: 1rem;
}

.footer__social {
  display: flex;
  align-items: center;
  margin-left: auto;
}

.footer__social .social-icon:last-child {
  margin-right: 0;
}

.footer__social .social-icon:hover {
  color: var(--color);
}

.footer__copyright {
  color: var(--dark);
  font-size: 0.7rem;
  letter-spacing: 1px;
  text-transform: uppercase;
}

@media (max-width: 768px) {
  .footer {
    flex-direction: column;
    align-items: flex-start;
  }

  .footer__social {
    margin-left: 0;
  }
}

@media (max-width: 991.98px) {
  .layout-wrapper.is-menu {
    transform: none;
  }

  .menu {
    width: 100%;
    max-width: 100%;
  }
}

@media (min-width: 992px) {
  .layout-wrapper {
    height: 100vh;
    overflow: hidden;
  }

  .content {
    height: 100vh;
    overflow: hidden;
  }

  .top {
    position: fixed;
    width: 60%;
    right: 0;
    padding: 1.5rem 6%;
    background: var(--white);
    border-bottom: 1px solid var(--hero-border-color);
    color: var(--dark);
  }

  .logo {
    color: var(--dark);
  }

  .menu-toggle-inner,
  .menu-toggle-inner::before,
  .menu-toggle-inner::after {
    background-color: var(--black);
  }

  .main {
    min-height: 100vh;
  }

  .main__left {
    position: fixed;
    top: 0;
    left: 0;
    width: 40vw;
    height: 100vh;
  }

  .hero {
    height: 100%;
  }

  .main__right {
    margin-left: 40vw;
    padding: calc(var(--navbar-height) + 3.75rem) 6% 3rem;
    height: 100vh;
    overflow-y: auto;
  }
}
</style>
