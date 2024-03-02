# Define a common domain by using defprotocol.
# It is difficult to predict the future, but defprotocol ensures scalability.
defprotocol Role do
  @type t :: t()

  @spec get_role_name(t) :: String.t()
  def get_role_name(role)

  @spec get_permissions(t) :: list()
  def get_permissions(role)
end

# Extend processing for each DSL using defimpl, which is similar to Java's inheritance.
# Each module is independent, minimizing the scope of impact of the modification.
defmodule AdministratorRole do
  @type t :: Role.t()

  @enforce_keys [:role_name]
  defstruct [:role_name]

  defimpl Role do
    @spec get_role_name(AdministratorRole.t()) :: String.t()
    def get_role_name(role), do: role.role_name

    @spec get_permissions(AdministratorRole.t()) :: list()
    def get_permissions(_role), do: [:admin]
  end
end

# Easily expandable for future specification changes.
defmodule AdministratorRoleV2 do
  @type t :: Role.t()

  @enforce_keys [:role_name, :permissions]
  defstruct [:role_name, :permissions]

  defimpl Role do
    @spec get_role_name(AdministratorRoleV2.t()) :: String.t()
    def get_role_name(role), do: role.role_name

    @spec get_permissions(AdministratorRoleV2.t()) :: list()
    def get_permissions(role), do: role.permissions
  end
end

defmodule DeveloperRole do
  @type t :: Role.t()

  @enforce_keys [:role_name]
  defstruct [:role_name]

  defimpl Role do
    @spec get_role_name(DeveloperRole.t()) :: String.t()
    def get_role_name(role), do: role.role_name

    @spec get_permissions(DeveloperRole.t()) :: list()
    def get_permissions(_role), do: [:developer]
  end
end

defmodule GuestRole do
  @type t :: Role.t()

  @enforce_keys [:role_name]
  defstruct [:role_name]

  defimpl Role do
    @spec get_role_name(GuestRole.t()) :: String.t()
    def get_role_name(role), do: role.role_name

    @spec get_permissions(GuestRole.t()) :: list()
    def get_permissions(_role), do: [:guest]
  end
end

defmodule Main do
  @spec run() :: :ok
  def run() do
    roles = [
      %AdministratorRole{role_name: "administrator"},
      %AdministratorRoleV2{role_name: "administrator", permissions: [:admin]},
      %DeveloperRole{role_name: "developer"}
    ]

    # Since the base type is the same, there is no need to change the implementation code.
    Enum.each(roles, fn role ->
      Role.get_role_name(role)
      |> dbg()

      Role.get_permissions(role)
      |> dbg()
    end)

    :ok
  end
end
