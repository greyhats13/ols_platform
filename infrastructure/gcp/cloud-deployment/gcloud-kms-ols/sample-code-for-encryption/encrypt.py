from google.cloud import kms_v1
import base64

# set variable reqquired configuration
project_id = 'onlineshop-378118'
location_id = 'global'
key_ring_id = 'ols-dev-gcloud-kms-keyring'
crypto_key_id = 'ols-dev-gcloud-kms-cryptokey'

# Client initialization
client = kms_v1.KeyManagementServiceClient()
key_name = client.crypto_key_path(project_id, location_id, key_ring_id, crypto_key_id)

# Prompt the user to enter plaintext
plaintext = input('Enter the plaintext: ')

# Encrypt the plaintext
response = client.encrypt(request={'name': key_name, 'plaintext': plaintext.encode('utf-8')})

# Print the encrypted text
encrypted_text = base64.b64encode(response.ciphertext).decode('utf-8')

print(f'Encrypted text: {encrypted_text}')