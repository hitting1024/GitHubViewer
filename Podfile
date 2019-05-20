platform :ios, "11.0"

use_frameworks!

target :'GitHubViewer' do
    # 通信
    pod 'Alamofire', '4.8.2'
    pod 'AlamofireImage', '3.5.2'
    pod 'StatusCodes', '2.0.2'
    
    # UI
    pod 'UIScrollView-InfiniteScroll', '1.1.0'
    
    # Alert
    pod 'TTGSnackbar', '1.7.5'
    pod 'SCLAlertView', '0.8'
end

 post_install do | installer |
     require 'fileutils'
     FileUtils.cp_r('Pods/Target Support Files/Pods-GitHubViewer/Pods-GitHubViewer-Acknowledgements.plist', 'GitHubViewer/resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
 end
