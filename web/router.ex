defmodule Docput.Router do
  use Docput.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Docput.Plugs.FetchCurrentUser
  end

  scope "/", Docput do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", Docput do
    pipe_through [:browser, Docput.Plugs.RequireLogin]

    get "/documents", DocumentsController, :index
  end

  scope "/auth", Docput do
    pipe_through :browser

    get "/", AuthController, :index
    get "/sign_out", AuthController, :sign_out
    get "/callback", AuthController, :callback
  end
end
