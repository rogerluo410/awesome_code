CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider:              'AWS',                                         # required
    aws_access_key_id:     ENV['AWSAccessKeyId'],                         # required
    aws_secret_access_key: ENV['AWSSecretKey'],                           # required
    region:                ENV['AWSRegion'],                              # optional, defaults to 'us-east-1'
  }
  config.fog_directory = "#{ENV['AWSBucketName']}-#{Rails.env}"
  config.fog_public     = false                                            # optional, defaults to true
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
end
