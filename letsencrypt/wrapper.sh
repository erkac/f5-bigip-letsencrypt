#!/bin/bash

MAILRCPT="example@example.com"
MAILFROM="f5@example"
MAILSERVER="mail.example.com"
MAILSERVERPORT="25"
LOGFILE="/var/log/letsencrypt.log"
DATE=$(date)
SENDMAIL="/shared/letsencrypt/send_mail"
MAILFILE="/var/tmp/mail.txt"
date >$LOGFILE 2>&1
echo "" > $MAILFILE

send_status_mail () {
  local message=$1
  cat <<-EOF >$MAILFILE
From: $MAILFROM
To: $MAILRCPT
Date: $DATE
Subject: $message
EOF
  cat $LOGFILE >> $MAILFILE
  echo -e "\n" >> $MAILFILE # send_mail detects body by empty line
  $SENDMAIL $MAILSERVER $MAILSERVERPORT $MAILFILE >/dev/null 2>&1
}

#cd /shared/scripts


ME=`echo $HOSTNAME|awk -F. '{print $1}'`
ACTIVE=$(tmsh show cm failover-status | grep ACTIVE | wc -l)

if [[ "${ACTIVE}" = "1" ]]; then
    echo "Unit is active - proceeding..."
    exec >/var/log/letsencrypt.log 2>&1
    ./dehydrated -c
    send_status_mail "Lets Encrypt Report $ME"
fi
