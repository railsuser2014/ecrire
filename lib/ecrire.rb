module Ecrire

  autoload :Application,        'ecrire/application'

  def self.bundle?
    ENV['BUNDLE_GEMFILE'] ||= Dir.pwd + '/Gemfile'
    File.exists?(ENV['BUNDLE_GEMFILE'])
  end

  if Ecrire.bundle?
    require 'bundler/setup'
    require 'rails/all'
    Bundler.require(:default, :server, :assets, Rails.env)
  else
    require 'rails/all'
  end
end
