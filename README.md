# ExResult

Module for working with "result" tuples. Provides helpers for wrapping, unwrapping, and transforming result tuples.

An opinionated stance on what constitutes a "result" tuple is taken here. A result tuple is a tuple of the form `{:ok, value}` or `{:error, value}` and nothing else.

These helpers are most useful in pipelines.

Hexdocs found at
[https://hexdocs.pm/ex_result](https://hexdocs.pm/ex_result).

## Installation

Add the latest release to your `mix.exs` file:

```elixir
def deps do
  [
    {:ex_result, "~> 0.0.4"}
  ]
end
```
