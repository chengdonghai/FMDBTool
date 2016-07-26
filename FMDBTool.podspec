Pod::Spec.new do |s|

  s.name         = "FMDBTool"
  s.version      = "1.0.5"
  s.summary      = "A Tool For FMDB."

  s.description  = <<-DESC
                   A longer description of FMDBTool in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/chengdonghai/FMDBTool"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }

  s.author             = { "Donghai Cheng" => "dong723232@gmail.com" }

  s.source       = { :git => "https://github.com/chengdonghai/FMDBTool.git", :tag => "1.0.5" }

  s.source_files  = "FMDBTool/Classes","FMDBTool/Classes/**/*.{h,m}"
  #s.exclude_files = "FMDBTool/Classes/Exclude"

  s.public_header_files = "FMDBTool/Classes/**/*.h"

  s.requires_arc = true
  s.platform     = :ios, "6.0"
  s.dependency "FMDB"

end
