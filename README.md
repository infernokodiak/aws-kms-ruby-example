

run bundler to download the gem dependencies.
`bundle`

create an aws kms master key. http://docs.aws.amazon.com/kms/latest/developerguide/create-keys.html  grant usage to your IAM user.  

replace the `key_id` value with the arn for the master key you created.  do this in both the encrypt.rb and decrypt.rb scripts.
`key_id = 'arn:aws:kms:us-east-1:547257767548:key/935920d9-37fe-4c53-8bc6-0f2402565c83'`

run the encrypt method.
`ruby encrypt.rb`

this does the following:

1. uses kms to create a data key. this returns a data key in two parts, a plaintext key and an encrypted data key.
2. that plaintext key and a random initialization vector (iv) is used to encrypt the data via ruby's OpenSSL::Cipher.  Note at this point there is no need for the plaintext key - it is discarded.
3. the encrypted data key (edk), the iv, and the encrypted data are then base64 encoded and stored in a data folder.


run the decrypt method.
`ruby decrypt.rb`

this does the following:

1. reads and decodes the base64 encoding for the edk, iv, and encrypted data.
2. uses kms to decrypt the edk.  that returns a plaintext key.
3. given that plaintext key, iv and encrypted data, the system uses ruby's OpenSSL::Cipher class to decrypt the encrypted message.
