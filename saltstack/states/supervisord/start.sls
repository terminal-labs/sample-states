reread_service:
  cmd.run:
    - name: supervisorctl reread

start_service:
  cmd.run:
    - name: supervisorctl update
