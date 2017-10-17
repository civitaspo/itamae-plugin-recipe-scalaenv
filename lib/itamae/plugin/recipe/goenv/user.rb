node.reverse_merge!(
  goenv: {
    scheme:   'git',
    user:     ENV['USER'],
    versions: [],
  },
  :'go-build' => {
    build_envs: [],
  }
)

unless node[:goenv][:goenv_root]
  case node[:platform]
  when 'osx', 'darwin'
    user_dir = '/Users'
  else
    user_dir = '/home'
  end
  node[:goenv][:goenv_root] = File.join(user_dir, node[:goenv][:user], '.goenv')
end

include_recipe 'goenv::install'
