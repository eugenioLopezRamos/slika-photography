class Image
  extend CarrierWave::Mount
  mount_uploader :image , ImageUploader
  attr_accessor :key

end