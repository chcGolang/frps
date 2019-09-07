#!/bin/bash
#########################################################################
# File Name: frps.sh
# Version:2.0.20190226
# Created Time: 2019-02-26
#########################################################################

set -e
FRPS_BIN="/frps/frps"
FRPS_CONF="/frps/conf/frps.ini"
FRPS_LOG="/frps/log/frps.log"
# ======= FRPS CONFIG ======
set_token=${set_token:-password}                               #token = password
set_subdomain_host=${set_subdomain_host:-}                     #subdomain_host =
set_dashboard_user=${set_dashboard_user:-admin}                #dashboard_user = admin
set_dashboard_pwd=${set_dashboard_pwd:-admin}                  #dashboard_pwd = admin
set_max_pool_count=${set_max_pool_count:-50}                   #max_pool_count = 50
set_max_ports_per_client=${set_max_ports_per_client:-0}        #max_ports_per_client = 0
set_log_level=${set_log_level:-info}                           #log_level = info
set_log_max_days=${set_log_max_days:-3}                        #log_max_days = 3
set_tcp_mux=${set_tcp_mux:-true}                               #tcp_mux = true

[ ! -f ${FRPS_CONF} ] && cat > ${FRPS_CONF}<<-EOF
# [common] is integral section
# [common] is integral section
[common]
# 服务ip地址
# frp的服务端口号
bind_addr = 0.0.0.0
bind_port = 7000

# udp 端口
bind_udp_port = 7001

# kcp绑定的端口,可以和 bind_port 一样
kcp_bind_port = 7000

# specify which address proxy will listen for, default value is same with bind_addr
# proxy_bind_addr = 127.0.0.1

# 设置http和https穿透的服务端口
# 注意:http端口和https端口可以与bind_port相同
vhost_http_port = 7000
vhost_https_port = 7000

# http服务器响应头超时(秒)，默认为60s
# vhost_http_timeout = 60

# frps控制台
# dashboard_addr的默认值与bind_addr相同
# 只有设置了dashboard_port，仪表板才可用
dashboard_addr = 0.0.0.0
dashboard_port = 7500

# 日志文件
log_file = ${FRPS_LOG}

# 日志级别:trace, debug, info, warn, error
log_level = ${set_log_level}

# 日志保存天数
log_max_days = ${set_log_max_days}

# frps的认证密码，用于客户端连接
token = ${set_token}

# heartbeat configure, it's not recommended to modify the default value
# the default value of heartbeat_timeout is 90
# heartbeat_timeout = 90

#  可以配置允许使用的某个指定端口或者是一个范围内的所有端口，以 , 分隔，指定的范围以 - 分隔。
# allow_ports = 2000-3000,3001,3003,4000-50000

# 设置每个代理可以创建的连接池上限,客户端设置超过此配置后会被调整到当前
max_pool_count = ${set_max_pool_count}

# 每个客户端可以使用最大端口，默认值为0表示没有限制
max_ports_per_client = ${set_max_ports_per_client}

# frps子域名设置，默认为空，可以输入类似abc.com这样的域名
subdomain_host = ${set_subdomain_host}

# 是否tcp流多路复用
tcp_mux = ${set_tcp_mux}
EOF

echo "+---------------------------------------------+"
echo "|              Frps On Docker                 |"
echo "+---------------------------------------------+"
echo "+---------------------------------------------+"
echo "|     Intro: https://github.com/chcGolang     |"
echo "+---------------------------------------------+"
echo " dashboard_user = ${set_dashboard_user}"
echo " dashboard_pwd = ${set_dashboard_pwd}"
echo " token = ${set_token}"
echo " subdomain_host = ${set_subdomain_host}"
echo " max_pool_count = ${set_max_pool_count}"
echo " max_ports_per_client = ${set_max_ports_per_client}"
echo " authentication_timeout = ${set_authentication_timeout}"
echo " log_level = ${set_log_level}"
echo " log_max_days = ${set_log_max_days}"
echo " tcp_mux = ${set_tcp_mux}"
echo "+---------------------------------------------+"
rm -f ${FRPS_LOG} > /dev/null 2>&1
echo "Starting frps $(${FRPS_BIN} -v) ..."
${FRPS_BIN} -c ${FRPS_CONF} &
sleep 0.3
netstat -ntlup | grep "frps"
exec "tail" -f ${FRPS_LOG}
