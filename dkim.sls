opendkim:
  user.present:
    - fullname: opendkim
    - shell: /bin/false
    - home: /var/run/opendkim
    - uid: {{ pillar['users']['opendkim'] }}
    - gid: {{ pillar['groups']['opendkim'] }}
    - groups:
      - opendkim
  pkg:
    - installed
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/opendkim.conf
    - require:
      - user: opendkim

/etc/opendkim.conf:
  file.managed:
    - source: salt://files/dkim/opendkim.conf
    - user: root
    - group: root
    - mode: 0644
    - template: jinja

/etc/dkim/keylist:
  file.managed:
    - source: salt://files/dkim/keylist
    - user: root
    - group: root
    - mode: 0600
    - template: jinja

{% for keys in pillar['opendkim']['keys'] %}
/etc/dkim/{{ keys }}:
  file.managed:
    - source: salt://files/dkim/{{ keys }}
    - user: root
    - group: root
    - mode: 0600
    - makedirs: True
{% endfor %}
