class Image
  extend CarrierWave::Mount
  mount_uploader :image , ImageUploader

end