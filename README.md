# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Next...

4. Ruby version in git-server is 2.1 (it is installed with apt-get). This version does not have Net::HTTP.post

# Notes

1. rails new . --force --database=sqlite3 --skip-coffee

2. Use reverse-proxy to host multiple sandboxes on the same ip/port

3. Set insecure registry

{
  "insecure-registries" : ["192.168.99.100:5000"]        
}
