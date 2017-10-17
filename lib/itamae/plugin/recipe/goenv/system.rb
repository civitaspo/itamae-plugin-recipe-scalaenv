node.reverse_merge!(
  goenv: {
    goenv_root: '/usr/local/goenv',
    scheme:     'git',
    versions:   [],
  },
  :'go-build' => {
    build_envs: [],
  }
)

include_recipe 'goenv::install'
