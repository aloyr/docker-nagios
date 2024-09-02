FROM rockylinux:9
ARG NAGIOS_VERSION="4.5.4"
ENV NAGIOS_VERSION=$NAGIOS_VERSION
ARG NAGIOS_PLUGINS_VERSION="2.4.11"
ENV NAGIOS_PLUGINS_VERSION=$NAGIOS_PLUGINS_VERSION
ARG NAGIOS_NRPE_VERSION="4.1.1"
ENV NAGIOS_NRPE_VERSION=$NAGIOS_NRPE_VERSION
ADD https://github.com/NagiosEnterprises/nagioscore/releases/download/nagios-${NAGIOS_VERSION}/nagios-${NAGIOS_VERSION}.tar.gz /usr/local/src/
ADD https://nagios-plugins.org/download/nagios-plugins-${NAGIOS_PLUGINS_VERSION}.tar.gz /usr/local/src/
ADD https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-${NAGIOS_NRPE_VERSION}/nrpe-${NAGIOS_NRPE_VERSION}.tar.gz /usr/local/src/
RUN dnf -y install dnf-plugins-core;
RUN dnf -y config-manager --set-enabled crb devel extras plus;
RUN dnf -y install epel-release;
RUN dnf -y \
      install \
        bind-utils \
        compat-openssl11 \
        fping \
        gzip \
        gd-devel \
        glibc-devel \
        gnutls-devel \
        kernel-headers \
        krb5-devel \
        libdb-devel \
        libdb-utils \
        libgdata \
        libgdata-devel \
        libpq \
        libpq-devel \
        libtool-ltdl-devel \
        mysql-common \
        mysql-devel \
        net-snmp \
        net-snmp-devel \
        net-snmp-perl \
        net-snmp-utils \
        openldap-clients \
        openldap-devel \
        openssl-devel \
        perl \
        perl-devel \
        perl-Text-Glob \
        perl-Time-ParseDate \
        postfix \
        procps-ng \
        qstat \
        rpcbind \
        samba-client \
        samba-devel \
        sudo \
        sudo-devel \
        s-nail \
        traceroute \
        which;
RUN dnf -y group install "Development Tools";
RUN cd /usr/bin; \
    ln -s python3 python; \
    cd /usr/local/src; \
    tar -zvxf nagios-${NAGIOS_VERSION}.tar.gz; \
    ls -l /usr/local/src; \
    cd nagios-${NAGIOS_VERSION}; \
    ./configure; \
    make all -j8; \
    make install test; \
    make install; \
    make install-init; \
    make install-daemoninit; \
    make install-groups-users; \
    make install-commandmode; \
    make install-config; \
    make install-webconf; \
    make install-exfoliation; \
    make install-classicui;
RUN cd /usr/local/src; \
    tar -zvxf nagios-plugins-${NAGIOS_PLUGINS_VERSION}.tar.gz; \
    cd nagios-plugins-${NAGIOS_PLUGINS_VERSION}; \
    ./configure; \
    make -j8; \
    make install; \
    make install-root;
RUN cd /usr/local/src; \
    tar -zvxf nrpe-${NAGIOS_NRPE_VERSION}.tar.gz; \
    cd nrpe-${NAGIOS_NRPE_VERSION}; \
    ./configure; \
    make all; \
    make install; \
    make install-groups-users; \
    make install-plugin; \
    make install-daemon; \
    make install-config; \

