defmodule ExOauth2Provider.ScopesTest do
  use ExUnit.Case
  import ExOauth2Provider.Scopes

  test "all?#true" do
    scopes = ["read", "write", "profile"]
    assert all?(scopes, ["read", "profile"])
    assert all?(scopes, ["write"])
    assert all?(scopes, [])
  end

  test "all?#false" do
    scopes = ["read", "write", "profile"]
    refute all?(scopes, ["read", "profile", "another_write"])
    refute all?(scopes, ["read", "write", "profile", "another_write"])
  end

  test "to_list" do
    str = "user:read,user:write,global_write"
    assert to_list(str) == ["user:read", "user:write", "global_write"]
  end

  test "to_string" do
    list = ["user:read", "user:write", "global_write"]
    assert ExOauth2Provider.Scopes.to_string(list) == "user:read,user:write,global_write"
  end
end
