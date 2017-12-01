module DecodeBase64Image

  def self.convert_data_uri_to_upload(image, filename = nil)
    uploaded_file = nil
    image_data = split_base64(image)
    return nil unless image_data

    image_data_string = image_data[:data]
    image_data_binary = Base64.decode64(image_data_string)
    temp_img_file = Tempfile.new
    temp_img_file.binmode
    temp_img_file << image_data_binary
    temp_img_file.rewind

    filename = filename.present?  ? "#{filename}.#{image_data[:extension]}" : "#{Time.current.to_i}.#{image_data[:extension]}"

    img_params = { filename: filename, type: image_data[:type], tempfile: temp_img_file}
    uploaded_file = ActionDispatch::Http::UploadedFile.new(img_params)
  end

  private
  def self.split_base64(uri_str)
    return {type: $1, encoder: $2, data: $3, extension: $1.split('/')[1]} if uri_str =~ /^data:(.*?);(.*?),(.*)$/
    nil
  end

end
