#!/bin/bash

# Download and build a UnitexJni version
# ======================================
#
# This script accepts 0, 1 or 2 parameters.
# mkUnitexLinux32Lib.sh
#   Downloads the HEAD revision of Unitex-C++ from MLV and builds a standard libUnitexJni.so with Ergonotics VFS..
# mkUnitexLinux32Lib.sh 3458
#  Downloads revision 3458 of Unitex-C++ from MLV and builds a standard libUnitexJni.so with Ergonotics VFS.


usevfs=yes
pgovfs=yes
revision=$1

shopt -s nocasematch


echo Using VFS with Feedback GCC optimization ? $pgovfs
echo Using VFS ? $usevfs
echo Using Unitex-C++ revision? $revision

##################

# start build Unitex-C++
revision=$1

if [[ "$1" != "" ]]; then
	optrev="-r $1"
else
	optrev=""
fi

svnurl="https://github.com/UnitexGramLab/unitex-core/trunk"
svnoptions=" --no-auth-cache --non-interactive"


svn export $optrev $svnoptions $svnurl Unitex-C++

cd Unitex-C++

rm -rf Licenses

svn co $optrev $svnoptions $svnurl/Licenses > /dev/null

cd Licenses




NEW_SVN_REVISION="$(svnversion -n)"
UNITEX_NEW_SVN_DIFFERENCE=1632
OLD_SVN_REVISION=$(( NEW_SVN_REVISION + UNITEX_NEW_SVN_DIFFERENCE ))
echo // revision is _${NEW_SVN_REVISION}_
echo // revision added is _${NEW_SVN_REVISION}_ __${OLD_SVN_REVISION}__
echo // revision is _${NEW_SVN_REVISION}_> ../Unitex_revision.h

echo -ne "#define UNITEX_NEW_REVISION " >> ../Unitex_revision.h
echo -ne ${NEW_SVN_REVISION} >> ../Unitex_revision.h
echo -ne " /* the svn unitex revision number on the github svn server */\015\012" >> ../Unitex_revision.h

echo -ne "#define UNITEX_REVISION " >> ../Unitex_revision.h
echo -ne ${OLD_SVN_REVISION} >> ../Unitex_revision.h
echo -ne " /* the svn unitex revision number */\015\012" >> ../Unitex_revision.h

echo -ne "#define UNITEXREVISION " >> ../Unitex_revision.h
echo -ne ${OLD_SVN_REVISION} >> ../Unitex_revision.h
echo -ne " /* the svn unitex revision number */\015\012" >> ../Unitex_revision.h

echo -ne "#define UNITEX_REVISION_TEXT \042" >> ../Unitex_revision.h
echo -ne ${OLD_SVN_REVISION} >> ../Unitex_revision.h
echo -ne "\042 /* the svn unitex revision number as text */\015\012" >> ../Unitex_revision.h


cd ..
# rm -rf Licenses

cat Unitex_revision.h
cd ..
# end build Unitex-C++


cd Unitex-C++
cd build

	make 64BITS=yes JNILIBRARY=yes TRE_DIRECT_COMPILE=yes ADDITIONAL_INCLUDE=/usr/lib/jvm/java-7-openjdk-amd64/include/  ADDITIONAL_CFLAG+=-fvisibility=hidden ADDITIONAL_CFLAG+=-fvisibility-inlines-hidden  ADDITIONAL_CFLAG+=-ffunction-sections ADDITIONAL_CFLAG+=-fdata-sections   ADDITIONAL_CFLAG+=-DUNITEX_PREVENT_EXPOSE_MINI_PERSISTANCE_IN_INTERFACE ADDITIONAL_CFLAG+=-DCASE_CONVERSION_BY_TAB ADDITIONAL_CFLAG+=-DCASE_DEACCENTUATE_BY_TAB ADDITIONAL_CFLAG+=-DUNITEX_FUNC_EXPORT ADDITIONAL_CFLAG+=-flto ADDITIONAL_CFLAG+=-mtune=corei7 ADDITIONAL_LIB1=-Wl,--whole-archive ADDITIONAL_LIB1+=../../libUnitexVirtualStatic.a ADDITIONAL_LIB1+=-Wl,--no-whole-archive ADDITIONAL_CFLAG+=-fprofile-generate ADDITIONAL_CFLAG+=-Wl,-fprofile-generate
# TRE_GCC_CFLAGS=-Wall  TRE_GCC_CFLAGS+=-O3  TRE_GCC_CFLAGS+=-fPIC  TRE_GCC_CFLAGS+=-ffunction-sections  TRE_GCC_CFLAGS+=-fdata-sections  TRE_GCC_CFLAGS+=-I"../include_tre"  TRE_GCC_CFLAGS+=-Ilibtre/include 
	cd ../bin
	cp ../../RunUnitexDynLib .
	export LD_LIBRARY_PATH=.
	./RunUnitexDynLib
	./RunUnitexDynLib RunLog ../../Cassys_csc_cleanup.ulp -r "*r1" -d "*d1" -i 1
	./RunUnitexDynLib RunLog ../../Cassys_1_cleanup.ulp -r "*r1" -d "*d1" -i 1
	./RunUnitexDynLib RunLog ../../Locate_avec_TRE.ulp -r "*r1" -d "*d1" -i 1
	cd ../build
	make 64BITS=yes JNILIBRARY=yes TRE_DIRECT_COMPILE=yes ADDITIONAL_INCLUDE=/usr/lib/jvm/java-7-openjdk-amd64/include/ ADDITIONAL_CFLAG+=-fvisibility=hidden ADDITIONAL_CFLAG+=-fvisibility-inlines-hidden  ADDITIONAL_CFLAG+=-ffunction-sections ADDITIONAL_CFLAG+=-fdata-sections   ADDITIONAL_CFLAG+=-DUNITEX_PREVENT_EXPOSE_MINI_PERSISTANCE_IN_INTERFACE ADDITIONAL_CFLAG+=-DCASE_CONVERSION_BY_TAB ADDITIONAL_CFLAG+=-DCASE_DEACCENTUATE_BY_TAB ADDITIONAL_CFLAG+=-DUNITEX_FUNC_EXPORT ADDITIONAL_CFLAG+=-flto ADDITIONAL_CFLAG+=-mtune=corei7 ADDITIONAL_LIB1=-Wl,--whole-archive ADDITIONAL_LIB1+=../../libUnitexVirtualStatic.a ADDITIONAL_LIB1+=-Wl,--no-whole-archive ADDITIONAL_CFLAG+=-fprofile-use ADDITIONAL_CFLAG+=-Wl,-fprofile-use
# TRE_GCC_CFLAGS=-Wall  TRE_GCC_CFLAGS+=-O3  TRE_GCC_CFLAGS+=-fPIC  TRE_GCC_CFLAGS+=-ffunction-sections  TRE_GCC_CFLAGS+=-fdata-sections  TRE_GCC_CFLAGS+=-I"../include_tre"  TRE_GCC_CFLAGS+=-Ilibtre/include 

pwd
ls -l ../bin
cp ../bin/libUnitexJni.so ../..

cd ..
cd ..

