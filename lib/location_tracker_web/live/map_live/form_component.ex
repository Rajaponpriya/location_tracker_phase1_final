defmodule LocationTrackerWeb.MapLive.FormComponent do
  use LocationTrackerWeb, :live_component

  alias LocationTracker.Sites

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage map records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="map-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Map</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{map: map} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Sites.change_map(map))
     end)}
  end

  @impl true
  def handle_event("validate", %{"map" => map_params}, socket) do
    changeset = Sites.change_map(socket.assigns.map, map_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"map" => map_params}, socket) do
    save_map(socket, socket.assigns.action, map_params)
  end

  defp save_map(socket, :edit, map_params) do
    case Sites.update_map(socket.assigns.map, map_params) do
      {:ok, map} ->
        notify_parent({:saved, map})

        {:noreply,
         socket
         |> put_flash(:info, "Map updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_map(socket, :new, map_params) do
    case Sites.create_map(map_params) do
      {:ok, map} ->
        notify_parent({:saved, map})

        {:noreply,
         socket
         |> put_flash(:info, "Map created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
