# Docker Apache 2.4 + SSL + PHP 5.6 + Oracle OCI8 drivers

Docker image based on ubuntu 14.04 with PHP 5.6, Apache 2.4 with SSL and OCI8 driver

## Usage

---

Start your image binding the external ports 80, 443 in all interfaces to your container:

```sh
$ docker run --name my_app -d -p 80:80 -p 443:443 -v $(pwd):/var/www/html paliari/apache-ssl-php56-oci8
```
