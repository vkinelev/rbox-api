cert_store = OpenSSL::X509::Store.new
certificate = OpenSSL::X509::Certificate.new ENV["DOCKER_CA"]
cert_store.add_cert certificate

Docker.options = {
  client_cert_data: ENV["DOCKER_CERT"],
  client_key_data: ENV["DOCKER_KEY"],
  ssl_cert_store: cert_store,
  scheme: 'https'
}
