Pod::Spec.new do |s|
    s.name = 'RMImageLoader'
    s.module_name = 'RMImageLoader'
    s.version = '0.1.1'
    s.license = 'MIT'
    s.summary = 'Async image loading'
    s.homepage = 'https://github.com/robertmogos/RMImageLoader'
    s.author   = { 'Robert D. Mogos' => 'mogos.robert@gmail.com' }
    s.source = { :git => 'https://github.com/robertmogos/RMImageLoader.git', :tag => s.version }

    s.ios.deployment_target = '9.0'

    s.source_files = [
        'RMImageLoader/RMImageLoader/*.swift',
    ]
end
