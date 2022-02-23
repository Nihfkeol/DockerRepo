# 自用Docker镜像

centos7.9.2009 + mysql5.7组合



# 构建镜像

下载文件构建

```shell
docker build -t [ImageName]:tag .
```

或者拉取容器容器

```shell
docker pull nihfkeol/ninicentos7:1.3
```



# 启用镜像

```shell
docker run -it -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root [镜像id]
```



参考[博客](https://www.cnblogs.com/zphqq/p/13123910.html)

