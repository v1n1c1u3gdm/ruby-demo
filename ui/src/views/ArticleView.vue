<template>
  <SiteLayout>
    <template #main-left>
      <figure class="hero">
        <img
          :src="article.heroImage"
          :alt="article.heroAlt"
          loading="eager"
        />
        <span class="sr-only">{{ article.title }}</span>
      </figure>
      <header class="article-hero-header">
        <h1>{{ article.title }}</h1>
        <p>
          <time :datetime="article.datetime">{{ article.dateLabel }}</time>
          by
          <a :href="article.author.url" rel="author" target="_blank">
            {{ article.author.name }}
          </a>
        </p>
      </header>
    </template>

    <template #main-right>
      <article class="post">
        <div class="post__entry">
          <p
            v-for="(paragraph, index) in article.content"
            :key="`paragraph-${index}`"
            v-html="paragraph"
          />
        </div>

        <footer>
          <div class="post__tag-share">
            <div class="post__share" aria-label="Compartilhar artigo">
              <a
                v-for="share in shareLinks"
                :key="share.label"
                :href="share.href"
                class="share-link"
                target="_blank"
                rel="nofollow noopener noreferrer"
                :aria-label="share.label"
              >
                <i :class="share.icon"></i>
              </a>
            </div>
          </div>
        </footer>
      </article>
    </template>
  </SiteLayout>
</template>

<script>
import SiteLayout from '@/components/SiteLayout.vue'

export default {
  name: 'ArticleView',
  components: {
    SiteLayout
  },
  data() {
    return {
      article: {
        title: 'Como é bom voltar a sentir o coração bater',
        heroImage: 'https://viniciusmenezes.com/media/website/IMG_20220624_123059.jpg',
        heroAlt: 'Foto do autor sorrindo de óculos',
        dateLabel: 'Domingo, 24 agosto 2025',
        datetime: '2025-08-24T01:40',
        author: {
          name: 'Vinicius G. D. Menezes',
          url: 'https://viniciusmenezes.com/authors/vinicius-menezes/'
        },
        content: [
          'É o casamento certo;',
          'O trabalho certo',
          'As amizades certas',
          'A moto certa.<br><br>A vida vale a pena'
        ]
      },
      shareLinks: [
        {
          label: 'Compartilhar no Twitter',
          icon: 'fab fa-twitter',
          href: 'https://twitter.com/share?url=https%3A%2F%2Fviniciusmenezes.com%2Fcomo-e-bom-voltar-a-sentir-o-coracao-bater%2F&via=v1n1c1u5gdm&text=Como%20%C3%A9%20bom%20voltar%20a%20sentir%20o%20cora%C3%A7%C3%A3o%20bater'
        },
        {
          label: 'Compartilhar no LinkedIn',
          icon: 'fab fa-linkedin',
          href: 'https://www.linkedin.com/sharing/share-offsite/?url=https%3A%2F%2Fviniciusmenezes.com%2Fcomo-e-bom-voltar-a-sentir-o-coracao-bater%2F'
        },
        {
          label: 'Compartilhar no WhatsApp',
          icon: 'fab fa-whatsapp',
          href: 'https://api.whatsapp.com/send?text=Como%20%C3%A9%20bom%20voltar%20a%20sentir%20o%20cora%C3%A7%C3%A3o%20bater%20https%3A%2F%2Fviniciusmenezes.com%2Fcomo-e-bom-voltar-a-sentir-o-coracao-bater%2F'
        }
      ]
    }
  }
}
</script>

<style scoped>
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

.hero {
  margin: 0;
  height: var(--hero-height);
  position: relative;
}

.hero::after {
  content: '';
  position: absolute;
  inset: 0;
  background: var(--hero-overlay);
}

.hero img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.article-hero-header {
  color: var(--hero-text-color);
  padding: calc(var(--navbar-height) + 2rem) 4% 4%;
  position: relative;
}

.article-hero-header p {
  margin-top: 0.75rem;
  color: var(--white);
}

.article-hero-header a {
  color: var(--white);
  text-decoration: underline;
}

.post {
  color: var(--text-color);
}

.post__entry p {
  margin-top: 1.5rem;
  font-size: 1.05rem;
}

.post__entry p:first-of-type {
  margin-top: 0;
}

.post__tag-share {
  display: flex;
  justify-content: flex-end;
  margin-top: 3rem;
}

.post__share {
  white-space: nowrap;
}

.share-link {
  padding: 0 0.35rem;
  font-size: 1rem;
  color: var(--gray-1);
}

.share-link:hover {
  color: var(--color);
}

.share-link i {
  pointer-events: none;
}

@media (min-width: 992px) {
  .hero {
    height: 100vh;
  }

  .article-hero-header {
    position: absolute;
    top: calc(var(--navbar-height) + 3.75rem);
    left: 4%;
    right: 4%;
  }
}
</style>

