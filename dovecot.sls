/etc/dovecot/conf.d:
  file.recurse:
    - source: salt://files/dovecot/conf.d
    - include_empty: True
    - user: root
    - group: root

/etc/dovecot/dovecot.conf:
  file.managed:
    - source: salt://files/dovecot/dovecot.conf
    - user: root
    - group: root

# mysql config for dovecot
/etc/dovecot/dovecot-mysql.conf:
  file.managed:
    - source: salt://files/dovecot/dovecot-mysql.conf
    - user: root
    - group: root
    - template: jinja

/usr/local/bin/doveadm:
  file.symlink:
    - target: /usr/local/dovecot/current/bin/doveadm
    - force: true

dovecot:
   group.present:
     - system: true
   user.present:
     - fullname: dovecot
     - home: /var/spool/dovecot
     - shell: /bin/false
     - groups:
       - dovecot
   service:
     - running
     - sig: dovecot
     - watch:
       - file: /etc/dovecot/dovecot.conf
       - file: /etc/dovecot/dovecot-mysql.conf
     - require:
       - user: dovecot
       - file: /etc/dovecot/dovecot.conf
       - file: /etc/dovecot/dovecot-mysql.conf
