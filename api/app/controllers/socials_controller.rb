class SocialsController < ApplicationController
  before_action :set_social, only: %i[show update destroy]

  def index
    render json: Social.all
  end

  def show
    render json: @social
  end

  def create
    social = Social.new(social_params)
    if social.save
      render json: social, status: :created
    else
      render json: { errors: social.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @social.update(social_params)
      render json: @social
    else
      render json: { errors: @social.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @social.destroy
    head :no_content
  end

  private

  def set_social
    @social = Social.find(params[:id])
  end

  def social_params
    params.require(:social).permit(:profile_link, :slug, :description, :author_id)
  end
end

