defmodule HelloWeb.Schema do
  use Absinthe.Schema

  # Define un tipo simple
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
  end

  # Define queries
  query do
    field :hello, :string do
      resolve fn _, _, _ ->
        {:ok, "¡Hola desde GraphQL!"}
      end
    end

    field :user, :user do
      arg :id, non_null(:id)
      resolve fn _, %{id: id}, _ ->
        # Datos de ejemplo
        {:ok, %{id: id, name: "Juan", email: "juan@email.com"}}
      end
    end
  end
end
