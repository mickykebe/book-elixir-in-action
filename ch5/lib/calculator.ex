defmodule Calculator do
  def start do
    spawn(fn -> loop(0) end)
  end

  def value(calc_pid) do
    send(calc_pid, {:value, self()})
    receive do
      {:response, value} -> value
    end
  end

  def add(server_pid, x), do: send(server_pid, {:add, x})
  def sub(server_pid, x), do: send(server_pid, {:sub, x})
  def mul(server_pid, x), do: send(server_pid, {:mul, x})
  def div(server_pid, x), do: send(server_pid, {:div, x})

  defp loop(current_value) do
    new_value = receive do
      message -> process_message(current_value, message)
    end

    loop(new_value)
  end

  defp process_message(current_value, {:value, caller}) do
    send(caller, {:response, current_value})
    current_value
  end
  defp process_message(current_value, {:add, value}) do
    current_value + value
  end
  defp process_message(current_value, {:sub, value}) do
    current_value - value
  end
  defp process_message(current_value, {:mul, value}) do
    current_value * value
  end
  defp process_message(current_value, {:div, value}) do
    current_value / value
  end
  defp process_message(current_value, invalid_request) do
    IO.puts("invalid request #{inspect invalid_request}")
    current_value
  end
end