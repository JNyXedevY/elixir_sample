# required Mix Library
# 1. Flow: https://hex.pm/packages/flow
defmodule CsvData do
  defstruct [:company_id,:name,:email]
end

defmodule CsvParser do
  require String

  def parse(raw_data) do
    headers = raw_data |> Stream.take(1) |> get_csv_header()
    raw_data
    |> Stream.drop(1)
    |> get_csv_data(headers)
  end

  def get_csv_header(csv_headers) do
    csv_headers
    |> Flow.from_enumerable()
    |> Flow.flat_map(&String.split/1)
    |> Flow.partition()
    |> Flow.flat_map(&String.split(&1, ",", trim: true))
    |> Enum.to_list()
  end

  def get_csv_data(csv_data, headers) do
    csv_data
    |> Flow.from_enumerable()
    |> Flow.flat_map(&String.split/1)
    |> Flow.partition()
    |> Flow.map(&String.split(&1, ",", trim: true))
    |> Flow.map(&Enum.zip(headers, &1))
    |> Enum.to_list()
  end
end

defmodule HashedCsvParser do
  def run() do
    data =
      File.stream!("lib/data.csv")
      |> CsvParser.parse()

    IO.puts(Enum.count(data))
  end
end
