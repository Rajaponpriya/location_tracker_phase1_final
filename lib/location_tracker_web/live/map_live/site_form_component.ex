defmodule LocationTrackerWeb.MapLive.SiteFormComponent do
  use LocationTrackerWeb, :live_component

  alias LocationTracker.Sites

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Add New Site
        <:subtitle>Use this form to add new sites to the map.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="site-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" required />
        <.input field={@form[:latitude]} type="number" label="Latitude" step="any" required />
        <.input field={@form[:longitude]} type="number" label="Longitude" step="any" required />

        <:actions>
          <.button phx-disable-with="Saving...">Submit Site</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:return_to, assigns[:return_to] || ~p"/")
     |> assign_new(:form, fn ->
       to_form(Sites.change_site(%LocationTracker.Sites.Site{}))
     end)}
  end

  @impl true
  def handle_event("validate", %{"site" => site_params}, socket) do
    changeset = Sites.change_site(%LocationTracker.Sites.Site{}, site_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"site" => site_params}, socket) do
    case Sites.create_site(site_params) do
      {:ok, site} ->
        notify_parent({:saved, site})

        socket = socket
        |> push_event("show-toast", %{message: "Site added successfully", type: "success"})
        |> push_event("js-exec", %{to: "#site-form-modal", attr: "phx-remove"})
        |> push_event("refresh-map", %{})
        |> push_redirect(to: socket.assigns.return_to || ~p"/")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
