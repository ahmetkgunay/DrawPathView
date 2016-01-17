Pod::Spec.new do |s|
  s.name             = "DrawPathView"
  s.version          = "0.1.0"
  s.summary          = "Drawable View written in pure Swift2"
  s.description      = <<-DESC
                        Easy to use drawable custom View written in pure Swift2. You can delete paths or delete last drawn path. You can also draw paths with any colors you want and change this color whenever you want.
                       DESC

  s.homepage         = "https://github.com/ahmetkgunay/DrawPathView"
  s.license          = 'MIT'
  s.author           = { "Ahmet Kazım Günay" => "ahmetkgunay@gmail.com" }
  s.source           = { :git => "https://github.com/ahmetkgunay/DrawPathView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ahmtgny'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'DrawPathViewSwift/**/*'
end
