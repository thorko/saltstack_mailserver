/etc/procmail:
  file.directory:
    - user: root
    - group: root
    - mode: 0755
    - makedirs: True

/etc/procmailrc:
  file.managed:
    - source: salt://files/procmail/procmailrc
    - user: root
    - group: root
    - mode: 0644

# create logfile
/var/log/procmail:
  file.managed:
    - user: root
    - group: root
    - mode: 0666
    - create: True
