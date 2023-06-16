import time
from urllib.parse import quote_plus, quote
import hmac
import hashlib
import base64

def get_auth_token(sb_name, eh_name, sas_name, sas_value):
    """
    Returns an authorization token dictionary 
    for making calls to Event Hubs REST API.
    """
    uri = quote_plus("https://{}.servicebus.windows.net/{}" \
                                  .format(sb_name, eh_name))
    sas = sas_value.encode('utf-8')
    expiry = str(int(time.time() + 604800))
    print(str(int(time.time())))
    print(expiry)
    string_to_sign = (uri + '\n' + expiry).encode('utf-8')
    signed_hmac_sha256 = hmac.HMAC(sas, string_to_sign, hashlib.sha256)
    signature = quote(base64.b64encode(signed_hmac_sha256.digest()))
    return  {"sb_name": sb_name,
             "eh_name": eh_name,
             "token":'SharedAccessSignature sr={}&sig={}&se={}&skn={}' \
                     .format(uri, signature, expiry, sas_name)
            }

print(get_auth_token(
    'bluetooth-poc-namespace',
    'bluetooth-poc-event-hub',
    'RootManageSharedAccesskey',
    'R/mqADMNldBj5tr1tLKxl6/JxaNuTqhPi+AEhHSBwyY='
))