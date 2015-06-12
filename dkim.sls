# create key if not existing
{% if 1 == salt['cmd.retcode']("test -f /etc/dkim/{{ pillar['opendkim']['domain'] }}.private") %}
/usr/bin/opendkim-genkey -D /etc/dkim -d {{ pillar['opendkim']['domain'] }}.de -s {{ pillar['opendkim']['domain'] }}:
  cmd.run:
    - user: root
    - group: root
    - shell: /bin/bash
{% endif %}

opendkim:
  user.present:
    - fullname: opendkim
    - shell: /bin/false
    - home: /var/run/opendkim
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
