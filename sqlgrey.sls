/etc/sqlgrey:
  file.directory:
    - user: sqlgrey
    - group: sqlgrey
    - makedirs: True
    - mode: 0755
    - clean: True
    - require:
      - user: sqlgrey
      - group: sqlgrey

{% for conf in 'clients_fqdn_whitelist', 'clients_ip_whitelist', 'discrimination.regexp', 'dyn_fqdn.regexp', 'smtp_server.regexp' %}
/etc/sqlgrey/{{ conf }}:
  file.managed:
    - source: salt://files/sqlgrey/{{ conf }}
    - user: sqlgrey
    - group: sqlgrey
    - mode: 0644
    - require:
      - user: sqlgrey
      - group: sqlgrey
{% endfor %}

/etc/sqlgrey/sqlgrey.conf:
  file.managed:
    - source: salt://files/sqlgrey/sqlgrey.conf
    - user: sqlgrey
    - group: sqlgrey
    - mode: 0644
    - template: jinja
    - require:
      - user: sqlgrey
      - group: sqlgrey

sqlgrey:
  pkg:
    - installed
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
  user.present:
    - fullname: sqlgrey
    - shell: /bin/false
    - home: /var/lib/sqlgrey
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
