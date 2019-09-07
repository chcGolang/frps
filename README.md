# frps
* frp的服务端
* 版本: 0.24.1
* 官方中文文档:[https://github.com/fatedier/frp/blob/master/README_zh.md](https://github.com/fatedier/frp/blob/master/README_zh.md)
## 启动命令
	```bash
	docker run --name frps -d \
	-p 7000:7000/tcp \
	-p 7000:7000/udp \
	-p 7001:7001/udp \
	-p 7500:7500/tcp \
	-e set_token=password \
	-e set_max_pool_count=50 \
	-e set_log_level=info \
	-e set_log_max_days=3 \
	chcgolang/frps:latest
	```

## 端口说明

| Docker内定义 | Docker内默认值  | 描述 |
| :------------------- |:-----------:| :------------------------------------- |
| bind_port        | 7000(TCP)        | frps服务端口                           |
| kcp_bind_port    | 7000(UDP)        | KCP加速端口                            |
| bind_udp_port    | 7001(UDP)        | udp端口帮助udp洞洞穿nat                 |
| dashboard_port   | 7500(TCP)        | Frps控制台端口                         |
| vhost_http_port  | 7000(TCP)          | http穿透的端口。                        |
| vhost_https_port | 7000(TCP)         | https穿透服务的端口                     |

## 启动参数说明

| 变量名 | 默认值  | 描述 |
| :-------------------------- |:-----------:| :------------------------------------------------ |
| set_token                   | password    | frps的认证密码，用于客户端连接                         |
| set_subdomain_host          |             | frps子域名设置，默认为空，可以输入类似abc.com这样的域名   |
| set_max_pool_count          | 50          | 每个代理可以创建的连接池上限<br>客户端设置超过此配置后会被调整到当前                          |
| set_max_ports_per_client    | 0           | 允许连入的最大客户端，0为不限制                        |
| set_log_level               | info        | 日志等级，可选项：debug, info, warn, error           |
| set_log_max_days            | 3           | 日志保存天数，默认保存3天的                            |
| set_tcp_mux                 | true        | TCP 多路复用                                       |
