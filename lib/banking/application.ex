defmodule Banking.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Banking.Repo,
      # Start spear's eventstore wrapper
      Banking.EventStoreDB,
      # Start the Telemetry supervisor
      BankingWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Banking.PubSub},
      # Start the Endpoint (http/https)
      BankingWeb.Endpoint
      # Start a worker by calling: Banking.Worker.start_link(arg)
      # {Banking.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    Supervisor.start_link(children, strategy: :one_for_one, name: Banking.Supervisor)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BankingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
