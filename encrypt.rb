# the point of this file is to generate a data key and store that alongside the encrypted data.

require 'aws-sdk-core'
require 'openssl'
require 'base64'

key_id = 'arn:aws:kms:us-east-1:547257767548:key/935920d9-37fe-4c53-8bc6-0f2402565c83'
kms = Aws::KMS::Client.new(region:'us-east-1')
data = "super duper secret data"
puts 'data:'
puts data

response = kms.generate_data_key(
  key_id: key_id,
  key_spec: 'AES_256'
) # => returns a ciphertext and a plaintext key

# write the encrypted data key to file
edk = response.ciphertext_blob
File.write('data/edk', "#{Base64.strict_encode64(edk)}")

#discard the plaintext key after using it to encrypt data
puts 'plaintext key:'
puts Base64.strict_encode64(response.plaintext)
puts

# encrypt the data using the plaintext key .
# and Ruby's OpenSSL Cipher class and AES256 CBC. the data is encrypted using the plaintext key and a random iv
ptk = response.plaintext
cipher = OpenSSL::Cipher::AES256.new(:CBC)
cipher.encrypt
cipher.key = ptk
iv  = cipher.random_iv
File.write('data/iv', "#{Base64.strict_encode64(iv)}")

puts 'iv'
puts "#{iv}"
puts

encrypted = cipher.update(data) + cipher.final
puts 'encrypted:'
puts Base64.strict_encode64(encrypted)
File.write('data/encrypted_data', "#{Base64.strict_encode64(encrypted)}")
