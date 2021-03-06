defmodule TastyRecipesWeb.Html.RecipeLive.Index do
  use TastyRecipesWeb, :live_view

  alias TastyRecipes.Recipes
  alias TastyRecipes.Recipes.Recipe

  @impl true
  def mount(_params, session, socket) do
    assigns = [
      conn: socket,
      recipes: list_recipes(),
      current_user: Accounts.get_user_by_session_token(session["user_token"])
    ]

    {:ok, assigns}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Recipe")
    |> assign(:recipe, Recipes.get_recipe!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Recipe")
    |> assign(:recipe, %Recipe{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Recipes")
    |> assign(:recipe, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    recipe = Recipes.get_recipe!(id)
    {:ok, _} = Recipes.delete_recipe(recipe)

    {:noreply, assign(socket, :recipes, list_recipes())}
  end

  defp list_recipes do
    Recipes.list_recipes()
  end
end
