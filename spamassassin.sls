/var/spool/bayes:
  file.directory:
    - user: root
    - group: root
    - mode: 0777
    - makedirs: True

/etc/spampd.conf:
  file.managed:
    - source: salt://files/spampd/spampd.conf
    - user: root
    - group: spampd
    - mode: 0640

/etc/default/spampd:
  file.managed:
    - source: salt://files/spampd/spampd
    - user: root
    - group: root
    - mode: 0644

{% for spam in 'thorko_rules.cf', 'keys.text', 'channels.text' %}
/etc/spamassassin/{{ spam }}:
  file.managed:
    - source: salt://files/spamassassin/{{ spam }}
    - user: root
    - group: root
    - mode: 0644
{% endfor %}

/etc/spamassassin/local.cf:
   file.managed: 
     - source: salt://files/spamassassin/local.cf
     - user: root
     - group: root
     - mode: 0644
     - template: jinja

/etc/spamassassin/update-spamassassin.sh:
  file.managed:
    - source: salt://files/spamassassin/update-spamassassin.sh
    - user: root
    - group: root
    - mode: 0755

spamd:
  group.present:
    - system: true
    - gid: {{ pillar['groups']['spamd'] }}
  user.present:
    - fullname: spamd
    - shell: /bin/false
    - home: /var/spool/bayes
    - uid: {{ pillar['users']['spamd'] }}
    - gid: {{ pillar['groups']['spamd'] }}
    - groups:
      - spamd

spamassassin:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/spamassassin/local.cf
      - file: /etc/spamassassin/thorko_rules.cf
    - require:
      - user: spamd
      - pkg: spamassassin

spampd:
  pkg: 
    - installed
  user.present:
    - fullname: spampd
    - shell: /bin/false
    - uid: {{ pillar['users']['spampd'] }}
    - gid: {{ pillar['groups']['spampd'] }}
    - groups:
      - spampd
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/spampd.conf
    - require:
      - user: spampd
      - pkg: spampd
