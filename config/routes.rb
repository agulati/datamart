require 'resque/server'
require 'resque/scheduler/server'

Rails.application.routes.draw do
  mount Resque::Server.new, at: "/resque"

  resources :aggregations, only: [:index, :new, :create]
  resources :periods, only: [:index]
  resources :logs, only: [:index, :show]

  root to: "aggregations#index"
end
