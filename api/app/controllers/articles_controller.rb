class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show update destroy]

  def index
    articles = Article.all
    render json: articles
  end

  def show
    render json: @article
  end

  def create
    article = Article.new(article_params)
    if article.save
      render json: article, status: :created
    else
      render json: { errors: article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    head :no_content
  end

  def count_by_author
    counts = Author
               .left_outer_joins(:articles)
               .group('authors.id')
               .order('authors.name ASC')
               .select('authors.id, authors.name, COUNT(articles.id) AS articles_count')

    payload = counts.map do |author|
      {
        author_id: author.id,
        author_name: author.name,
        articles_count: author.attributes['articles_count'].to_i
      }
    end

    render json: payload
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :slug, :published_label, :post_entry, :author_id, tags: [])
  end
end

