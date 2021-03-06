class ArticlesController < ApplicationController
  before_action :find_article, only: %i[destroy update edit]
  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
    @categories = Category.all
  end

  def create
    @article = current_user.articles.build(article_params)
    article_categories = params[:article][:category_ids]
    @categories = Category.all
    if article_categories.nil?
      flash[:error] = 'you should select at least one category'
      render 'new'
    elsif @article.save
      @article.image_element = ImageElement.new(image_params) unless image_params.empty?
      article_categories.each do |ac|
        category_of_article = @article.article_categories.build(category_id: ac)
        category_of_article.save
      end
      flash[:notice] = "The article #{@article.title} has been successfully created."
      redirect_to current_user
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @article.update_attributes(article_params)
      flash[:success] = 'Article was successfully updated'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to current_user
  end

  def destroy
    if @article.destroy
      flash[:success] = 'Article was successfully deleted.'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def article_params
    params.require(:article).permit(:title, :text)
  end

  def image_params
    params.require(:article).permit(:image)
  end

  def categories_params
    params.require(:article).permit(:category_ids)
  end

  def find_article
    @article = Article.find(params[:id])
  end
end
