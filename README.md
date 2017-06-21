# 基于 Spring Cloud 的微服务基础框架

本项目是一个基于 Spring Cloud生态圈构建的微服务基础项目。包含了微服务在生产上所用到最基础组件，方便开发人员快速熟悉、构建基于Spring Cloud的微服务系统。

# 技术栈
* Spring boot - 微服务的入门级微框架，用来简化 Spring 应用的初始搭建以及开发过程。
* Eureka - 云端服务发现，一个基于 REST 的服务，用于定位服务，以实现云端中间层服务发现和故障转移。[进一步了解Netflix Eureka](readmore/netflix%20eureka%20basic.md)
* Spring Cloud Config - 配置管理工具包，让你可以把配置放到远程服务器，集中化管理集群配置，目前支持本地存储、Git 以及 Subversion。[进一步了解Spring Cloud Config](readmore/spring%20cloud%20config%20basic.md)
* Hystrix - 熔断器，容错管理工具，旨在通过熔断机制控制服务和第三方库的节点,从而对延迟和故障提供更强大的容错能力。[进一步了解Netflix Hystrix](readmore/netflix%20hystrix%20basic.md)
* Zuul - Zuul 是在云平台上提供动态路由，监控，弹性，安全等边缘服务的框架。Zuul 相当于是设备和 Netflix 流应用的 Web 网站后端所有请求的前门。[进一步了解Netflix Zuul](readmore/netflix%20zuul%20basic.md)
* Spring Cloud Bus - 事件、消息总线，用于在集群（例如，配置变化事件）中传播状态变化，可与 Spring Cloud Config 联合实现热部署。
* Spring Cloud Sleuth - 日志收集工具包，封装了 Dapper 和 log-based 追踪以及 Zipkin 和 HTrace 操作，为 SpringCloud 应用实现了一种分布式追踪解决方案。
* Ribbon - 提供云端负载均衡，有多种负载均衡策略可供选择，可配合服务发现和断路器使用。[进一步了解Netflix Ribbon](readmore/netflix%20ribbon%20basic.md)
* Turbine - Turbine 是聚合服务器发送事件流数据的一个工具，用来监控集群下 hystrix 的 metrics 情况。
* Spring Cloud Stream - Spring 数据流操作开发包，封装了与 Redis、Rabbit、Kafka 等发送接收消息。
* Feign - Feign 是一种声明式、模板化的 HTTP 客户端。[进一步了解Netflix Feign](readmore/netflix%20feign%20basic.md)
* Spring Cloud OAuth2 - 基于 Spring Security 和 OAuth2 的安全工具包，为你的应用程序添加安全控制**（出于简单考虑，本框架不加入该组件）**。
# 应用架构

该项目包含 7 个服务

* registry - 服务注册与发现
* config - 外部配置
* monitor - 监控
* zipkin - 分布式跟踪
* gateway - 代理所有微服务的接口网关
* svca-service - 业务服务A
* svcb-service - 业务服务B

## 体系架构
![architecture](screenshots/architecture.jpg)
## 应用组件
![components](screenshots/components.jpg)

# 启动项目

* 使用 Docker 快速启动
    1. [准备docker环境](readmore/install%20docker.md)和[docker-compose](https://docs.docker.com/compose/install/)
    2. `mvn clean package` 打包项目及 Docker 镜像
    3. 在项目根目录下运行`sh run.sh`(内部执行 `docker-compose up -d`)
* 本地手动启动
    1. 配置 rabbitmq
    2. 修改 hosts 将主机名指向到本地   
       `127.0.0.1	registry config monitor rabbitmq auth-service`  
       或者修改各服务配置文件中的相应主机名为本地 ip
    3. 启动 registry、config、monitor、zipkin
    4. 启动 gateway、auth-service、svca-service、svcb-service

# 项目预览

## 注册中心
访问 http://DOCKER-HOST:8761/ 

![registry](screenshots/registry.jpg)
## 监控
访问 http://DOCKER-HOST:8040/ 
### 控制面板
![monitor](screenshots/monitor1.jpg)
### 应用注册历史
![monitor](screenshots/monitor2.jpg)
### Turbine Hystrix面板
![monitor](screenshots/monitor3.jpg)
### 应用信息、健康状况、垃圾回收等详情
![monitor](screenshots/monitor4.jpg)
### 计数器
![monitor](screenshots/monitor5.jpg)
### 查看和修改环境变量
![monitor](screenshots/monitor6.jpg)
### 管理 Logback 日志级别
![monitor](screenshots/monitor7.jpg)
### 查看并使用 JMX
![monitor](screenshots/monitor8.jpg)
### 查看线程
![monitor](screenshots/monitor9.jpg)
### 认证历史
![monitor](screenshots/monitor10.jpg)
### 查看 Http 请求轨迹
![monitor](screenshots/monitor11.jpg)
### Hystrix 面板
![monitor](screenshots/monitor12.jpg)
## 链路跟踪
访问 http://DOCKER-HOST:9411/ 默认账号 admin，密码 admin
### 控制面板
![zipkin](screenshots/zipkin1.jpg)
### 链路跟踪明细
![zipkin](screenshots/zipkin2.jpg)
### 服务依赖关系
![zipkin](screenshots/zipkin3.jpg)
## RabbitMQ 监控
Docker 启动访问 http://DOCKER-HOST:15673/ 默认账号 guest，密码 guest（本地 rabbit 管理系统默认端口15672）

![rabbit](screenshots/rabbit.jpg)
# 接口测试
1. 访问 service a 接口
```
curl http://DOCKER-HOST:8060/svca
```
返回如下数据：
```
svca-service (172.18.0.8:8080)===>name:zhangxd
svcb-service (172.18.0.2:8070)===>Say Hello
```
2. service b 接口
```
curl http://DOCKER-HOST:8060/svcb
```
返回如下数据：
```
svcb-service (172.18.0.2:8070)===>Say Hello
```
3. 刷新配置（后续更新）