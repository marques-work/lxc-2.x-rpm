Name:           lxc
Version:        2.0.3
Release:        1%{?dist}
Summary:        Linux Resource Containers
Group:          Applications/System
License:        LGPLv2+ and GPLv2
URL:            http://linuxcontainers.org
Source0:        http://linuxcontainers.org/downloads/%{name}-%{version}.tar.gz
BuildRequires:  doxygen
BuildRequires:  kernel-headers
BuildRequires:  libselinux-devel
BuildRequires:  libcap-devel
BuildRequires:  libtool
BuildRequires:  autoconf automake

%{!?_pkgdocdir: %global _pkgdocdir %{_docdir}/%{name}-%{version}}

%description
Linux Resource Containers provide process and resource isolation without the
overhead of full virtualization.


%package        libs
Summary:        Runtime library files for %{name}
Group:          System Environment/Libraries

# rsync is called in bdev.c, e.g. by lxc-clone
Requires:       rsync
Requires(post): chkconfig
Requires(preun): initscripts, chkconfig
Requires(postun): initscripts


%description    libs
Linux Resource Containers provide process and resource isolation without the
overhead of full virtualization.

The %{name}-libs package contains libraries for running %{name} applications.

%package        templates
Summary:        Templates for %{name}
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}
# Note: Requirements for the template scripts (busybox, dpkg,
# debootstrap, rsync, openssh-server, dhclient, apt, pacman, zypper,
# ubuntu-cloudimg-query etc...) are not explicitly mentioned here:
# their presence varies wildly on supported Fedora/EPEL releases and
# archs, and they are in most cases needed for a single template
# only. Also, the templates normally fail graciously when such a tool
# is missing. Moving each template to its own subpackage on the other
# hand would be overkill.


%description    templates
Linux Resource Containers provide process and resource isolation without the
overhead of full virtualization.

The %{name}-templates package contains templates for creating containers.


%package        devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}
Requires:       pkgconfig

%description    devel
Linux Resource Containers provide process and resource isolation without the
overhead of full virtualization.

The %{name}-devel package contains libraries and header files for
developing applications that use %{name}.


%package        doc
Summary:        Documentation for %{name}
Group:          Documentation
BuildArch:      noarch

%description    doc
This package contains documentation for %{name}.


%prep
%setup -q -n %{name}-%{?!prerel:%{version}}%{?prerel:%{commit}}

%build
./autogen.sh
%configure --enable-doc \
           --docdir=%{_pkgdocdir} \
           --enable-selinux \
           --enable-seccomp \
           --with-init-script=sysvinit

make

%install
%{make_install}
mkdir -p %{buildroot}%{_sharedstatedir}/%{name}
mkdir -p %{buildroot}%{_pkgdocdir}
cp -a AUTHORS README %{buildroot}%{_pkgdocdir}
mkdir -p %{buildroot}%{_pkgdocdir}/api
cp -a doc/api/html/* %{buildroot}%{_pkgdocdir}/api/

# cache dir
mkdir -p %{buildroot}%{_localstatedir}/cache/%{name}

%check
make check


%post libs
/sbin/ldconfig
/sbin/chkconfig --add %{name}-net
/sbin/chkconfig --add %{name}

%preun libs
if [ $1 -eq 0 ]; then
        /sbin/service %{name}-net stop > /dev/null 2>&1
        /sbin/chkconfig --del %{name}-net
        /sbin/service %{name} stop > /dev/null 2>&1
        /sbin/chkconfig --del %{name}
fi


%postun libs
/sbin/ldconfig
if [ $1 -ge 1 ]; then
        /sbin/service %{name}-net condrestart > /dev/null 2>&1 || :
        /sbin/service %{name} condrestart > /dev/null 2>&1 || :
fi

%files
%{_bindir}/%{name}-*
%{_mandir}/man1/%{name}*
%{_mandir}/*/man1/%{name}*
%{_datadir}/%{name}/%{name}.functions
%dir %{_sysconfdir}/bash_completion.d
%{_sysconfdir}/bash_completion.d/%{name}
%dir %{_datadir}/%{name}
%dir %{_datadir}/%{name}/templates
%dir %{_datadir}/%{name}/config
%{_datadir}/%{name}/hooks
%{_datadir}/%{name}/%{name}-patch.py*
%{_datadir}/%{name}/selinux
%{_libdir}/liblxc.so.*
%{_libdir}/%{name}
%{_libexecdir}/%{name}
%{_sbindir}/init.%{name}
%{_bindir}/%{name}-autostart
%{_sharedstatedir}/%{name}
%dir %{_sysconfdir}/%{name}
%config(noreplace) %{_sysconfdir}/%{name}/default.conf
%config(noreplace) %{_sysconfdir}/default/%{name}
%{_mandir}/man1/%{name}-autostart*
%{_mandir}/*/man1/%{name}-autostart*
%{_mandir}/man1/%{name}-user-nic*
%{_mandir}/*/man1/%{name}-user-nic*
%{_mandir}/man5/%{name}*
%{_mandir}/man7/%{name}*
%{_mandir}/*/man5/%{name}*
%{_mandir}/*/man7/%{name}*
%dir %{_pkgdocdir}
%{_pkgdocdir}/AUTHORS
%{_pkgdocdir}/README
%{_sysconfdir}/rc.d/init.d/%{name}
%{_sysconfdir}/rc.d/init.d/%{name}-net
%dir %{_localstatedir}/cache/%{name}
%{_datadir}/%{name}/templates/lxc-*
%{_datadir}/%{name}/config/*


%files devel
%{_libdir}/pkgconfig/%{name}.pc
%{_includedir}/lxc
%{_libdir}/liblxc.so


%files doc
%dir %{_pkgdocdir}
%{_pkgdocdir}/*


%changelog
* Tue Jul 19 2016 Marques Lee <marques.lee@thoughtworks.com> - 2.0.3-1
- Initial package
