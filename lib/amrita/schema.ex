defmodule Amrita.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, :binary_id, auto_generate: true}
      @foreign_key_type :binary_id
      @derive{Phoenix.Param, key: :id}
    end
  end
end
