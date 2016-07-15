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

    get "/documents/new", DocumentsController, :new
    post "/documents", DocumentsController, :create
    delete "/documents/:id", DocumentsController, :delete

    get "/revisions/:slug/:version", RevisionsController, :show
    get "/revisions/new", RevisionsController, :new
    post "/revisions", RevisionsController, :create
    delete "/revisions/:id", RevisionsController, :delete

    get "/layouts/new", LayoutsController, :new
    get "/layouts/:id", LayoutsController, :edit
    post "/layouts", LayoutsController, :create
    put "/layouts/:id", LayoutsController, :update
    delete "/layouts/:id", LayoutsController, :delete
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
