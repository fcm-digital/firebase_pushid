# FirebasePushid

Generates Firebase id. [article](https://firebase.googleblog.com/2015/02/the-2120-ways-to-ensure-unique_68.html)
It caches with previous timestamp.
If same timestamp is stored in the cache it will generate an incremental id
in base 64 trying to increment the last possible character.
ex:
1) -Kyukibfm7T0jJT_Deyr
2) -Kyukibfm7T0jJT_Deys

If last can not be incremented will update the next
ex:
1) -KyukibfiPUIPSaeXo9z
2) -KyukibfiPUIPSaeXoA-
3) -KyukibfiPUIPSaeXoA0
...
x) -KyukibfiPUIPSaeXoAz
x) -KyukibfiPUIPSaeXoB-
x) -KyukibfiPUIPSaeXoB0

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `firebase_pushid` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:firebase_pushid, "~> 0.1.0"}]
end
```

```elixir
def application do
  [applications: [:firebase_pushid]]
end
```

And fetch your project's dependencies:

```
$ mix deps.get
```

## Usage

```elixir
iex> FirebasePushid.generate
"-KzO0n9zzKuWHH9i5t0l"
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/firebase_pushid](https://hexdocs.pm/firebase_pushid).
