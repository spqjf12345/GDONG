# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GDONG' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GDONG

pod 'KakaoSDKAuth'  # 카카오 로그인
pod 'KakaoSDKUser'
pod 'KakaoSDKCommon'
pod 'KakaoOpenSDK'

pod 'GoogleSignIn' #구글 로그인

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
    end
end


end
