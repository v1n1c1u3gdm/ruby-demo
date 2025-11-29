<template>
  <div class="layout-wrapper d-flex flex-column min-vh-100">
    <header class="site-header py-3 border-bottom bg-white">
      <div class="container-fluid d-flex justify-content-between align-items-center">
        <span></span>
        <b-button variant="outline-secondary" size="sm" @click="toggleSidebar">
          <b-icon icon="list"></b-icon>
        </b-button>
      </div>
    </header>

    <div class="flex-grow-1 d-flex flex-column flex-lg-row">
      <main class="primary-area flex-grow-1 d-flex">
        <aside class="hero-panel d-none d-md-flex" :style="heroPanelStyle">
          <div class="hero-overlay">
            <h1>Risadas, ódio e sangue</h1>
          </div>
        </aside>

        <section class="post-section flex-grow-1">
          <div class="hero-panel-mobile d-md-none mb-4" :style="heroPanelStyle">
            <div class="hero-overlay">
              <h1>Risadas, ódio e sangue</h1>
            </div>
          </div>

          <article
            v-for="post in posts"
            :key="post.title"
            class="post-card py-4 px-3 border-bottom bg-white rounded"
          >
            <header>
              <h2 class="post-title">
                <a :href="post.url" target="_blank" rel="noopener">
                  {{ post.title }}
                </a>
              </h2>
              <small class="text-muted">{{ post.date }}</small>
            </header>
            <p class="mt-2 mb-0 text-secondary">
              {{ post.excerpt }}
            </p>
          </article>

          <div class="text-right py-3 px-3">
            <b-button variant="outline-dark" size="sm" href="https://viniciusmenezes.com/page/2/" target="_blank" rel="noopener">
              Previous
            </b-button>
          </div>
        </section>
      </main>

      <aside :class="['nav-sidebar bg-white border-left', { collapsed: sidebarCollapsed }]">
        <nav class="nav flex-column">
          <a
            v-for="link in navLinks"
            :key="link.label"
            class="nav-link text-capitalize"
            :href="link.href"
            :target="link.external ? '_blank' : '_self'"
            rel="noopener"
          >
            {{ link.label }}
          </a>
        </nav>
      </aside>
    </div>

    <footer class="site-footer mt-auto py-3 border-top text-center bg-white">
      <div class="social-links mb-2">
        <a v-for="social in socials" :key="social.label" :href="social.href" target="_blank" rel="noopener">
          {{ social.label }}
        </a>
      </div>
      <small>Do primeiro e único... VGDM ®</small>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      sidebarCollapsed: true,
      hero: {
        title: 'Bem-vindo, Bienvenido, Welcome',
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
          excerpt: 'É o casamento certo; O trabalho certo As amizades certas A moto certa. A vida vale a pena',
          url: 'https://viniciusmenezes.com/como-e-bom-voltar-a-sentir-o-coracao-bater/'
        },
        {
          title: 'Sentimentos',
          date: 'Quarta-feira, 4 junho 2025',
          excerpt: '"Weltschmerz" (alemão para "dor do mundo") é um termo literário que descreve uma sensação de tristeza e cansaço diante da vida, causada pela percepção de que a…',
          url: 'https://viniciusmenezes.com/sentimentos/'
        },
        {
          title: 'Estatísticas "relevanciadas"',
          date: 'Sábado, 31 maio 2025',
          excerpt: 'Elevadas a relevantes',
          url: 'https://viniciusmenezes.com/estatisticas-relevanciadas/'
        },
        {
          title: 'Linux, git e... subsurface?',
          date: 'Quarta-feira, 21 maio 2025',
          excerpt: 'Engraçado as percepções sobre curva de adoção do git.',
          url: 'https://viniciusmenezes.com/linux-git-e-subsurface/'
        },
        {
          title: 'Desafio à Manu',
          date: 'Domingo, 4 maio 2025',
          excerpt: 'Fui um provento estatístico, uma improbabilidade tornada carne, um instante onde o acaso vestiu identidade. Consumi uma vida anterior — feita de histórias, erros, legados e moléculas…',
          url: 'https://viniciusmenezes.com/desafio-a-manu/'
        },
        {
          title: 'Dominando o domínio: usando dig e nslookup para diagnosticar DNS com precisão',
          date: 'Quinta-feira, 17 abril 2025',
          excerpt: 'Esse artigo faz parte de uma série de artigos que pretendo lançar no blog da empresa em que trabalho Na versão para pessoas não técnicas, explicamos que…',
          url: 'https://viniciusmenezes.com/dominando-o-dominio-usando-dig-e-nslookup-para-diagnosticar-dns-com-precisao/'
        },
        {
          title: 'Seu site aponta pro lugar certo? Descubra com nslookup',
          date: 'Quinta-feira, 17 abril 2025',
          excerpt: 'Esse artigo faz parte de uma série de artigos que pretendo lançar no blog da empresa em que trabalho Você contratou um domínio, pagou a hospedagem, o…',
          url: 'https://viniciusmenezes.com/seu-site-aponta-pro-lugar-certo-descubra-com-nslookup/'
        }
      ],
      socials: [
        { label: 'Twitter', href: 'https://twitter.com/v1n1c1u5gdm' },
        { label: 'Instagram', href: 'https://www.instagram.com/vm3n3z35/' },
        { label: 'LinkedIn', href: 'https://www.linkedin.com/in/menezesvinicius/' }
      ]
    }
  },
  methods: {
    toggleSidebar() {
      this.sidebarCollapsed = !this.sidebarCollapsed
    }
  },
  computed: {
    heroPanelStyle() {
      return {
        backgroundImage: `url(${this.hero.image})`
      }
    }
  }
}
</script>

<style scoped>
.layout-wrapper {
  background: #f5f5f5;
  color: #111;
  font-family: 'Inter', 'Helvetica', sans-serif;
}

.primary-area {
  width: 70%;
  padding: 0;
}

.hero-panel,
.hero-panel-mobile {
  width: 40%;
  min-height: 100%;
  background-size: cover;
  background-position: center;
  border-radius: 12px;
  margin-right: 1.5rem;
  position: relative;
  overflow: hidden;
}

.hero-panel::after,
.hero-panel-mobile::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 0.65) 100%);
}

.hero-panel-mobile {
  width: 100%;
  min-height: 320px;
  margin-right: 0;
}

.hero-overlay {
  position: relative;
  z-index: 1;
  width: 100%;
  padding: 2rem;
  display: flex;
  align-items: flex-end;
  height: 100%;
}

.hero-overlay h1 {
  color: #111;
  font-weight: 700;
  background: rgba(255, 255, 255, 0.7);
  padding: 0.5rem 1rem;
  border-radius: 6px;
}

.post-section {
  width: 60%;
}

.nav-sidebar {
  width: 30%;
  max-width: 340px;
  min-width: 240px;
  padding: 2rem 1rem;
  transition: transform 0.3s ease;
}

.nav-sidebar.collapsed {
  transform: translateX(100%);
  position: absolute;
  right: 0;
  top: 0;
  height: 100%;
  z-index: 1050;
  box-shadow: 0 0 30px rgba(0, 0, 0, 0.1);
}

.nav-sidebar .nav-link {
  color: #555;
}

.post-title a {
  color: #111;
  text-decoration: none;
}

.post-title a:hover {
  text-decoration: underline;
}

.social-links a {
  margin: 0 0.5rem;
  color: #555;
  text-decoration: none;
}

@media (max-width: 992px) {
  .primary-area {
    width: 100%;
    flex-direction: column;
  }

  .hero-panel {
    display: none;
  }

  .post-section {
    width: 100%;
  }
}
</style>
