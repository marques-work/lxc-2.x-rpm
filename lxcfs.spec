Name:     lxcfs
Version:  2.0.2
Release:  1%{?dist}
Summary:  FUSE filesystem for LXC
Group:    Applications/System
License:  Apache v.2
URL:      https://github.com/lxc/lxcfs
Source0:  https://linuxcontainers.org/downloads/%{name}/%{name}-%{version}.tar.gz
BuildRequires: pam-devel
BuildRequires: fuse-devel
Requires: fuse-libs

%description
FUSE filesystem for LXC, offering the following features:
 - a cgroupfs compatible view for unprivileged containers
 - a set of cgroup-aware files:
   - cpuinfo
   - meminfo
   - stat
   - uptime

In other words, it will provide an emulated /proc and /sys/fs/cgroup folder for the containers.

%global pam_name pam_cgfs

%package %pam_name
Summary: %summary
Group: System/Base

%description %pam_name
%summary
This package provides a Pluggable Authentication Module (PAM) to provide
logged-in users with a set of cgroups which they can administer.
This allows for instance unprivileged containers, and session
management using cgroup process tracking.

%prep
%setup

%build
%configure --with-init-script=sysvinit
make

%install
%{make_install}
mkdir -p %buildroot%{_localstatedir}/%name

%post
[ -d "%{_localstatedir}/%name" ] || mkdir -p %{_localstatedir}/%name
%post_service %name

%preun
%preun_service %name

%files
%doc AUTHORS COPYING
%{_bindir}/*
%{_libdir}/*
%{_datadir}/lxc/config/common.conf.d/*
%dir %{_datadir}/%name
%{_datadir}/%name/*
%ghost %dir %{_localstatedir}/%name
%{_initddir}/%{name}

%files %pam_name
%doc AUTHORS COPYING
/%{_lib}/security/*

%changelog
* Fri Jul 22 2016 Marques Lee <marques.lee@thoughtworks.com> 2.0.2-1
- Initial 2.0.2 package, loosely based on altlinux's spec
