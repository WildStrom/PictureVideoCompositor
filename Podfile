source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'

inhibit_all_warnings!

project 'PictureVideoCompositor.xcodeproj'

target 'PictureVideoCompositor' do
    use_frameworks!
    pod 'VFCabbage',  :git => 'https://github.com/VideoFlint/Cabbage.git'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'VFCabbage'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        end
    end
end
