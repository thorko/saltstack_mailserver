/etc/sqlgrey:
  file.directory:
    - user: sqlgrey
    - group: sqlgrey
    - makedirs: True
    - mode: 0755
    - clean: True

/etc/sqlgrey/sqlgrey.conf:
  file.managed:
    - source: salt://files/sqlgrey/sqlgrey.conf
    - user: sqlgrey
    - group: sqlgrey
    - mode: 0644
    - template: jinja

sqlgrey:
  mysql_user.present:
    - host: localhost
    - password: {{ pillar['sqlgrey']['db_pass'] }}
    - connection_user: {{ pillar['mysql']['root_user'] }}
    - connection_pass: {{ pillar['mysql']['root_pass'] }}
    - connection_charset: utf8
    - saltenv:
      - LC_ALL: "en_US.utf8"
  group.present:
    - system: true
    - gid: {{ pillar['groups']['sqlgrey'] }}
  user.present:
    - fullname: sqlgrey
    - shell: /bin/false
    - home: /usr/local/sqlgrey/current
    - uid: {{ pillar['users']['sqlgrey'] }}
    - gid: {{ pillar['groups']['sqlgrey'] }}
    - groups:
      - sqlgrey
  service:
    - running
    - enable: True
    - sig: sqlgrey
    - watch:
      - file: /etc/sqlgrey/sqlgrey.conf
    - require:
      - user: sqlgrey

sqlgrey_sqlgreydb:
  mysql_grants.present:
    - grant: all privileges
    - database: {{ pillar['sqlgrey']['db_name'] }}.*
    - user: {{ pillar['sqlgrey']['db_user'] }}
    - host: localhost
    - connection_user: {{ pillar['mysql']['root_user'] }}
    - connection_pass: {{ pillar['mysql']['root_pass'] }}
