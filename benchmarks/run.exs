# -------------------------------------------------------------------------------------------------#

defmodule Protox.Benchmarks do
  @external_resource "./benchmarks/benchmarks.proto"
  use Protox, files: ["./benchmarks/benchmarks.proto"], namespace: Protox.Benchmarks
end

Code.compile_file("./benchmarks/benchmarks.pb.exs")

# -------------------------------------------------------------------------------------------------#

defmodule Benchmark do
  def decode(:protox, iterations, %{protox: mod, bytes: bytes}) do
    for _ <- 1..iterations, do: mod.decode(bytes)
  end

  def decode(:exprotobuf, iterations, %{exprotobuf: mod, bytes: bytes}) do
    for _ <- 1..iterations, do: mod.decode(bytes)
  end

  def decode(:protobuf, iterations, %{protobuf: mod, bytes: bytes}) do
    for _ <- 1..iterations, do: mod.decode(bytes)
  end

  def encode(:protox, iterations, %{protox: msg}) do
    for _ <- 1..iterations, do: Protox.Encode.encode(msg)
  end

  # def encode(:exprotobuf, iterations, %{exprotobuf: msg}) do
  #   for _ <- 1..iterations, do: Protobuf.Serializable.serialize(msg)
  # end

  def encode(:protobuf, iterations, %{protobuf: msg}) do
    for _ <- 1..iterations, do: msg.__struct__.encode(msg)
  end
end

# -------------------------------------------------------------------------------------------------#

