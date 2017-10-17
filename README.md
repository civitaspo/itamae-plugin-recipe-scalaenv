# Itamae::Plugin::Recipe::Goenv

[Itamae](https://github.com/ryotarai/itamae) plugin to install golang with [goenv](https://github.com/syndbg/goenv)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'itamae-plugin-recipe-goenv'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install itamae-plugin-recipe-goenv

# Usage
## System wide installation

Install goenv to /usr/local/goenv or some shared path

### Recipe

```ruby
# your recipe
include_recipe "goenv::system"
```

### Node

Use this with `itamae -y node.yml`

```yaml
# node.yml
goenv:
  global:
    1.7.4
  versions:
    - 1.7.4
    - 1.6.3
    - 1.5.4

  # goenv install dir, optional (default: /usr/local/goenv)
  goenv_root: "/path/to/goenv"

  # specify scheme to use in git clone, optional (default: git)
  scheme: https

  # Create /usr/local/goenv/cache, optional (default: false)
  # See: https://github.com/syndbg/goenv/tree/bae243f3771731897aafb152126976653cb8213c/plugins/go-build#package-download-caching
  cache: true
```

### .bashrc

Recommend to append this to .bashrc in your server.

```bash
export GOENV_ROOT=/usr/local/goenv
export PATH="${GOENV_ROOT}/bin:${PATH}"
eval "$(goenv init -)"
```

## Installation for a user

Install goenv to `~#{node[:goenv][:user]}/.goenv`

### Recipe

```ruby
# your recipe
include_recipe "goenv::user"
```

### Node

Use this with `itamae -y node.yml`

```yaml
# node.yml
goenv:
  user: civitaspo
  global:
    1.7.4
  versions:
    - 1.7.4
    - 1.6.3
    - 1.5.4

  # specify scheme to use in git clone, optional (default: git)
  scheme: https

  # Create ~/.goenv/cache, optional (default: false)
  # See: https://github.com/syndbg/goenv/tree/bae243f3771731897aafb152126976653cb8213c/plugins/go-build#package-download-caching
  cache: true
```

## Example

```
$ cd example
$ vagrant up
$ bundle exec itamae ssh --vagrant -y node.yml recipe.rb
```

## MItamae

This plugin can be used for MItamae too. Put this repository under `./plugins` as git submodule.

```rb
node.reverse_merge!(
  goenv: {
    user: 'civitaspo',
    global: '1.7.4',
    versions: %w[
      1.7.4
      1.6.3
      1.5.4
    ],
  }
)

include_recipe "goenv::user"
```

## License

MIT License
