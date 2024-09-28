defmodule Jungle.Repo do
  use Ecto.Repo,
    otp_app: :jungle,
    adapter: Ecto.Adapters.Postgres
end
