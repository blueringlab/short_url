defmodule ShortUrlWeb.Router do
  use ShortUrlWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShortUrlWeb do
    pipe_through :browser
    get "/", PageController, :index
    get "/:hash", PageController, :forward_url
  end

  scope "/api/url", ShortUrlWeb do
    pipe_through :api
    get "/:hash", UrlController, :get_url
    post "/", UrlController, :create_url
  end

  scope "/", ShortUrlWeb do
    pipe_through :browser
    get "/*path", PageController, :not_found
  end
end
