pushd /usr/share/tomcat
openssl genrsa -out ca.key 2048
openssl req \
    -new -x509 \
    -days 365 \
    -key ca.key \
    -subj "/C=UK/ST=Bristol/L=Bristol/O=RedBarn Systems/CN=RAGateway Root CA" \
    -out ca.crt

openssl req \
    -newkey rsa:2048 \
    -nodes \
    -keyout server.key \
    -subj "/C=UK/ST=Bristol/L=Bristol/O=RedBarn Systems/CN=ragateway.redbarnsystems.co.uk" \
    -out server.csr

openssl x509 \
    -req \
    -extfile <(printf "subjectAltName=DNS:ragateway.redbarnsystems.co.uk,IP:10.0.0.1") \
    -days 365 \
    -in server.csr \
    -CA ca.crt \
    -CAkey ca.key \
    -CAcreateserial \
    -out server.crt

openssl pkcs12 -export \
    -in server.crt \
    -inkey server.key \
    -out server.p12 \
    -name "server" \
    -passout pass:Secret.123

chmod +r server.p1
popd
pushd guacamole/
/usr/bin/cp -f RAGateway-master/conf/server.xml /etc/tomcat/server.xml
systemctl restart tomcat
popd
