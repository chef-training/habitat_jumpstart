# This file is the heart of your application's habitat.
# See full docs at https://www.habitat.sh/docs/reference/plan-syntax/

# Required.
# Sets the name of the package. This will be used in along with `pkg_origin`,
# and `pkg_version` to define the fully-qualified package name, which determines
# where the package is installed to on disk, how it is referred to in package
# metadata, and so on.
pkg_name=national-parks

# Required unless overridden by the `HAB_ORIGIN` environment variable.
# The origin is used to denote a particular upstream of a package.
pkg_origin=trgredbull

# Required.
# Sets the version of the package
pkg_version="0.2.0"

# Optional.
# The name and email address of the package maintainer.
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"

# Optional.
# An array of valid software licenses that relate to this package.
# Please choose a license from http://spdx.org/licenses/
pkg_license=("Apache-2.0")
pkg_deps=(core/tomcat8 core/jre8 core/mongo-tools)
pkg_build_deps=(core/jdk8/8.192.0 core/maven)

pkg_binds=(
  [database]="port"
)
pkg_exports=(
  [port]=server.port
)
pkg_exposes=(port)
pkg_svc_user="root"
do_prepare(){ export JAVA_HOME=$(hab pkg path core/jdk8) ; }
do_build()
{
    cp -r $PLAN_CONTEXT/../ $HAB_CACHE_SRC_PATH/$pkg_dirname
    cd ${HAB_CACHE_SRC_PATH}/${pkg_dirname}
    mvn package
}
do_install()
{
    mkdir ${PREFIX}/config
    cp ${HAB_CACHE_SRC_PATH}/${pkg_dirname}/target/${pkg_name}.war ${PREFIX}/
    cp $(hab pkg path core/tomcat8)/config/conf_server.xml ${PREFIX}/config/
    cp -v ${HAB_CACHE_SRC_PATH}/${pkg_dirname}/data/national-parks.json ${PREFIX}/
}
