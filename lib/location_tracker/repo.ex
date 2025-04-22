defmodule LocationTracker.Repo do
  use Ecto.Repo,
    otp_app: :location_tracker,
    adapter: Ecto.Adapters.Postgres
end
