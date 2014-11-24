class ApplicationController < ::ActionController::Base

  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?

  helper_method :warden, :posts, :active_experiments, :won_experiments

  def current_user
    warden.user
  end

  def signed_in?
    !warden.user.nil?
  end

  def posts
    @posts ||= Post.all
  end

  def active_experiments
    Split::Experiment.all.select { |e| not e.winner }
  end

  def won_experiments
    Split::Experiment.all.select { |e| e.winner }
  end

  protected

  def authenticate!
    warden.authenticate!
  end

  def warden
    env['warden']
  end
end
