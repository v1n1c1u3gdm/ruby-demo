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
        <p v-if="isLoading" class="feed__state">Carregando artigos...</p>

        <p v-else-if="error" class="feed__state feed__state--error">
          {{ error }}
        </p>

        <p v-else-if="!posts.length" class="feed__state">
          Nenhum artigo encontrado.
        </p>

        <template v-else>
          <article v-for="post in posts" :key="post.slug" class="feed__item">
            <header>
              <h2>
                <router-link :to="{ name: 'article', params: { slug: post.slug } }">
                  {{ post.title }}
                </router-link>
              </h2>
              <div class="post__meta">
                <time :datetime="post.datetime">{{ post.date }}</time>
              </div>
            </header>
            <p>{{ post.excerpt }}</p>
          </article>

          <nav class="pagination desc" aria-label="Paginação">
            <a
              class="btn"
              href="https://viniciusmenezes.com/page/2/"
              target="_blank"
              rel="noopener"
            >
              Previous
            </a>
          </nav>
        </template>
      </div>
    </template>
  </SiteLayout>
</template>

<script>
import SiteLayout from '@/components/SiteLayout.vue'
import { fetchArticles } from '@/services/articlesService'

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
      posts: [],
      isLoading: false,
      error: null
    }
  },
  created() {
    this.loadArticles()
  },
  methods: {
    async loadArticles() {
      this.isLoading = true
      this.error = null

      try {
        const articles = await fetchArticles()
        this.posts = articles.map(article => this.mapArticlePreview(article))
      } catch (err) {
        console.error(err)
        this.error = 'Não foi possível carregar os artigos. Tente novamente.'
      } finally {
        this.isLoading = false
      }
    },
    mapArticlePreview(article) {
      if (!article) return {}

      const datetime = article.created_at || article.updated_at || new Date().toISOString()
      return {
        id: article.id,
        slug: this.ensureSlug(article),
        title: article.title,
        date: article.published_label || this.formatDate(datetime),
        datetime,
        excerpt: this.truncateText(article.post_entry),
        url: article.url
      }
    },
    truncateText(text, limit = 200) {
      if (!text) return ''
      const normalized = text.trim()
      if (normalized.length <= limit) {
        return normalized
      }
      return `${normalized.slice(0, limit).trim()}…`
    },
    formatDate(value) {
      if (!value) return ''
      try {
        const date = new Date(value)
        return new Intl.DateTimeFormat('pt-BR', {
          weekday: 'long',
          day: 'numeric',
          month: 'long',
          year: 'numeric'
        }).format(date)
      } catch (err) {
        console.warn('Erro ao formatar data', err)
        return value
      }
    },
    ensureSlug(article) {
      if (article?.slug) return article.slug
      if (!article?.url) return ''
      try {
        const url = new URL(article.url)
        const segments = url.pathname.split('/').filter(Boolean)
        return segments.pop() || ''
      } catch (_) {
        return ''
      }
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

.feed__state {
  padding: 2rem 0;
  text-align: center;
  color: var(--gray-1);
  font-size: 0.95rem;
}

.feed__state--error {
  color: #b00020;
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

