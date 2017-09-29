Pod::Spec.new do |s|
	s.name 			= 'VerifireKit'
	s.version 		= '1.0.1'
	s.summary 		= 'Phone number verification'
	s.homepage 		= 'https://github.com/VeriFire/VerifireKit-ios'
	s.documentation_url = 'https://verifire.io/'
	s.license 		= { :type => 'Apache', :file => 'LICENSE' }
	s.author 		= { 'Sergey Popov' => 'serj@verifire.io' }
	s.source 		= { :git => 'https://github.com/VeriFire/VerifireKit-ios.git', :tag => s.version.to_s }
	s.requires_arc	= true
	s.platform		= :ios, '8.0'

  	s.source_files = 'VerifireKit/**/*.[mh]'
  	s.public_header_files = 'VerifireKit/Public/*.h'
  	s.private_header_files = 'VerifireKit/Private/*.h'
  	s.resources = 'VerifireKit/Resources/VerifireKit.bundle'
  	s.module_map = 'VerifireKit/Resources/module.modulemap'

	# Dependencies
	s.dependency 'AFNetworking', '~> 3.0'
end
