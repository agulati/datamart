require 'resque/server'
require 'resque/scheduler/server'

Rails.application.routes.draw do
  mount Resque::Server.new, at: "/resque"

  resources :aggregations, only: [:index, :new, :create]
  resources :periods, only: [:index]

  root to: "aggregations#index"
end
