/etc/dovecot/conf.d:
  file.recurse:
    - source: salt://files/dovecot/conf.d
    - include_empty: True
    - user: root
    - group: root
    - require:
      - pkg: dovecot-packages

/etc/dovecot/dovecot.conf:
  file.managed:
    - source: salt://files/dovecot/dovecot.conf
    - user: root
    - group: root
    - require:
      - pkg: dovecot-packages

# mysql config for dovecot
/etc/dovecot/dovecot-mysql.conf:
  file.managed:
    - source: salt://files/dovecot/dovecot-mysql.conf
    - user: root
    - group: root
    - template: jinja
    - require:
      - pkg: dovecot-packages

dovecot-packages:
   pkg.installed:
     - pkgs:
       - dovecot-mysql
       - dovecot-sieve
       - dovecot-imapd

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
