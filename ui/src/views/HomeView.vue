<template>
  <SiteLayout>
    <template #main-left>
      <figure class="hero">
        <img :src="hero.image" :alt="hero.alt" loading="eager" />
        <div class="hero-overlay">
          <h1>{{ hero.title }}</h1>
          <hr class="divider" />
          <p class="hero-subtitle">{{ hero.subtitle }}</p>
        </div>
      </figure>
    </template>

    <template #main-right>
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

        <nav class="pagination desc" aria-label="Paginação">
          <a class="btn" href="https://viniciusmenezes.com/page/2/" target="_blank" rel="noopener">
            Previous
          </a>
        </nav>
      </div>
    </template>
  </SiteLayout>
</template>

<script>
import SiteLayout from '@/components/SiteLayout.vue'

export default {
  name: 'HomeView',
  components: {
    SiteLayout
  },
  data() {
    return {
      hero: {
        image: 'https://viniciusmenezes.com/media/website/IMG_20220624_123059.jpg',
        alt: 'Vinicius Menezes sorrindo e ouvindo música',
        title: 'Risadas, ódio e sangue',
        subtitle: 'Bem-vindo, Bienvenido, Welcome'
      },
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
          excerpt: '"Weltschmerz" (alemão para "dor do mundo") descreve a percepção de desalento diante da vida.',
          url: 'https://viniciusmenezes.com/sentimentos/'
        },
        {
          title: 'Estatísticas "relevanciadas"',
          date: 'Sábado, 31 maio 2025',
          datetime: '2025-05-31T19:35',
          excerpt: 'Elevadas a relevantes.',
          url: 'https://viniciusmenezes.com/estatisticas-relevanciadas/'
        },
        {
          title: 'Linux, git e... subsurface?',
          date: 'Quarta-feira, 21 maio 2025',
          datetime: '2025-05-21T14:43',
          excerpt: 'Percepções sobre curva de adoção do git.',
          url: 'https://viniciusmenezes.com/linux-git-e-subsurface/'
        },
        {
          title: 'Desafio à Manu',
          date: 'Domingo, 4 maio 2025',
          datetime: '2025-05-04T00:11',
          excerpt: 'Uma improbabilidade tornada carne, consumindo uma vida anterior de histórias.',
          url: 'https://viniciusmenezes.com/desafio-a-manu/'
        },
        {
          title: 'Dominando o domínio: usando dig e nslookup para diagnosticar DNS com precisão',
          date: 'Quinta-feira, 17 abril 2025',
          datetime: '2025-04-17T22:47',
          excerpt: 'Série sobre DNS com diagnósticos práticos usando dig e nslookup.',
          url: 'https://viniciusmenezes.com/dominando-o-dominio-usando-dig-e-nslookup-para-diagnosticar-dns-com-precisao/'
        },
        {
          title: 'Seu site aponta pro lugar certo? Descubra com nslookup',
          date: 'Quinta-feira, 17 abril 2025',
          datetime: '2025-04-17T22:40',
          excerpt: 'Checagem rápida para validar se o domínio aponta para o destino correto.',
          url: 'https://viniciusmenezes.com/seu-site-aponta-pro-lugar-certo-descubra-com-nslookup/'
        }
      ]
    }
  }
}
</script>

<style scoped>
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

@media (min-width: 992px) {
  .hero {
    height: 100vh;
  }
}
</style>

