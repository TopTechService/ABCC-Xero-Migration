public with sharing class RsaSha1Signer {

	public Map<string, string> CreateSignature(String certificate, String ConsumerKey, String uri, String method) {

    	String uriEncoded = EncodingUtil.urlEncode(uri, 'UTF-8');

        String nonce = String.valueOf(Crypto.getRandomLong());
        String timestamp = String.valueOf(DateTime.now().getTime()/1000);
        
        String oAuthParameters = 'oauth_consumer_key=' + ConsumerKey;
        oAuthParameters += '&oauth_nonce=' + nonce;
        oAuthParameters += '&oauth_signature_method=' + 'RSA-SHA1';
        oAuthParameters += '&oauth_timestamp=' + timestamp;
        oAuthParameters += '&oauth_token=' + ConsumerKey;
        oAuthParameters += '&oauth_version=1.0';

        String oAuthParametersEncoded = EncodingUtil.urlEncode(oAuthParameters, 'UTF-8');

        string baseString = createBaseString(method, uriEncoded, oAuthParametersEncoded);
        
        blob privatekeyBlob = EncodingUtil.base64Decode(certificate);
        Blob sign = Crypto.sign('RSA-SHA1', Blob.valueOf(baseString), privatekeyBlob);
        String signature = EncodingUtil.base64Encode(sign);
        
        string signatureEncoded = EncodingUtil.urlEncode(signature,'UTF-8');

        Map<String, String> oauthParams = new Map<String, String>();
        oauthParams.put('oauth_consumer_key', ConsumerKey);
        oauthParams.put('oauth_nonce', nonce);
        oauthParams.put('oauth_signature', signatureEncoded);
        oauthParams.put('oauth_signature_method', 'RSA-SHA1');
        oauthParams.put('oauth_timestamp', timestamp);
        oauthParams.put('oauth_token', ConsumerKey);
        oauthParams.put('oauth_version', '1.0');

        return oauthParams;
    }

    private String createBaseString(String method, String uriEncoded, String oAuthParametersEncoded){
    	return method + '&' + uriEncoded + '&' + oAuthParametersEncoded;
    }
}