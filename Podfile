
inhibit_all_warnings!

target 'LocalAuthenticator' do
  
  use_frameworks!

  pod 'OneTimePassword', '~> 3.0'
  pod 'QRCodeReader.swift', '~> 7.4.3'
  pod 'RNCryptor', '~> 5.0'

  target 'LocalAuthenticatorTests' do
    inherit! :search_paths
    
    pod 'OneTimePassword', '~> 3.0'
    pod 'QRCodeReader.swift', '~> 7.4.3'
    pod 'RNCryptor', '~> 5.0'
    
  end

  target 'LocalAuthenticatorUITests' do
    inherit! :search_paths
    
    pod 'KIF'
    pod 'Nimble'
  end

end
