BuildInfo = Struct.new(:scheme)

class Constants

  def self.sdk_build_info
    BuildInfo.new('PaymayaSDK')
  end

  def self.example_build_info
    BuildInfo.new('PaymayaExample')
  end

  def self.appcenter_stage_app_name
    "PaymayaExample"
  end

  def self.appcenter_owner_name
    "Miquido-Organization"
  end

  def self.provisioning_location
    '../Provisioning/*.mobileprovision'
  end

  def self.archive_path
    './gym_archive'
  end
end
