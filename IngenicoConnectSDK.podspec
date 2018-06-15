Pod::Spec.new do |s|

  s.name          = "IngenicoConnectSDK"
  s.version       = "3.11.0"
  s.summary       = "Ingenico Connect iOS SDK"
  s.description   = <<-DESC
                    This native iOS SDK facilitates handling payments in your apps
                    using the Ingenico ePayments platform of Ingenico ePayments.
                    DESC

  s.homepage      = "https://github.com/Ingenico-ePayments/connect-sdk-client-ios"
  s.license       = { :type => "MIT", :file => "LICENSE.txt" }
  s.author        = "Ingenico"
  s.platform      = :ios, "6.1"
  s.source        = { :git => "https://github.com/Ingenico-ePayments/connect-sdk-client-ios.git", :tag => s.version }
  s.source_files  = "IngenicoConnectSDK"
  s.resource      = "IngenicoConnectSDK/IngenicoConnectSDK.bundle"

  s.dependency 'AFNetworking', '~> 2.5.3'

end