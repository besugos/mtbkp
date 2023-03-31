task :before_assets_precompile do

  # All bootstrap and dropify icons are traditional CSS file, so it points to
  # local fonts using relative way. To work property on production we need to
  # copy those files to the public folder, so we can receive NPM updates without
  # any issue

  # dropify
  system('mkdir -p public/fonts/')
  system('rm public/fonts/*')
  system('ln -s $(pwd)/node_modules/dropify/dist/fonts/dropify.eot public/fonts/dropify.eot')
  system('ln -s $(pwd)/node_modules/dropify/dist/fonts/dropify.svg public/fonts/dropify.svg')
  system('ln -s $(pwd)/node_modules/dropify/dist/fonts/dropify.ttf public/fonts/dropify.ttf')
  system('ln -s $(pwd)/node_modules/dropify/dist/fonts/dropify.woff public/fonts/dropify.woff')
end

# every time you execute 'rake assets:precompile'
# run 'before_assets_precompile' first
Rake::Task['assets:precompile'].enhance ['before_assets_precompile']
