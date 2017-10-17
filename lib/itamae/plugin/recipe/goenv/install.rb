# This recipe requires `goenv_root` is defined.

include_recipe 'goenv::dependency'

# TODO: configure the goenv repo url?
# repo_host  = nodo[:goenv][:goenv_repo_host] || 'github.com'
# repo_org   = node[:goenv][:goenv_repo_org]  || 'syndbg'
scheme     = node[:goenv][:scheme]
goenv_root = node[:goenv][:goenv_root]

git goenv_root do
  repository "#{scheme}://github.com/syndbg/goenv.git"
  revision   node[:goenv][:revision] if node[:goenv][:revision]
  user       node[:goenv][:user]     if node[:goenv][:user]
end

directory File.join(goenv_root, 'plugins') do
  user node[:goenv][:user] if node[:goenv][:user]
end
if node[:goenv][:cache]
  directory File.join(goenv_root, 'cache') do
    user node[:goenv][:user] if node[:goenv][:user]
  end
end

# TODO: if some goenv plugins are released, pubilsh this.
# ex)
#   goenv_plugin:
#     - github.com/civitaspo/goenv-default-packages
#
# define :goenv_plugin do
#   repo_url = "#{scheme}://#{params[:name]}.git"
#   pkg      = params[:name].split('/').last
# 
#   git "#{goenv_root}/plugins/#{pkg}" do
#     repository repo_url
#     revision   node[name][:rdevision] if node[name][:revision]
#     user       node[:goenv][:user]    if node[:goenv][:user]
#   end
# end

goenv_init = <<-EOS
  export GOENV_ROOT=#{goenv_root}
  export PATH="#{goenv_root}/bin:${PATH}"
  eval "$(goenv init -)"
EOS

# nodoc
build_envs = node[:'go-build'][:build_envs].map do |key, value|
  %Q[export #{key}="#{value}"\n]
end.join

node[:goenv][:versions].each do |version|
  execute "goenv install #{version}" do
    command "#{goenv_init} #{build_envs} goenv install #{version}"
    not_if  "#{goenv_init} goenv versions | grep #{version}"
    user    node[:goenv][:user] if node[:goenv][:user]
  end
end

if node[:goenv][:global]
  node[:goenv][:global].tap do |version|
    execute "goenv global #{version}" do
      command "#{goenv_init} goenv global #{version}"
      not_if  "#{goenv_init} goenv version | grep #{version}"
      user    node[:goenv][:user] if node[:goenv][:user]
    end
  end
end
