supervisord_config_file_for_logging_server:
  file.managed:
    - template: jinja
    - name: /etc/supervisor/conf.d/logging_server.conf
    - source: salt://supervisord/project_logging_server.conf.template
