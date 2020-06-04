defmodule E do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t :: integer | :FOO | :BAR | :BAZ | :NEG

  field(:FOO, 0)
  field(:BAR, 1)
  field(:BAZ, 2)
  field(:NEG, -1)
end

defmodule YYY do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Sub do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          a: integer,
          b: String.t(),
          c: integer,
          d: non_neg_integer,
          e: non_neg_integer,
          f: integer,
          g: [non_neg_integer],
          h: [integer],
          i: [float | :infinity | :negative_infinity | :nan],
          k: non_neg_integer,
          l: integer,
          m: binary,
          n: [boolean],
          o: [[E.t()]],
          r: E.t(),
          u: [non_neg_integer],
          w: [integer],
          x: [integer],
          y: [non_neg_integer],
          z: integer
        }
  defstruct [:a, :b, :c, :d, :e, :f, :g, :h, :i, :k, :l, :m, :n, :o, :r, :u, :w, :x, :y, :z]

  field(:a, 1, type: :int32)
  field(:b, 2, type: :string)
  field(:c, 6, type: :int64)
  field(:d, 7, type: :uint32)
  field(:e, 8, type: :uint64)
  field(:f, 9, type: :sint64)
  field(:g, 13, repeated: true, type: :fixed64)
  field(:h, 14, repeated: true, type: :sfixed32)
  field(:i, 15, repeated: true, type: :double)
  field(:k, 17, type: :fixed32)
  field(:l, 18, type: :sfixed64)
  field(:m, 19, type: :bytes)
  field(:n, 20, repeated: true, type: :bool)
  field(:o, 21, repeated: true, type: E, enum: true)
  field(:r, 24, type: E, enum: true)
  field(:u, 27, repeated: true, type: :uint32)
  field(:w, 28, repeated: true, type: :sint32)
  field(:x, 29, repeated: true, type: :int64)
  field(:y, 30, repeated: true, type: :uint64)
  field(:z, 10001, type: :sint32)
end

defmodule Msg.KEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: integer,
          value: String.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :int32)
  field(:value, 2, type: :string)
end

defmodule Msg.LEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: float | :infinity | :negative_infinity | :nan
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :double)
end

defmodule Msg.PEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: integer,
          value: E.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :int32)
  field(:value, 2, type: E, enum: true)
end

defmodule Msg do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          m: {atom, any},
          a: [integer],
          b: [non_neg_integer],
          c: [integer],
          d: E.t(),
          e: boolean,
          f: Sub.t() | nil,
          g: [integer],
          h: float | :infinity | :negative_infinity | :nan,
          i: [float | :infinity | :negative_infinity | :nan],
          j: [Sub.t()],
          k: [Msg.KEntry.t()],
          l: [Msg.LEntry.t()],
          p: [Msg.PEntry.t()]
        }
  defstruct [:m, :a, :b, :c, :d, :e, :f, :g, :h, :i, :j, :k, :l, :p]

  oneof(:m, 0)
  field(:a, 27, repeated: true, type: :sint64)
  field(:b, 28, repeated: true, type: :fixed32)
  field(:c, 29, repeated: true, type: :sfixed64)
  field(:d, 1, type: E, enum: true)
  field(:e, 2, type: :bool)
  field(:f, 3, type: Sub)
  field(:g, 4, repeated: true, type: :int32)
  field(:h, 5, type: :double)
  field(:i, 6, repeated: true, type: :float)
  field(:j, 7, repeated: true, type: Sub)
  field(:k, 8, repeated: true, type: Msg.KEntry)
  field(:l, 9, repeated: true, type: Msg.LEntry)
  field(:n, 10, type: :string, oneof: 0)
  field(:o, 11, type: Sub, oneof: 0)
  field(:p, 12, repeated: true, type: Msg.PEntry)
end

defmodule Upper.MapEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Msg.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Msg)
end

defmodule Upper do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          msg: Msg.t() | nil,
          map: [Upper.MapEntry.t()],
          empty: Empty.t() | nil
        }
  defstruct [:msg, :map, :empty]

  field(:msg, 1, type: Msg)
  field(:map, 2, repeated: true, type: Upper.MapEntry)
  field(:empty, 3, type: Empty)
end

defmodule Empty do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end
