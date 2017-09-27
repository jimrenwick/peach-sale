
ifeq ($(M4_CRUSH_INCLUDE),)
M4_CRUSH_INCLUDE = /usr/local/devprac/deploy/internal/lib
endif

ifeq ($(CRUSH_HOME),)
CRUSH_MK = $(M4_CRUSH_INCLUDE)/crush.mk
CRUSH_PKG = $(M4_CRUSH_INCLUDE)/crush_package.mk
else
CRUSH_MK = $(CRUSH_HOME)/lib/mk/crush.mk
CRUSH_PKG = $(CRUSH_HOME)/lib/mk/crush_package.mk
endif

include $(CRUSH_MK)
# -- YOUR CODE FOLLOWS --


# -- END YOUR CODE --

# To activate non-/u/l/d based deploys, uncomment the following:
#
# PROD_USER=<prod_user>
# PROD_HOST=<prod_machine>
# PROD_ROOT=</some/root/path/on/prod_machine>
# include $(CRUSH_PKG)
#
# To use this, your Makefile must contain definitions for:
#   PROD_USER
#   PROD_HOST
#   PROD_ROOT
# and:
#  - The host must use CRUSH_HOME based crush installs in their
#    .bash_profile or .bashrc.
#  - any "state saving" files (e.g. processed.log) must match *.processed.

