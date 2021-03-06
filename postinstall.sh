#!/bin/bash


source /etc/os-release || source /usr/lib/os-release

case ${ID,,} in
    *suse)
    export ONE_DISTRO="opensuse"
    INSTALLER_CMD="sudo -H -E zypper install -y"
    PKG_MAP=(
        [python]=python
        [qemu-img]=qemu-tools
    )

    ;;

    ubuntu|debian)
    sudo apt-get update
    export ONE_DISTRO="ubuntu"
    INSTALLER_CMD="sudo -H -E apt-get -y install"
    PKG_MAP=(
        [python]=python-minimal
        [qemu-img]=qemu-utils
    )
    ${INSTALLER_CMD} pbuilder kpartx

    ;;

    rhel|centos|fedora)
    export ONE_DISTRO="centos"
    PKG_MANAGER=$(which dnf || which yum)
    INSTALLER_CMD="sudo -H -E ${PKG_MANAGER} -y install"
    PKG_MAP=(
        [python]=python
        [qemu-img]=qemu-img
    )
    ${INSTALLER_CMD} policycoreutils-python

   ;;

    *) echo "ERROR: Supported package manager not found.  Supported: apt,yum,zypper"; exit 1;;
esac

if ! $(python --version &>/dev/null); then
    ${INSTALLER_CMD} ${PKG_MAP[python]}
fi
if ! $(qemu-img --version &>/dev/null); then
    ${INSTALLER_CMD} ${PKG_MAP[qemu-img]}
fi

curl -sL https://bootstrap.pypa.io/get-pip.py | python

output_folder=/opt/shared/$ONE_DISTRO/
build_script="do-build.sh"

cd $(mktemp)
curl -o ./$build_script https://raw.githubusercontent.com/hwoarang/docker-dib-xci/master/$build_script
chmod +x $build_script
./$build_script

cp $ONE_DISTRO.qcow* $output_folder
