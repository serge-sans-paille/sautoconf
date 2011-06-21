#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.68])
AC_INIT([dummy], [0.0.0], [dummy@dumber])
AM_INIT_AUTOMAKE([foreign])

AC_CONFIG_SRCDIR([hello.c])
AC_CONFIG_HEADERS([config.h])

# Checks for programs.
AC_PROG_CC

# Checks for libraries.
AC_CHECK_HEADER([math.h],,[AC_MSG_ERROR([Math header not found.])])
AC_CHECK_LIB([m],[cos],,[AC_MSG_ERROR([Math library not found.])])

# Checks for header files.
AC_CHECK_HEADERS([stdlib.h],,[AC_MSG_ERROR([Some standard header file are missing.])])

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
