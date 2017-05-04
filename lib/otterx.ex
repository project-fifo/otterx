defmodule Otterx do
  @moduledoc """
  Otterx is open tracing library for Elixir. It provides a wrapper around
  the otters Erlang library.

  All functions allow to pass nil or :undefined in the parts refering to
  other traces, parents, or the span to update. This will rendere the function
  a noop and allows for a fast bypassing of tracing without much additional load
  """

  @doc """
  Starts a new span with a given name and a generated trace id.

  ## Examples

      iex> span = Otterx.start("aspan")
      iex> is_tuple(span)
      true

  """
  def start(name) do
    :otters.start(name)
  end

  @doc """
  Starts a new span with a given Trace ID. If the `trace_id` is `:undefined`
  or `nil` the span is not started and `nil` is returned in it's pace.

  ## Examples

      iex> Otterx.start("aspan", nil)
      nil
      iex> Otterx.start("aspan", :undefined)
      nil
      iex> span = Otterx.start("aspan", 42)
      iex> is_tuple(span)
      true

  """
  def start(_name, nil) do
    nil
  end
  def start(_name, :undefined) do
    nil
  end
  def start(name, trace_id) do
    :otters.start(name, trace_id)
  end


  @doc """
  Starts a new span with a given Trace ID and Parent ID. If the `trace_id` is `:undefined`
  or `nil` the span is not started and `nil` returned in it's pace. The `parent_id`
  can either be a number, `nil` or `:undefined`

  ## Examples

      iex> Otterx.start("aspan", nil, nil)
      nil
      iex> Otterx.start("aspan", :undefined, nil)
      nil
      iex> span = Otterx.start("aspan", 42, nil)
      iex> is_tuple(span)
      true
      iex> span = Otterx.start("aspan", 42, 100)
      iex> is_tuple(span)
      true

  """
  def start(_name, nil, _) do
    nil
  end
  def start(_name, :undefined, _) do
    nil
  end
  def start(name, trace_id, nil) do
    :otters.start(name, trace_id, :undefined)
  end
  def start(name, trace_id, parent_id) do
    :otters.start(name, trace_id, parent_id)
  end

  @doc """
  Starts a new span as a child of a existing span, using the parents
  Trace ID or a `{trace_id, parent_id}` tuple and setting the childs
  parent to the parents Span ID.

  If the `parent` or `trace_id` is `:undefined` or `nil` the span is not started
  and `nil` is returned in it's pace.

    ## Examples

      iex> Otterx.start_child("child", nil)
      nil
      iex> Otterx.start_child("child", :undefined)
      nil
      iex> parent = Otterx.start("parent")
      iex> span = Otterx.start_child("child", parent)
      iex> is_tuple(span)
      true
      iex> trace_ids = {42, nil}
      iex> span = Otterx.start_child("child", trace_ids)
      iex> is_tuple(span)
      true
      iex> trace_ids = {42, 100}
      iex> span = Otterx.start_child("child", trace_ids)
      iex> is_tuple(span)
      true

  """

  def start_child(_name, nil) do
    nil
  end
  def start_child(_name, :undefined) do
    nil
  end
  def start_child(name, {trace_id, parent_id}) do
    start(name, trace_id, parent_id)
  end
  def start_child(name, parent) do
    :otters.start_child(name, parent)
  end

  @doc """
  Adds a tag to a span, possibly overwriting the existing value.

    ## Examples

      iex> Otterx.tag(nil, "key", "value")
      nil
      iex> Otterx.tag(:undefined, "key", "value")
      nil
      iex> span = Otterx.start("span")
      iex> span = Otterx.tag(span, "key", "value")
      iex> is_tuple(span)
      true

  """
  def tag(nil, _key, _value) do
    nil
  end
  def tag(:undefined, _key, _value) do
    nil
  end
  def tag(span, key, value) do
    :otters.tag(span, key, value)
  end

  @doc """
  Adds a tag to a span with a given service, possibly overwriting
  the existing value.

    ## Examples

      iex> Otterx.tag(nil, "key", "value", "service")
      nil
      iex> Otterx.tag(:undefined, "key", "value", "service")
      nil
      iex> span = Otterx.start("span")
      iex> span = Otterx.tag(span, "key", "value", "service")
      iex> is_tuple(span)
      true

  """
  def tag(nil, _key, _value, _service) do
    nil
  end
  def tag(:undefined, _key, _value, _service) do
    nil
  end
  def tag(span, key, value, service) do
    :otters.tag(span, key, value, service)
  end

  @doc """
  Adds a log to a span.

    ## Examples

      iex> Otterx.log(nil, "my log")
      nil
      iex> Otterx.log(:undefined, "your log")
      nil
      iex> span = Otterx.start("span")
      iex> span = Otterx.log(span, "our log")
      iex> is_tuple(span)
      true

  """
  def log(nil, _log) do
    nil
  end
  def log(:undefined, _log) do
    nil
  end
  def log(span, log) do
    :otters.log(span, log)
  end

  @doc """
  Adds a log to a span with a given service.

    ## Examples

      iex> Otterx.log(nil, "my log", "service")
      nil
      iex> Otterx.log(:undefined, "your log", "service")
      nil
      iex> span = Otterx.start("span")
      iex> span = Otterx.log(span, "our log", "service")
      iex> is_tuple(span)
      true

  """
  def log(nil, _log, _service) do
    nil
  end
  def log(:undefined, _log, _service) do
    nil
  end
  def log(span, log, service) do
    :otters.log(span, log, service)
  end

  @doc """
  Ends a span and prepares queues it to be dispatched to the trace
  server. This is also where filtering happens, it's the most
  expensive  part of tracing.

    ## Examples

      iex> Otterx.finish(nil)
      :ok
      iex> Otterx.finish(:undefined)
      :ok
      iex> span = Otterx.start("span")
      iex> Otterx.finish(span)
      :ok

  """
  def finish(nil) do
    :ok
  end
  def finish(:undefined) do
    :ok
  end
  def finish(span) do
    :otters.finish(span)
  end

  @doc """
  Retrives the Trace ID and the Span ID from a span. This can
  be used for `start_child/2`

    ## Examples

      iex> Otterx.ids(nil)
      nil
      iex> Otterx.ids(:undefined)
      nil
      iex> span = Otterx.start("span")
      iex> {trace_id, span_id} = Otterx.ids(span)
      iex> is_integer(trace_id) and is_integer(span_id)
      true

  """
  def ids(nil) do
    nil
  end
  def ids(:undefined) do
    nil
  end
  def ids(span) do
    :otters.ids(span)
  end
end
