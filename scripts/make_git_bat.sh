#!/bin/bash

#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'mingw-builds' project.
# Copyright (c) 2011,2012,2013 by niXman (i dotty nixman doggy gmail dotty com)
# All rights reserved.
#
# Project: mingw-builds ( http://sourceforge.net/projects/mingwbuilds/ )
#
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# - Redistributions of source code must retain the above copyright 
#     notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright 
#     notice, this list of conditions and the following disclaimer in 
#     the documentation and/or other materials provided with the distribution.
# - Neither the name of the 'mingw-builds' nor the names of its contributors may 
#     be used to endorse or promote products derived from this software 
#     without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
# A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY 
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS 
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# **************************************************************************

P=make
V=git
TYPE="git"
P_V=${P}_${V}
SRC_FILE=
B=${P_V}
URL="http://git.savannah.gnu.org/cgit/make.git"
PRIORITY=extra

src_download() {
	func_download ${P_V} ${TYPE} ${URL}
}

src_unpack() {
	echo "--> Don't need to unpack"
}

src_patch() {
	local _patches=(
		${P}/make-linebuf-mingw.patch
		${P}/make-getopt.patch
	)
	
	func_apply_patches \
		${P_V} \
		_patches[@]
}

src_configure() {
	cp -rf ${UNPACK_DIR}/${P_V} ${CURR_BUILD_DIR}/
}

pkg_build() {
	local _make_flags=(
		"build_w32.bat gcc"
	)
	local _allmake="${_make_flags[@]}"
	func_make \
		${B} \
		"cmd /c" \
		"$_allmake" \
		"build mingw32-make..." \
		"builded"
}

pkg_install() {
	pushd ${CURR_BUILD_DIR}/${P_V} > /dev/null
	[[ ! -f install.marker ]] && {
		strip -s gnumake.exe -o mingw32-make.exe
		cp -f mingw32-make.exe $PREFIX/bin/
		cp -f libgnumake-1.dll.a $PREFIX/lib/
		touch install.marker
	}
	popd > /dev/null
}

# **************************************************************************
