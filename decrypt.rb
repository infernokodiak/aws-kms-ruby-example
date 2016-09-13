# decrypt the encrypted_data given the encrypted data key (edk) and iv

require 'aws-sdk-core'
require 'openssl'
require 'base64'
require 'pry'

key_id = 'arn:aws:kms:us-east-1:547257767548:key/935920d9-37fe-4c53-8bc6-0f2402565c83'
kms = Aws::KMS::Client.new(region:'us-east-1')

# pull all data from the files
iv = Base64.strict_decode64(File.read('data/iv'))
edk = Base64.strict_decode64(File.read('data/edk'))
encrypted_data = Base64.strict_decode64(File.read('data/encrypted_data'))

# obtain the plaintext key from the edk
# use the plaintext key and iv to decrypt the encrypted_data
response = kms.decrypt(
  ciphertext_blob: "#{edk}"
)
key = response.plaintext

puts 'plaintext key:'
puts "#{Base64.strict_encode64(key)}"
puts

puts 'iv'
puts "#{iv}"
puts

decipher = OpenSSL::Cipher::AES256.new(:CBC)
decipher.decrypt
decipher.key = key
decipher.iv = iv

plain_data = decipher.update(encrypted_data) + decipher.final

puts plain_data
