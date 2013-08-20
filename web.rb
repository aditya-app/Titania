require_relative('system/xmvc/xmvc_titania.rb')

resx = Titania::System::Core::ResourcesProvider.new()

resx.provide("#{$root}resources/css", '/resources/css')
resx.provide("#{$root}resources/images", '/resources/images')

xmvc = Titania::System::XMVC::XMVCTitania.new(resx)
xmvc.start(80)