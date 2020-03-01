rtmp_nginx_install_req: 
  pkg.installed:
    - pkg:
      -build-essential
      -libpcre3
      -libpcre3-dev
      -libssl-dev

rtmp_download_nginx_source:
  cmd.run:
    - name: wget http://nginx.org/download/nginx-1.13.7.tar.gz -O /home/{{ grains['deescalated_user'] }}/nginx.tar.gz
    - runas: {{ grains['deescalated_user'] }}

rtmp_download_nginx_rmtp_module:
  cmd.run:
    - name: wget https://github.com/arut/nginx-rtmp-module/archive/master.zip -O /home/{{ grains['deescalated_user'] }}/master.zip
    - runas: {{ grains['deescalated_user'] }}

rtmp_nginx_source_untar:
  cmd.run:
    - name: tar -zxvf /home/{{ grains['deescalated_user'] }}/nginx.tar.gz
    - runas: {{ grains['deescalated_user'] }}

rtmp_module_unzip:
  cmd.run:
    - name: unzip /home/{{ grains['deescalated_user'] }}/master.zip
    - runas: {{ grains['deescalated_user'] }}

rtmp_compile_nginx
  cmd.run:
    - name: ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master; make
    - cwd /home/{{ grains['deescalated_user'] }}/nginx
    - runas: {{ grains['deescalated_user'] }}

rtmp_make_install_nginx
  cmd.run:
    - name: make install

rtmp_nging_conf:
  file.managed:
    - name: /usr/local/nginx/conf/nginx.conf
    - source: salt://rtmp/nginx.conf
    - user: {{ grains['deescalated_user'] }}
    - group: {{ grains['deescalated_user'] }}

rtmp_nginx_restart:
  cmd.run:
    - name: /usr/local/nginx/sbin/nginx -s stop; /usr/local/nginx/sbin/nginx
