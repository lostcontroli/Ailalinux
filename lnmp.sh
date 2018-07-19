#!/bin/bash
set -e
echo "===================================判断系统======================================"
check_sys(){
if [[ -f /etc/redhat-release ]]; then
        release="centos"
		elif cat /etc/issue | grep -q -E -i "debian"; then
        release="debian"
		elif cat /etc/issue | grep -q -E -i "ubuntu"; then
        release="ubuntu"
		elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
		elif cat /proc/version | grep -q -E -i "debian"; then
        release="debian"
		elif cat /proc/version | grep -q -E -i "ubuntu"; then
        release="ubuntu"
		elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
release="centos"
fi
}
check_sys
echo "$release"
echo "=====================================服务部署====================================="
ping -c 3 www.baidu.com
cd /etc/yum.repos.d/
cp -a CentOS-Base.repo CentOS-Base.repo.bak
wget  -O /etc/yum.repos.d/CentOS-Base.repo  http://mirrors.aliyun.com/repo/Centos-6.repo
yum clean all && yum makecache
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config && grep SELINUX /etc/selinux/config
yum -y install pcre-devel zlib-devel gcc*
wget http://nginx.org/download/nginx-1.8.1.tar.gz
tar -xf nginx-1.8.1.tar.gz && cd nginx-1.8.1
useradd -r -s /sbin/nologin nginx
./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_stub_status_module
if [$? -ne 0];then return $?
make && make install
if [$? -ne 0];then return $?
ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/
echo "=====================================服务启动======================================"
/usr/local/nginx/sbin/nginx
netstat -antp | grep :80
cat /etc/hosts
echo -e 'Hello Hangzhou Is So Good' > /usr/local/nginx/html/index.html
echo "====================================配置文件======================================="
cd /usr/local/nginx/conf
cp -a nginx.conf nginx.conf.bak
mv nginx.conf abclinux.conf