defmodule Data do


  def decode_inputs() do
    [
      %{
        protox: Protox.Benchmarks.Sub,
        exprotobuf: Exprotobuf.Bench.Sub,
        protobuf: Sub,
        bytes: <<8, 150, 1>>
      },
      %{
        protox: Protox.Benchmarks.Sub,
        exprotobuf: Exprotobuf.Bench.Sub,
        protobuf: Sub,
        bytes: <<8, 234, 254, 255, 255, 255, 255, 255, 255, 255, 1>>
      },
      %{
        protox: Protox.Benchmarks.Sub,
        exprotobuf: Exprotobuf.Bench.Sub,
        protobuf: Sub,
        bytes: <<18, 7, 116, 101, 115, 116, 105, 110, 103>>
      },
      %{
        protox: Protox.Benchmarks.Sub,
        exprotobuf: Exprotobuf.Bench.Sub,
        protobuf: Sub,
        bytes: <<8, 150, 1, 18, 7, 116, 101, 115, 116, 105, 110, 103>>
      },
      %{
        protox: Protox.Benchmarks.Sub,
        exprotobuf: Exprotobuf.Bench.Sub,
        protobuf: Sub,
        bytes: <<8, 150, 1, 18, 7, 116, 101, 115, 116, 105, 110, 103, 136, 241, 4, 157, 156, 1>>
      },
      %{
        protox: Protox.Benchmarks.Sub,
        exprotobuf: Exprotobuf.Bench.Sub,
        protobuf: Sub,
        bytes: <<8, 42, 25, 246, 40, 92, 143, 194, 53, 69, 64, 136, 241, 4, 83>>
      },
      %{
        protox: Protox.Benchmarks.Sub,
        exprotobuf: Exprotobuf.Bench.Sub,
        protobuf: Sub,
        bytes: <<8, 42, 34, 0, 136, 241, 4, 83>>
      },
      %{
        protox: Protox.Benchmarks.Sub,
        exprotobuf: Exprotobuf.Bench.Sub,
        protobuf: Sub,
        bytes:
          <<8, 142, 26, 82, 4, 104, 101, 121, 33, 88, 154, 5, 101, 236, 81, 5, 66, 136, 241, 4,
            19>>
      },
      %{
        protox: Protox.Benchmarks.Sub,
        exprotobuf: Exprotobuf.Bench.Sub,
        protobuf: Sub,
        bytes:
          <<18, 0, 48, 0, 56, 0, 64, 0, 72, 0, 106, 16, 1, 0, 0, 0, 0, 0, 0, 0, 254, 255, 255,
            255, 255, 255, 255, 255, 136, 241, 4, 0>>
      },
      %{
        protox: Protox.Benchmarks.Sub,
        exprotobuf: Exprotobuf.Bench.Sub,
        protobuf: Sub,
        bytes:
          <<18, 0, 48, 0, 56, 0, 64, 0, 72, 0, 106, 8, 0, 0, 0, 0, 0, 0, 0, 0, 114, 4, 255, 255,
            255, 255, 122, 16, 154, 153, 153, 153, 153, 153, 64, 64, 0, 0, 0, 0, 0, 0, 70, 192,
            136, 241, 4, 0>>
      },
      %{
        protox: Protox.Benchmarks.Sub,
        exprotobuf: Exprotobuf.Bench.Sub,
        protobuf: Sub,
        bytes:
          <<18, 0, 48, 0, 56, 0, 64, 0, 72, 0, 114, 8, 255, 255, 255, 255, 254, 255, 255, 255,
            136, 241, 4, 0>>
      },
      %{
        protox: Protox.Benchmarks.Msg,
        exprotobuf: Exprotobuf.Bench.Msg,
        protobuf: Msg,
        bytes: <<34, 6, 3, 142, 2, 158, 167, 5>>
      },
      %{
        protox: Protox.Benchmarks.Msg,
        exprotobuf: Exprotobuf.Bench.Msg,
        protobuf: Msg,
        bytes: <<32, 1, 32, 2, 32, 3>>
      },
      %{
        protox: Protox.Benchmarks.Msg,
        exprotobuf: Exprotobuf.Bench.Msg,
        protobuf: Msg,
        bytes: <<66, 7, 8, 2, 18, 3, 98, 97, 114, 66, 7, 8, 1, 18, 3, 102, 111, 111>>
      },
      %{
        protox: Protox.Benchmarks.Msg,
        exprotobuf: Exprotobuf.Bench.Msg,
        protobuf: Msg,
        bytes:
          <<74, 14, 10, 3, 98, 97, 114, 17, 0, 0, 0, 0, 0, 0, 240, 63, 74, 14, 10, 3, 102, 111,
            111, 17, 154, 153, 153, 153, 153, 153, 69, 64>>
      },
      %{
        protox: Protox.Benchmarks.Upper,
        exprotobuf: Exprotobuf.Bench.Upper,
        protobuf: Upper,
        bytes: <<10, 4, 26, 2, 8, 42>>
      },
      %{
        protox: Protox.Benchmarks.Upper,
        exprotobuf: Exprotobuf.Bench.Upper,
        protobuf: Upper,
        bytes:
          <<18, 9, 10, 3, 102, 111, 111, 18, 2, 8, 1, 18, 9, 10, 3, 98, 97, 122, 18, 2, 16, 1>>
      }
    ]
  end

  # exprotobuf_sub =
  #   Exprotobuf.Bench.Sub.new(
  #     a: 150,
  #     b: "testing",
  #     c: 300,
  #     r: :BAR,
  #     g: [1, 2, 3, 4, 5, 6, 7],
  #     n: [true, false, true, false, true, false]
  #   )

  def encode_inputs() do
    [
      %{
        protox: %Protox.Benchmarks.Sub{a: 150},
        # exprotobuf: Exprotobuf.Bench.Sub.new(a: 150),
        protobuf: Sub.new(a: 150)
      },
      %{
        protox: %Protox.Benchmarks.Sub{b: "testing"},
        # exprotobuf: Exprotobuf.Bench.Sub.new(b: "testing"),
        protobuf: Sub.new(b: "testing")
      },
      %{
        protox: %Protox.Benchmarks.Sub{a: 150, b: "testing", c: 300, r: :BAR},
        # exprotobuf: Exprotobuf.Bench.Sub.new(a: 150, b: "testing", c: 300, r: :BAR)
        protobuf: Sub.new(a: 150, b: "testing", c: 300, r: :BAR)
      },
      %{
        protox: %Protox.Benchmarks.Msg{
          d: :FOO,
          e: true,
          f: %Protox.Benchmarks.Sub{
            a: 150,
            b: "testing",
            c: 300,
            r: :BAR,
            g: [1, 2, 3, 4, 5, 6, 7],
            n: [true, false, true, false, true, false]
          }
        },
        # exprotobuf: Exprotobuf.Bench.Msg.new(d: :FOO, e: true, f: exprotobuf_sub)
        protobuf:
          Msg.new(
            d: :FOO,
            e: true,
            f:
              Sub.new(
                a: 150,
                b: "testing",
                c: 300,
                r: :BAR,
                g: [1, 2, 3, 4, 5, 6, 7],
                n: [true, false, true, false, true, false]
              )
          )
      },
      %{
        protox: %Protox.Benchmarks.Msg{g: [1, 2, -3]},
        # exprotobuf: Exprotobuf.Bench.Msg.new(g: [1, 2, -3])
        protobuf: Msg.new(g: [1, 2, -3])
      },
      %{
        protox: %Protox.Benchmarks.Msg{
          j: [%Protox.Benchmarks.Sub{a: 42}, %Protox.Benchmarks.Sub{b: "foo"}]
        },
        # exprotobuf:
        #   Exprotobuf.Bench.Msg.new(
        #     j: [Exprotobuf.Bench.Sub.new(a: 42), Exprotobuf.Bench.Sub.new(b: "foo")]
        #   )
        protobuf: Msg.new(j: [Sub.new(a: 42), Sub.new(b: "foo")])
      },
      %{
        protox: %Protox.Benchmarks.Msg{
          l: %{"1" => 1.0, "2" => 2.0, "3" => 3.0, "4" => 4.0},
          m: {:n, "foo"}
        },
        # exprotobuf:
        #   Exprotobuf.Bench.Msg.new(
        #     l: [{"1", 1.0}, {"2", 2.0}, {"3", 3.0}, {"4", 4.0}],
        #     m: {:n, "foo"}
        #   )
        protobuf:
          Msg.new(
            l: [
              Msg.LEntry.new(key: "1", value: 1.0),
              Msg.LEntry.new(key: "2", value: 2.0),
              Msg.LEntry.new(key: "3", value: 3.0),
              Msg.LEntry.new(key: "4", value: 4.0)
            ],
            m: {:n, "foo"}
          )
      }
    ]
  end
end

# -------------------------------------------------------------------------------------------------#

Benchee.run(
  %{
    "decode_protox" => fn ->
      Enum.map(Data.decode_inputs(), &Benchmark.decode(:protox, 1000, &1))
    end,
    # "decode_exprotobuf" => fn ->
    #   Enum.map(decode_inputs, &Benchmark.decode(:exprotobuf, 1000, &1))
    # end,
    "decode_protobuf" => fn ->
      Enum.map(Data.decode_inputs(), &Benchmark.decode(:protobuf, 1000, &1))
    end,
    "encode_protox" => fn ->
      Enum.map(Data.encode_inputs(), &Benchmark.encode(:protox, 1000, &1))
    end,
    # "encode_exprotobuf" => fn ->
    #   Enum.map(encode_inputs, &Benchmark.encode(:exprotobuf, 1000, &1))
    # end
    "encode_protobuf" => fn ->
      Enum.map(Data.encode_inputs(), &Benchmark.encode(:protobuf, 1000, &1))
    end
  },
  formatters: [
    Benchee.Formatters.HTML,
    Benchee.Formatters.Console
  ],
  time: 5,
  memory_time: 2
)

# -------------------------------------------------------------------------------------------------#
