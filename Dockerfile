FROM webdevops/php-nginx:7.4
COPY . /app
WORKDIR /app
RUN [ "sh", "-c", "cp .env.example .env && php -r \"file_put_contents('.env', str_replace('{app_key}', 'base64:' . base64_encode(random_bytes(32)), file_get_contents('.env')));\"" ]
RUN [ "sh", "-c", "composer install --ignore-platform-reqs" ]
RUN [ "sh", "-c", "chmod -R 777 /app" ]
