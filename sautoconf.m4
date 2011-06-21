m4_define([AX_TR_UP],[m4_translit([AS_TR_SH([$1])],[a-z],[A-Z])])
m4_define([AX_MSG],[ax_msg_[]AS_TR_SH([$1])])
m4_define([AX_WITH],[ax_with_[]AS_TR_SH([$1])])
m4_define([AX_HAS],[test "x${AX_WITH([$1])}" = xyes ])

m4_define([AX_DEFAULT_PACKAGE],[default])
m4_define([AX_EXTRA_PACKAGES],[])


m4_define([AC_INIT],
	m4_defn([AC_INIT])
[
m4_define([AX_CURRENT_PACKAGE],AX_DEFAULT_PACKAGE)
AX_WITH([AX_DEFAULT_PACKAGE])="yes"
AX_MSG([AX_DEFAULT_PACKAGE])=""
]
)

dnl configure an optionnal feature
dnl usage AX_FEATURE(feature-name,help-message,default=[yes|no],configuration-action,[new-variable-value])
dnl sets the shell_variable ax_enable_feature-name to FEATURE-NAME or, if given new-variable-value , if test succeeded
dnl sets the conditionnal WITH_FEATURE-NAME
dnl and set the disable message for AX_HAS(FEATURE-NAME)
m4_define([AX_FEATURE],[
	m4_pushdef([AX_CURRENT_PACKAGE],[$1])
	m4_append([AX_EXTRA_PACKAGES],  [ ]AX_CURRENT_PACKAGE) 
	AC_ARG_ENABLE([$1],
			[AS_HELP_STRING([--enable-$1],[$2 (defaut is $3)])],
			[AS_IF([test x"$enableval" = "xyes"],[
				AX_WITH([$1])=yes
				$4],
				[
					AX_WITH([$1])=disabled
					AX_MSG([$1])="        $1 disabled"	
				]
			)],
			[
				m4_if([$3],[yes],[
					AX_WITH([$1])=yes
					$4],
					[
						AX_WITH([$1])=disabled
						AX_MSG([$1])=""
					])
			]
		)
		AS_IF([AX_HAS([$1])],[ax_enable_[]AS_TR_SH($1)=m4_if($5,,[AS_TR_SH($1)],[$5])])
		AM_CONDITIONAL(WITH_[]AX_TR_UP([$1]),[AX_HAS([$1])])
	m4_popdef([AX_CURRENT_PACKAGE])
])

m4_define([_AX_OUTPUT], defn([AC_OUTPUT]))
m4_define([AC_OUTPUT],[
# test if configure is a succes
# if it's a success, perform substitution
AS_IF([AX_HAS([AX_DEFAULT_PACKAGE])],[_AX_OUTPUT([$1])])
# in both case print a summary
	eval my_bindir="`eval echo $[]{bindir}`"
	eval my_libdir="`eval echo $[]{libdir}`"
	eval my_docdir="`eval echo $[]{docdir}`"

	cat << EOF

$PACKAGE_NAME Configuration: 
 
  Version:     $VERSION$VERSIONINFO 
 

  Executables: $my_bindir
  Libraries:   $my_libdir
  Docs:        $my_docdir

  Minimal deps ok? $[]AX_WITH([AX_DEFAULT_PACKAGE])
$[]AX_MSG([AX_DEFAULT_PACKAGE])

m4_foreach_w([_pkg_],[AX_EXTRA_PACKAGES],[dnl
  Build m4_strip(_pkg_)? $[]AX_WITH(m4_strip(_pkg_))
$[]AX_MSG(m4_strip(_pkg_))
])
EOF

# and a conclusion message
	AS_IF([AX_HAS([AX_DEFAULT_PACKAGE])],[AS_MESSAGE([Configure succeded])],[
		AS_MESSAGE([Configure failed])
		AS_EXIT([1])
	])
	dnl m4_popdef([_TEST_])
])


dnl hook begin
m4_define([AX_REDEF_ERR],[_$0([$][1])])
m4_define([_AX_REDEF_ERR],m4_define([AC_MSG_ERROR],[dnl
            { dnl
                ax_msg="_AS_QUOTE([$1])"
                m4_foreach_w([_pkg_],[AX_CURRENT_PACKAGE],[AX_WITH([_pkg_])="no" ;  AX_MSG([_pkg_])="$[]AX_MSG([_pkg_])        $ax_msg\

" ; ] )
            }dnl
        ])
)


dnl This a pretty cool macro :D
dnl It calls $1 in a new env where AC_MSG_ERROR no longer outputs an error
dnl but logs an error message instead
dnl and save the failuer for AC_OUTPUT
m4_define([AX_REHOOK],[
	m4_define([_[$1]],defn([$1])])
	m4_define([$1],[
		m4_define([_AX_MSG_ERROR],defn([AC_MSG_ERROR]))
		AX_REDEF_ERR()
		indir([_$1],[[$][1],[$][2],[$][3],[$][4],[$][5]])
		m4_define([AC_MSG_ERROR],defn([_AX_MSG_ERROR]))
	])
])

AX_HOOK([AC_CHECK_LIB])
AX_HOOK([AC_CHECK_LIBS])
AX_HOOK([AC_CHECK_HEADER])
AX_HOOK([AC_CHECK_HEADERS])
AX_HOOK([AC_CHECK_FUNC])
AX_HOOK([AC_CHECK_FUNCS])
AX_HOOK([AC_CHECK_PROG])
AX_HOOK([AC_CHECK_PROGS])
