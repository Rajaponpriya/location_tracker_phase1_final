defmodule LocationTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LocationTrackerWeb.Telemetry,
      LocationTracker.Repo,
      {DNSCluster, query: Application.get_env(:location_tracker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LocationTracker.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LocationTracker.Finch},
      # Start a worker by calling: LocationTracker.Worker.start_link(arg)
      # {LocationTracker.Worker, arg},
      # Start to serve requests, typically the last entry
      LocationTrackerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LocationTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LocationTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
