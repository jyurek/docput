ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Docput.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Docput.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Docput.Repo)

