defmodule Amrita.Repo do
  use Ecto.Repo,
    otp_app: :amrita,
    adapter: Ecto.Adapters.Postgres
end
