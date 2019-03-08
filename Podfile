platform :osx, '10.14'

target 'Pronunciation Generator' do
  use_frameworks!
  pod 'Moya', '~> 12.0'
  pod 'AudioKit/Core'
end

plugin 'cocoapods-keys', {
	:project => "Pronunciation Generator",
	:target => "Pronunciation Generator",
	:keys => [
	"learnersDictionaryAPIKey",
	"collegiateDictionaryAPIKey"
	]
}
