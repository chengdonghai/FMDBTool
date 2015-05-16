Pod::Spec.new do |s|
  s.name         = "FMDBTool"
  s.version      = "0.0.1"
  s.summary      = "A Tool To FMDB"

  s.homepage     = "https://github.com/chengdonghai/FMDBTool"
  s.license      = "MIT (example)"
  s.author             = { "chengdonghai" => "18658800949@189.cn" }
  s.source       = { :git => "https://github.com/chengdonghai/FMDBTool.git", :tag => "0.0.1" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"

  s.dependency 'FMDB', '~> 2.3'
  s.requires_arc = true

end
