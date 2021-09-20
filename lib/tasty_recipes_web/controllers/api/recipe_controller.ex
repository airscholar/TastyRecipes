defmodule TastyRecipesWeb.Api.RecipeController do
  use TastyRecipesWeb, :controller

  alias TastyRecipes.Accounts
  alias TastyRecipes.Accounts.User

  alias TastyRecipes.Guardian

  def create(conn, %{"recipe" => recipe_params}) do
    with {:ok, recipe} <-
           Recipes.create_recipe(Map.put(recipe_params, "owner", conn.assigns.current_user.id)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_recipe_path(conn, :show, recipe))
      |> render("show.json", recipe: recipe)
    end
  end
end
