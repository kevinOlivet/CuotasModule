Pod::Spec.new do |s|
  s.name             = 'CuotasModule'
  s.version          = '1.0.0'
  s.summary          = 'Cuotas Module'

  s.description      = <<-DESC
Used to inject the Cuotas scene
                       DESC

  s.homepage         = 'https://japanart1234.wixsite.com/jonolivet/ios-developer-info'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jon Olivet' => 'kevinolivet@yahoo.com' }
  s.source           = { :path => '.' }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'CuotasModule/Classes/**/*'
  s.resources = [
  'CuotasModule/Assets/**/*.{storyboard,xib,xcassets,html,json,pdf,otf,ttf,plist,strings}'
  ]

  s.dependency 'Commons'

  # s.script_phases = [
  #   {
  #     :name => 'SwiftlintLocalModules',
  #     :script => '$SRCROOT/../configurations/Build-Phases/swiftlint_locals_modules_execute.sh',
  #     :show_env_vars_in_log => true,
  #     :execution_position => :before_compile
  #   }
  # ]
end
