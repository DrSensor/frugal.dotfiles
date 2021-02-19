plug "KJ_Duncan/kakoune-kotlin.kak" domain "bitbucket.org" config %{
	# OPTIONAL CONFIGURATION
	hook global -once WinSetOption filetype=kotlin %{
		define-command kotlin-section-line -docstring "seperate a section of code with (// --)" %{
			try %{ execute-keys -draft "<esc>o//<space>-<esc>hy98p<esc>jo<esc>" }
		}
	}
	hook global WinSetOption filetype=kotlin %{
		set-option window lintcmd 'ktlint --relative --verbose --editorconfig=/YOUR-PATH-TO/.editorconfig'
		alias window ksl kotlin-section-line
		hook global -once -always WinSetOption filetype=.* %{
			unset-option window lintcmd
			unalias window ksl kotlin-section-line
		}
	}
}
