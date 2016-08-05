Pod::Spec.new do |s|

  s.name          = "connect-sdk-client-ios"
  s.version       = "2.0.0"
  s.summary       = "Ingenico Connect iOS SDK"
  s.description   = <<-DESC
                    This native iOS SDK facilitates handling payments in your apps
                    using the GlobalCollect platform of Ingenico ePayments.
                    DESC

  s.homepage      = "https://github.com/Ingenico-ePayments/connect-sdk-client-ios"
  s.license       = { :type => "MIT", :file => "LICENSE.txt" }
  s.author        = "Ingenico"
  s.platform      = :ios, "6.1"
  s.source        = { :git => "https://github.com/Ingenico-ePayments/connect-sdk-client-ios.git", :tag => s.version }
  s.source_files  = "GlobalCollectSDK"

  s.resource_bundles = {
    'GlobalCollectSDK' => ['GlobalCollectSDK/GlobalCollectSDK.bundle/*']
  }

  s.dependency 'AFNetworking', '~> 2.5.3'

end