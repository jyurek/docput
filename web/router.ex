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

    get "/", HomeController, :index
  end

  scope "/", Docput do
    pipe_through [:browser, Docput.Plugs.RequireLogin]

    get "/documents/new", DocumentController, :new
    post "/documents", DocumentController, :create
    delete "/documents/:id", DocumentController, :delete

    get "/revisions/:slug/:version", RevisionController, :show
    get "/revisions/new", RevisionController, :new
    post "/revisions", RevisionController, :create
    delete "/revisions/:id", RevisionController, :delete

    get "/layouts/new", DocumentLayoutController, :new
    get "/layouts/:id", DocumentLayoutController, :edit
    post "/layouts", DocumentLayoutController, :create
    put "/layouts/:id", DocumentLayoutController, :update
    delete "/layouts/:id", DocumentLayoutController, :delete

    get "/assets/new", AssetController, :new
    get "/assets/created", AssetController, :created
  end

  scope "/auth", Docput do
    pipe_through :browser

    get "/google", AuthController, :google
    get "/callback", AuthController, :callback
  end

  scope "/", Docput do
    pipe_through :browser

    delete "/sign_out", AuthController, :sign_out
  end
end
