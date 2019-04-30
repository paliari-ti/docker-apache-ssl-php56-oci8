# paliari/apache-ssl-php56-oci8
Docker image PHP 5.6 and Apache


### Versioning
| Docker Tag | Git Release | Apache Version | PHP Version | Debian Version |
|-----|-------|-----|--------|--------|
| latest | Master Branch | 2.4.25 | 7.3.4 | GNU/Linux 9 |

### Links
- [https://github.com/paliari-ti/docker-apache-ssl-php56-oci8](https://github.com/paliari-ti/docker-apache-ssl-php56-oci8)
- [https://hub.docker.com/r/paliari/apache-ssl-php56-oci8](https://hub.docker.com/r/paliari/apache-ssl-php56-oci8)

## Quick Start
To pull from docker hub:
```
docker pull paliari/apache-ssl-php56-oci8:latest
```
### Running
To simply run the container:
```
sudo docker run -d paliari/apache-ssl-php56-oci8

sduo docker run -p 80:80 -d -e 'WEBROOT=/var/www/html/public' -e 'SET_PHP_INI_ENV=production' -e 'PHP_MEM_LIMIT=20' -e 'PHP_POST_MAX_SIZE=10' -e 'PHP_UPLOAD_MAX_FILESIZE=10' paliari/apache-ssl-php56-oci8:latest
```

### Environments custom
| Name | Type | Default | Info | 
|-----|-----|-----|-----|
| WEBROOT | string | /var/www/html | Set custom webroot |
| PHP_MEM_LIMIT | integer | 128 | Define PHP memory limit in MB |
| PHP_POST_MAX_SIZE | integer | 100 | Define PHP post max size in MB |
| PHP_UPLOAD_MAX_FILESIZE | integer | 100 | Define PHP upload max filesize in MB |
| TIMEZONE | string | UTC | Set custom timezone |
| SET_PHP_INI_ENV | enum(development, production) | | If defined, create /usr/local/etc/php/php.ini (recommended in production) |

### SSL config

The Apache default-ssl.conf makes the require 
```apacheconfig

IncludeOptional conf-available/ssl-private*.conf

```

For SSL custom config, you can mount the volume 

- /etc/apache2/conf-available/ssl-private<-name>.conf


For SSL certificates you must mount the volumes
- /etc/apache2/ssl/cert.crt
- /etc/apache2/ssl/cert.key
- /etc/apache2/ssl/ca.pem

Example:
```bash
docker run --vlume ssl.conf:/etc/apache2/conf-available/ssl-private-you-app.conf \
  --volume your-cert.pem:/etc/apache2/ssl/cert.pem \
  --volume your-cert.key:/etc/apache2/ssl/cert.key \
  --volume your-ca.pem:/etc/apache2/ssl/ca.pem \
  paliari/apache-ssl-php56-oci8:latest

```

