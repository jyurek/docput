defmodule Docput.Router do
  use Docput.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    if Mix.env == :dev || Mix.env == :test do
      plug Docput.Plugs.SetUserIdFromParams
    end

    plug Docput.Plugs.FetchCurrentUser
  end

  scope "/", Docput do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", Docput do
    pipe_through [:browser, Docput.Plugs.RequireLogin]

    get "/documents", DocumentsController, :index
    get "/documents/new", DocumentsController, :new
    post "/documents", DocumentsController, :create

    get "/templates/new", TemplatesController, :new
    post "/templates", TemplatesController, :create
  end

  scope "/auth", Docput do
    pipe_through :browser

    get "/google", AuthController, :google
    get "/callback", AuthController, :callback
  end

  scope "/", Docput do
    pipe_through :browser

    get "/sign_out", AuthController, :sign_out
  end
end
