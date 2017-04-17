defmodule Protox.DefineJsonEncoder do

  @moduledoc false
  # Internal. Generates the JSON encoder of a message.


  def define(fields) do
    make_encode(fields)
  end


  # -- Private


  defp make_encode([]) do
    quote do
      @spec encode_json(struct) :: String.t
      def encode_json(_msg), do: ""


      @spec prepare_for_json(struct) :: %{}
      def prepare_for_json(_msg), do: %{}
    end
  end
  defp make_encode(fields) do
    encode_fun_body   = make_encode_fun(fields)
    encode_field_funs = make_encode_field_funs(fields)

    quote do
      @spec encode_json(struct) :: String.t
      def encode_json(msg) do
        msg
        |> prepare_for_json()
        |> Poison.encode!()
      end


      @spec prepare_for_json(struct) :: %{}
      def prepare_for_json(msg) do
        unquote(encode_fun_body)
      end

      unquote(encode_field_funs)
    end
  end


  defp make_encode_fun([field | fields]) do
    {_, _, name, _, _} = field
    fun_name = String.to_atom("encode_json_#{name}")

    ast = quote do
      %{} |> unquote(fun_name)(msg)
    end
    make_encode_fun(ast, fields)
  end


  defp make_encode_fun(ast, []) do
    quote do
      unquote(ast)
    end
  end
  defp make_encode_fun(ast, [field | fields]) do
    {_, _, name, _, _} = field
    fun_name = String.to_atom("encode_json_#{name}")

    ast = quote do
      unquote(ast) |> unquote(fun_name)(msg)
    end
    make_encode_fun(ast, fields)
  end


  defp make_encode_field_funs(fields) do
    for {_, _, name, kind, type} <- fields do
      fun_name = String.to_atom("encode_json_#{name}")
      fun_ast  = make_encode_field_fun(kind, name, type)

      quote do
        defp unquote(fun_name)(acc, msg), do: unquote(fun_ast)
      end

    end
  end


  defp make_encode_field_fun({:default, default}, name, type) do
    field_var        = quote do: field_value
    encode_value_ast = get_encode_value_ast(type, field_var)

    quote do
      unquote(field_var) = msg.unquote(name)
      if unquote(field_var) == unquote(default) do
        acc
      else
        Map.put(acc, unquote(name), unquote(encode_value_ast))
      end
    end
  end
  # defp make_encode_field_fun({:oneof, parent_field}, name, type) do
  #   # TODO. We should look at the oneof field only once, not for each possible entry.

  #   key              = Protox.Encode.make_key_bytes(tag, type)
  #   var              = quote do: field_value
  #   encode_value_ast = get_encode_value_ast(type, var)

  #   quote do
  #     name = unquote(name)

  #     case msg.unquote(parent_field) do
  #       nil ->
  #         acc

  #       # The parent oneof field is set to the current field.
  #       {^name, field_value} ->
  #         [acc, unquote(key), unquote(encode_value_ast)]

  #       _ ->
  #        acc
  #     end
  #   end
  # end
  defp make_encode_field_fun(repeated, name, type)
  when repeated == :packed or repeated == :unpacked
  do
    encode_repeated_ast = make_encode_repeated_ast(type, name)

    quote do
      Map.put(acc, unquote(name), unquote(encode_repeated_ast))
    end
  end
  # defp make_encode_field_fun(:unpacked, tag, name, type) do
  #   encode_repeated_ast = make_encode_repeated_ast(tag, type)

  #   quote do
  #     case msg.unquote(name) do
  #       []     -> acc
  #       values -> [acc, unquote(encode_repeated_ast)]
  #     end
  #   end
  # end
  # defp make_encode_field_fun(:map, tag, name, type) do
  #   # Each key/value entry of a map has the same layout as a message.
  #   # https://developers.google.com/protocol-buffers/docs/proto3#backwards-compatibility

  #   key = Protox.Encode.make_key_bytes(tag, :map_entry)

  #   {map_key_type, map_value_type} = type

  #   k_var                = quote do: k
  #   v_var                = quote do: v
  #   encode_map_key_ast   = get_encode_value_ast(map_key_type, k_var)
  #   encode_map_value_ast = get_encode_value_ast(map_value_type, v_var)

  #   map_key_key_bytes   = Protox.Encode.make_key_bytes(1, map_key_type)
  #   map_value_key_bytes = Protox.Encode.make_key_bytes(2, map_value_type)
  #   map_keys_len        = byte_size(map_value_key_bytes) + byte_size(map_key_key_bytes)

  #   quote do
  #     map = Map.fetch!(msg, unquote(name))
  #     if map_size(map) == 0 do
  #       acc

  #     else
  #       Enum.reduce(map, acc,
  #         fn ({unquote(k_var), unquote(v_var)}, acc) ->

  #           map_key_value_bytes = [unquote(encode_map_key_ast)] |> :binary.list_to_bin()
  #           map_key_value_len   = byte_size(map_key_value_bytes)

  #           map_value_value_bytes = [unquote(encode_map_value_ast)] |> :binary.list_to_bin()
  #           map_value_value_len   = byte_size(map_value_value_bytes)

  #           len = Protox.Varint.encode(
  #             unquote(map_keys_len) +
  #             map_key_value_len +
  #             map_value_value_len
  #           )

  #           [
  #             acc,
  #             unquote(key),
  #             len,
  #             unquote(map_key_key_bytes),
  #             map_key_value_bytes,
  #             unquote(map_value_key_bytes),
  #             map_value_value_bytes
  #           ]
  #         end)
  #     end
  #   end
  # end
  defp make_encode_field_fun(_, _name, _type) do
    quote do
      acc
    end
  end


  defp make_encode_repeated_ast(type, field_name) do
    value_var = quote do: value
    encode_value_ast = get_encode_value_ast(type, value_var)

    quote do
      Enum.map(
        msg.unquote(field_name),
        fn (unquote(value_var)) ->
          unquote(encode_value_ast)
        end)
    end
  end


  defp get_encode_value_ast({:message, _}, field_var) do
    quote do
      encode_json_message(unquote(field_var))
    end
  end
  defp get_encode_value_ast({:enum, _}, field_var) do
    quote do
      encode_json_enum(unquote(field_var))
    end
  end
  defp get_encode_value_ast(type, var) do
    fun_name = String.to_atom("encode_json_#{type}")
    quote do
      unquote(fun_name)(unquote(var))
    end
  end

end
