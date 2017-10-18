Pod::Spec.new do |s|

  s.name         = "DSPageController"
  s.version      = "0.1.0"
  s.summary      = "a pagecontroller."
  s.homepage     = "https://github.com/DiorStone/DSPageController"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Dior-Stone" => "mrdaios@gmail.com" }
  s.source       = { :git => "https://github.com/DiorStone/DSPageController.git", :tag => s.version }

  s.source_files  = "Sources/**/*.{swift}"

  s.ios.deployment_target = '8.0'
end
