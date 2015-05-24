{% for sql_conf in 'relay_domains', 'virtual_alias_maps', 'virtual_mailbox_domains', 'virtual_mailbox_maps' %}
/etc/postfix/mysql/{{ sql_conf }}.cf:
  file.managed:
    - source: salt://files/postfix/mysql/{{ sql_conf }}.cf
    - include_empty: True
    - user: postfix
    - group: postfix
    - template: jinja
{% endfor %}

{% for cfg in 'main.cf', 'master.cf' %}
/etc/postfix/{{ cfg }}:
  file.managed:
    - source: salt://files/postfix/{{ cfg }}
    - user: postfix
    - group: postfix
    - template: jinja
    - mode: 0644
{% endfor %}

# copy ssl certs
/etc/postfix/ssl:
  file.recurse:
    - source: salt://files/postfix/ssl
    - user: postfix
    - group: postfix
    - file_mode: 0644
    - dir_mode: 0755
    - include_empty: True

# this is for googlemail
/etc/postfix/transport_map.db:
  file.managed:
    - source: salt://files/postfix/transport_map.db
    - user: postfix
    - group: postfix
    - mode: 0644

postfix:
  pkg:
    - installed
  mysql_user.present:
    - host: localhost
    - password: {{ pillar['postfix']['db_pass'] }}
    - connection_user: {{ pillar['mysql']['root_user'] }}
    - connection_pass: {{ pillar['mysql']['root_pass'] }}
    - connection_charset: utf8
    - saltenv:
      - LC_ALL: "en_US.utf8"
  user.present:
    - fullname: Postfix mail user
    - home: /var/spool/postfix
    - shell: /bin/false
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/postfix/main.cf
      - file: /etc/postfix/master.cf
      - file: /etc/postfix/transport_map.db
    - require:
      - user: postfix

postfix_postfixdb:
  mysql_grants.present:
    - grant: all privileges
    - database: {{ pillar['postfix']['db_name'] }}.*
    - user: {{ pillar['postfix']['db_user'] }}
    - host: localhost
    - connection_user: {{ pillar['mysql']['root_user'] }}
    - connection_pass: {{ pillar['mysql']['root_pass'] }}
