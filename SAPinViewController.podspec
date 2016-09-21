#
# Be sure to run `pod lib lint SAPinViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SAPinViewController'
  s.version          = '0.2.0'
  s.summary          = 'Simple, easy to use and fully customisable PIN Screen'



  s.description      = <<-DESC
Simple and easy to use default iOS PIN screen. This simple library allows you to draw a fully customisable PIN screen same as the iOS default PIN view.
My inspiration to create this library was form [THPinViewController](https://github.com/antiraum/THPinViewController), however ```SAPinViewController``` is completely implemented in ```Swift```. Also the main purpose of creating this library was to have simple, easy to use and fully customisable PIN screen.
                       DESC

  s.homepage         = 'https://github.com/siavashalipour/SAPinViewController'
  # s.screenshots     = 'https://github.com/siavashalipour/SAPinViewController/blob/master/6Plus.png', 'https://github.com/siavashalipour/SAPinViewController/blob/master/ipad-landscape.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Siavash' => 'siavash@siavashalipour.com' }
  s.source           = { :git => 'https://github.com/siavashalipour/SAPinViewController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SAPinViewController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SAPinViewController' => ['SAPinViewController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.swift'
   s.frameworks = 'UIKit'
   s.dependency 'SnapKit'
end
