platform :ios, "11.0"

use_frameworks!

target :'GitHubViewer' do
end

 post_install do | installer |
     require 'fileutils'
     FileUtils.cp_r('Pods/Target Support Files/Pods-GitHubViewer/Pods-GitHubViewer-Acknowledgements.plist', 'GitHubViewer/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
 end
