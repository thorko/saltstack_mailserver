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
    - require:
      - group: spampd

/etc/default/spampd:
  file.managed:
    - source: salt://files/spampd/spampd
    - user: root
    - group: root
    - mode: 0644

{% for spam in 'keys.text', 'channels.text' %}
/etc/spamassassin/{{ spam }}:
  file.managed:
    - source: salt://files/spamassassin/{{ spam }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: spamassassin
{% endfor %}

/etc/spamassassin/local.cf:
   file.managed: 
     - source: salt://files/spamassassin/local.cf
     - user: root
     - group: root
     - mode: 0644
     - template: jinja
     - require:
       - pkg: spamassassin

/etc/spamassassin/update-spamassassin.sh:
  file.managed:
    - source: salt://files/spamassassin/update-spamassassin.sh
    - user: root
    - group: root
    - mode: 0755
    - require:
      - pkg: spamassassin

spamd:
  group.present:
    - system: true
  user.present:
    - fullname: spamd
    - shell: /bin/false
    - home: /var/spool/bayes
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
    - require:
      - user: spamd
      - pkg: spamassassin

spampd:
  pkg: 
    - installed
  group.present:
    - system: True
  user.present:
    - fullname: spampd
    - shell: /bin/false
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
