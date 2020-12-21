# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: "rails/conductor/full_request_logger" do
    resources :request_logs, only: %i[ index create show ], as: :rails_conductor_request_logs
  end
end
