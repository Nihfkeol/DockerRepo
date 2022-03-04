FROM centos:7.9.2009
LABEL version="1.0" \
        maintainer="nihfkeol<blog.nikelike.fun>" \
        description="centos7.9.2009+mysql5.7+java8搭建镜像"
ADD server-jre-8u321-linux-x64.tar.gz /usr/local/
ENV JAVA_HOME=/usr/local/jre
ENV CLASS_PATH=.:$JAVA_HOME/lib
ENV PATH $PATH:$JAVA_HOME/bin

ADD start.sh /usr/local/bin
ADD mysql80-community-release-el7-5.noarch.rpm /usr/local/download/
RUN chmod -R 777 /usr/local/bin/start.sh \
    && yum -y localinstall /usr/local/download/mysql80-community-release-el7-5.noarch.rpm \
    && yum-config-manager --disable mysql80-community \
    && yum-config-manager --enable mysql57-community \
    && yum -y install mysql-community-server \
    && yum clean all

#运行初始化脚本
CMD ["/usr/local/bin/start.sh"]
