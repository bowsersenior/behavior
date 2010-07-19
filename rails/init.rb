require 'behavior'

# to prevent a bug when reloading when cache_classes=false (i.e. development environment)
# see: http://strd6.com/2009/04/cant-dup-nilclass-maybe-try-unloadable/
# and: http://github.com/paulca/behavior/issues#issue/1
if defined?(config) and not config.cache_classes
  load_paths.each do |path|
    ActiveSupport::Dependencies.load_once_paths.delete(path)
  end
end