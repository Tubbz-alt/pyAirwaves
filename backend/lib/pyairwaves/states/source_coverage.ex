defmodule Pyairwaves.States.SourceCoverage do
  use GenServer
  require Logger

  # The state is key-value
  # The key is the source ID from ArchiveSource db entry
  # The value is a map, %{lat: 0, lon:0, bearings: {bearing => distance}}
  # lat and lon are the one of the source
  # The bearings list is a map of the actual bearing (1 to 360, ideally only every 30 degrees, float), and distance (in meters, integer)
  # Only the longuest distance for each bearing is in this list

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, :ets.new(:source_coverage, [:named_table, :protected])}
  end

  def find(name) do
    case :ets.lookup(:source_coverage, name) do
      [{^name, items}] -> {:ok, items}
      [] -> :error
    end
  end

  def new(list) do
    GenServer.call(__MODULE__, {:new, list})
  end

  @doc "Add a bearing/distance into the state"
  def add(source_id, coverage) do
    GenServer.call(__MODULE__, {:add, source_id, coverage})
  end

  def handle_call({:new, source_id}, _from, table) do
    case find(source_id) do
      {:ok, source_id} ->
        {:reply, source_id, table}

      :error ->
        :ets.insert(table, {source_id, []})
        {:reply, [], table}
    end
  end

  # TODO: if find, do not merge but replace if new_distance > old_distance
  def handle_call({:add, source_id, coverage}, _from, table) do
    case find(source_id) do
      {:ok, coverages} ->
        :ets.delete(table, source_id)

        # get the previous and next distance
        prev_distance = Map.get(coverages.bearings, coverage.bearing, nil)
        new_distance = coverage.distance

        # conditionally update new_bearings if the new distance is > old one or just return the bearings
        new_bearings = case prev_distance do
          prev_distance when prev_distance < new_distance ->
            Logger.debug("prev < new #{prev_distance} < #{new_distance}")
            Map.put(coverages.bearings, coverage.bearing, coverage.distance)
          nil -> Map.put(coverages.bearings, coverage.bearing, coverage.distance)
          _ -> coverages.bearings
        end

        c_new = Map.put(coverages, :bearings, new_bearings)
        :ets.insert(table, {source_id, c_new})
        {:reply, coverages, table}
      :error ->
        Logger.warn("Does not exists")
        # build new bearings map
        bearings = %{}
        |> Map.put(coverage.bearing, coverage.distance)

        # add that map to the struct
        c_struct = %{lat: coverage.lat, lon: coverage.lon}
        |> Map.put(:bearings, bearings)

        # insert in the state
        :ets.insert(table, {source_id, c_struct})
        {:reply, c_struct, table}
    end
  end
end
