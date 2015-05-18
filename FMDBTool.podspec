Pod::Spec.new do |s|

  s.name         = "FMDBTool"
  s.version      = "0.0.2"
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

  s.source       = { :git => "https://github.com/chengdonghai/FMDBTool.git", :tag => "0.0.2" }

  s.source_files  = "Classes","Classes/**/*.{h,m}"
  #s.exclude_files = "Classes/Exclude"

  s.public_header_files = "Classes/**/*.h"

  s.requires_arc = true

  s.dependency "FMDB", "~> 2.3"

end
