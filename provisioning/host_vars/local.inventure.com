---
app_environment: local
apache_fqdn_path: "/etc/apache2/conf.d/fqdn"
apache_conf_path: "/etc/apache2/conf-available/"
apache_user: "www-data"
root_db_password: c0d3#Mt@an1
mysql_bind_address: "0.0.0.0"
db_user_name: muya
db_user_pass: "!CaputDraconis789#"
vagrant_bashrc_file: /home/vagrant/.bashrc
yii_files_dir_path: /srv/applications/yii-files
yii_sym_link_path: /srv/applications/yii
yii_version: bca0420b6799b0b2a7966aa90bcd15cb4aa73563
root_bashrc_file: /root/.bashrc
db_include_file_path: /etc/apache2/db.include
api_env_name: local
api_server_name: apinew.lh
api_app_path_dir: /srv/applications/Api
api_db_user: inventure_api
api_db_pass: "inventure_api"
api_db_name: "loans_dev"
api_db_file_name: loans_dev.sql
mkopo_rahisi_name: safarinew.lh
mkopo_rahisi_app_path_dir: /srv/applications/MkopoRahisi

# supervisor
supervisor_socket_file: /var/run/supervisor.sock
supervisor_socket_file_mode: "0700"
superviser_inet_http_server_port: 127.0.0.1:9300
superviser_inet_http_username: iv-admin
superviser_inet_http_password: "vL2FwaS12MS5nZW4ubW0udm9kYWZvbmUuY"
supervisor_logfile: /var/log/supervisor/supervisord.log
supervisor_logfile_max_bytes: 50MB
supervisor_logfile_backups: 10
supervisor_loglevel: info
supervisor_pidfile: /var/run/supervisord.pid
supervisor_nodaemon: "false"
supervisor_minfds: 1024  # minimum no. of file descriptors
supervisor_minprocs: 200
supervisor_childlogdir: /var/log/supervisor
supervisorctl_serverurl: unix:///var/run/supervisor.sock
supervisor_include_files: /etc/supervisor/conf.d/*.conf

# whatsapp app
whatsapp_app_git_branch: development
whatsapp_app_debug: "true"
whatsapp_app_username: "254711104372"
whatsapp_app_pass: "0J2yYCcYtwmKwnCLLXc/CSPIJI8="
whatsapp_app_server_host: "192.168.33.10"
whatsapp_app_base_log_path: "/var/log/applications/whatsapp/"
whatsapp_app_base_log_file_name: "whatsapp.log"
whatsapp_app_debug_file_name: "whatsapp-debug.log"
whatsapp_app_db_dir_path: "/data/whatsapp/"
whatsapp_app_db_file_name: "iv_whatsapp.db"
whatsapp_app_db_schema: /srv/applications/whatsapp-app/whatsapp/setup/iv_whatsapp_schema_no_drop.sql
whatsapp_app_config_file: whatsapp-config.json
whatsapp_app_sys_user_group: whatsapp
whatsapp_app_sys_user_name: whatsapp
whatsapp_app_application_dir: /srv/applications/whatsapp-app
whatsapp_app_git_repo_name: "git@github.com:inventure/Whatsapp.git"
whatsapp_app_virtual_env: whatsapp_venv
whatsapp_app_webroot_path: /var/www/whatsapp_api
whatsapp_app_vhost: /etc/apache2/sites-available/whatsapp_api.conf
whatsapp_app_vhost_port: 5001
whatsapp_app_vhost_server_name: local.inventure.com
whatsapp_app_vhost_wsgi_file: /var/www/whatsapp_api/whatsapp_api.wsgi
whatsapp_app_api_name: whatsapp_api
whatsapp_app_apache_user: www-data
whatsapp_app_apache_group: www-data
whatsapp_app_proc_lock_dir: /var/lock/whatsapp/
whatsapp_app_proc_lock_file: whatsapp-proc.lock
whatsapp_app_init_d_file: /etc/init.d/whatsapp_proc
whatsapp_app_logrotate_file: /etc/logrotate.d/whatsapp-app
inventure_base_url: http://api.inventureaccess.com/
inventure_api_people_endpoint: http://apinew.lh/api/People
inventure_api_people_additional_data_endpoint: http://apinew.lh/api/PeopleAdditionalData
inventure_api_loan_application_endpoint: http://apinew.lh/api/LoanApplication
inventure_api_loan_endpoint: http://apinew.lh/api/Loan
inventure_api_transaction_endpoint: http://apinew.lh/api/Transaction
inventure_api_loan_repayment_endpoint: http://apinew.lh/api/LoanRepayment
inventure_api_people_experiment_endpoint: http://localhost:9009/api/PeopleExperiment
inventure_api_experiment_endpoint: http://localhost:9009/api/Experiment
zendesk_company_name: https://inventuremobile1427108962.zendesk.com
zendesk_user: accounts@inventure.com
zendesk_credential: imimmhDDzVB3lVCTZMWkzzYN4c8wFZOFlAIZws0k
zendesk_use_token: "true"
zendesk_msg_source_custom_field_id: 24218325
zendesk_last_msg_delivered_custom_field_id: 24329225
zendesk_last_msg_read_custom_field_id: 24329235
zendesk_recently_updated_tickets_view_id: 43236089
zendesk_admin_requester_id: 686769609
incoming_messages_proc_app_proc_lock_dir: /var/lock/incoming-messages-proc/
incoming_messages_proc_app_proc_lock_file: im-proc.lock
incoming_messages_app_base_log_path: "/var/log/applications/incoming-msg-proc/"
incoming_messages_app_base_log_file: "im_proc.log"
incoming_messages_init_d_file: /etc/init.d/im_proc
inventure_config_path: /etc/inventure
zd_app_db_dir_path: "/data/inventure/zendesk"
zd_app_db_file_name: zendesk_data.db
zd_app_db_schema: /srv/applications/whatsapp-app/whatsapp/setup/iv_zd_schema_no_drop.sql
zd_incoming_req_endpoint: http://localhost:5004/messaging/incoming/zendesk

# base db configs
iv_services_db_name: inventure_services
iv_services_db_host: localhost
iv_services_db_user: inventure_api
iv_services_db_pass: inventure_api

# slack
slack_incoming_webhook_endpoint: https://hooks.slack.com/services/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
dev_slack_alert_handles: "@fred"

# memcache
memcache_server: "127.0.0.1"
memcache_port: "11211"

# telerivet
telerivet_key: "PZP9RZFF7HZHDKHCQMPUGCKQT76WWM4M"
telerivet_api_key: "2kuZtbRlDr1dcSaG82ADk73H1zIqycn0"
telerivet_project_id: "PJ006c5db56496f4c5fc53eb12bb960cb9"
telerivet_sender_phone_id: "PNe71f1b6fc0ae4cf5"
telerivet_notification_endpoint: "http://iv-local-messaging.vagrantshare.com/messaging/incoming/telerivet/notify"


# messaging-app
messaging_conf_file: messaging-config.json
messaging_app_debug: "true"
messaging_app_base_log_path: "/var/log/applications/messaging/"
messaging_base_log_file_name: "messaging.log"
messaging_debug_file_name: "messaging_debug.log"
messaging_app_logrotate_file: /etc/logrotate.d/messaging-app
messaging_app_server_host: "192.168.33.10"
messaging_app_webroot_path: /var/www/inventure_messaging
messaging_app_vhost: /etc/apache2/sites-available/inventure_messaging.conf
messaging_app_vhost_port: 5004
messaging_app_vhost_port_tr: 8000
messaging_app_vhost_server_name: local.inventure.com
messaging_app_vhost_wsgi_file: /var/www/inventure_messaging/inventure_messaging.wsgi
messaging_api_name: inventure_messaging
survey_proc_app_base_log_file: survey_proc.log

# zd-sync-app
zd_sync_conf_file: zendesk-sync-config.json
zd_sync_app_debug: "true"
zd_sync_app_base_log_path: "/var/log/applications/zd-sync/"
zd_sync_base_log_file_name: "zd_sync.log"
zd_sync_debug_file_name: "zd_sync_debug.log"
zd_sync_app_debug_tr: "true"
zd_sync_base_log_file_name_tr: "telerivet_zd_sync.log"
zd_sync_debug_file_name_tr: "telerivet_zd_sync_debug.log"
zd_sync_app_debug_zd_data: "true"
zd_sync_base_log_file_name_zd_data: "zd_data_zd_sync.log"
zd_sync_debug_file_name_zd_data: "zd_data_zd_sync_debug.log"
zd_sync_app_tr_sleep_time: 2
zd_sync_app_server_host: "192.168.33.10"
zd_sync_app_webroot_path: /var/www/zd_sync
zd_sync_app_vhost_port: 5003
zd_sync_app_vhost_server_name: local.inventure.com
zd_sync_app_vhost_wsgi_file: /var/www/zd_sync/zd_sync_api.wsgi
zd_sync_api_name: zd_sync_api
zd_sync_app_vhost: /etc/apache2/sites-available/zd_sync_api.conf
zd_sync_app_db_file_name: zendesk_sync.db
zd_sync_app_db_schema: /srv/applications/whatsapp-app/whatsapp/setup/iv_zd_sync_schema_no_drop.sql
sync_zd_last_msg_status_proc_app_lock_dir: /var/lock/zd-sync-last-msg-proc/
sync_zd_last_msg_status_proc_app_lock_file: zd-sync-last-msg.lock
sync_zd_last_msg_status_init_d_file: /etc/init.d/zd_sync_msg_status
sync_zd_telerivet_proc_app_lock_dir: /var/lock/zd-sync-telerivet-msg-proc/
sync_zd_telerivet_proc_app_lock_file: zd-sync-telerivet-msg.lock
sync_zd_telerivet_init_d_file: /etc/init.d/zd_sync_telerivet
sync_zd_app_logrotate_file: /etc/logrotate.d/zd-sync-app

# zendesk db configs
zd_mysql_db_name: zendesk_data
zd_mysql_db_host: localhost
zd_mysql_db_user: inventure_api
zd_mysql_db_pass: inventure_api

# zd-ticket-proc app
zd_ticket_proc_app_debug: "true"
zd_ticket_proc_app_base_log_path: "/var/log/applications/zd-ticket-proc/"
zd_ticket_proc_base_log_file_name: "zd-ticket-proc.log"
zd_ticket_proc_debug_file_name: "zd-ticket-proc-debug.log"
zd_ticket_proc_conf_file: zendesk-ticket-proc-config.json
zd_ticket_proc_app_server_host: "192.168.33.10"
zd_ticket_proc_app_webroot_path: /var/www/zd_ticket_proc
zd_ticket_proc_app_vhost_port: 5002
zd_ticket_proc_app_vhost_server_name: local.inventure.com
zd_ticket_proc_app_vhost_wsgi_file: /var/www/zd_ticket_proc/zd_ticket_proc_api.wsgi
zd_ticket_proc_app_vhost: /etc/apache2/sites-available/zd_ticket_proc_api.conf
zd_ticket_proc_api_name: zd_ticket_proc_api
zd_ticket_proc_app_logrotate_file: /etc/logrotate.d/zd-ticket-proc-app

# payments app
payments_app_application_dir: /srv/applications/payments
payments_app_webroot_path: /var/www/payments
payments_app_vhost: /etc/apache2/sites-available/payments.conf
payments_server_port: 80
payments_server_host_name: payments.local.inventure.com
payments_server_cert_path: /etc/pki/tls/certs/payments/wildcard.crt
payments_server_cert_key: /etc/pki/tls/certs/payments/wildcard.key
payments_app_host: http://payments.local.inventure.com
payments_app_debug: true
payments_app_key: HA6Ly9hcGktdjEuZ2VuLm1tLnZvZGFmb
payments_app_db_user: payments_app
payments_app_db_pass: W1ldGVyPjxLZXkgeG1sbnM9Imh0dHA6Ly9hc
payments_app_db_host: localhost
payments_app_db_name: payments_dev
payments_app_base_log_path: "/var/log/applications/payments/"
payments_app_base_log_file_name: "payments.log"
payments_app_test_base_log_file_name: "payments_test.log"
payments_app_logrotate_file: /etc/logrotate.d/payments-app
payments_app_default_log_level: DEBUG
payments_app_inventure_c2b_endpoint: ""
payments_app_send_slack_alert: true

# payments service specific config
# tigo tz
payments_app_tz_tigo_port: 8410
payments_app_tz_tigo_b2c_trx_type: REQMFICI
payments_app_tz_tigo_b2c_partner_msisdn: 0715667883
payments_app_tz_tigo_b2c_partner_key: 1234
payments_app_tz_tigo_b2c_partner_lang: en
payments_app_tz_tigo_c2b_trx_type: SYNC_BILLPAY_RESPONSE
payments_app_tz_tigo_c2b_customer_msg_template: "Your payment of %.2f TSh to Mkopo Rahisi for account %s has been received. Thank you for your payment."
payments_app_tz_tigo_b2c_api_endpoint: http://accessgwtest.tigo.co.tz:8080/inventuretotigotest
payments_app_tz_tigo_storage_path: "storage/app/tz"
payments_app_tz_tigo_acc_bal_storage_file_path: "tz/tigo_acc_bal"
payments_app_tz_tigo_acc_bal_min_limit: 20000000

# airtel ke
payments_app_ke_airtel_c2b_port: 8500
payments_app_ke_airtel_c2b_customer_msg_template: "Your payment of %.2f Ksh to Mkopo Rahisi for account %s has been received. Thank you for your payment."
payments_app_ke_airtel_c2b_merchant_query_wsdl: https://41.223.56.58:7445/MerchantQueryService.asmx?wsdl
payments_app_ke_airtel_c2b_merchant_query_user: 9031258
payments_app_ke_airtel_c2b_merchant_query_key: INVENTURE
payments_app_ke_airtel_b2c_payment_department: Loans
payments_app_ke_airtel_b2c_access_key: iUbLnu70RqtUQrHFE2Nb6Dzgh9TX5tuuRh6J7txg
payments_app_ke_airtel_b2c_api_endpoint: https://bulk-dev.aida.co.ke/api/v1/disburse-payments
payments_app_ke_airtel_b2c_api_payment_status_endpoint: https://bulk-dev.aida.co.ke/api/v1/check-payment-status/
payments_app_ke_airtel_b2c_api_account_balance_endpoint: https://bulk-dev.aida.co.ke/api/v1/check-balance
