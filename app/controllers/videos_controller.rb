class VideosController < ApplicationController
  def index
    videos = Video.all.order(:title)
    render json: videos.as_json(only: [:id, :title, :release_date, :available_inventory, :overview]), status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])

    if video.nil?
      render json: {
        ok: false, 
        message: 'Not found',
      }, status: :not_found
      return
    end
      render json: video.as_json(only: [:id, :title, :overview, :release_date, :available_inventory])
    end

  def create
    video = Video.new(video_params)

    if video.save
      render json: video.as_json(only: [:id]), status: :created
      return
    else
      render json: {
        errors: video.errors.messages
      }, status: :bad_request
      return
    end
  end

  private
  def video_params
    return params.require(:video).permit(:title, :overview, :release_date, :total_inventory, :available_inventory)
  end
end
