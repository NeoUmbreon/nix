SYS := ${shell uname -s}
ARC := ${shell uname -m}
VER := 1.0.5

PREFIX ?= /usr/local
INCLUDEDIR ?= ${PREFIX}/include/ftd3xx
LIBDIR ?= ${PREFIX}/lib
BINDIR ?= ${PREFIX}/bin

EXT := so
LIB := libftd3xx.${EXT}.${VER}
ZIP :=
USB := echo "Skipping udev rules on NixOS"
UPD := echo "Skipping ldconfig"

ifeq (${SYS}, Darwin)
	EXT := dylib
	LIB := libftd3xx.${VER}.${EXT}
	TAR := d3xx-osx.${VER}.dmg
	ZIP := 7z x temp/${TAR} -otemp
	USB := true
endif

ifeq (${SYS}, Linux)
	ifeq (${ARC}, $(filter aarch% arm%, ${ARC}))
		ifeq (${ARC}, $(filter arm64% %64 armv8% %v8, ${ARC}))
			TAR := libftd3xx-linux-arm-v8-${VER}.tgz
		else ifeq (${ARC}, $(filter armv7% %v7, ${ARC}))
			TAR := libftd3xx-linux-arm-v7_32-${VER}.tgz
		else
			TAR := libftd3xx-linux-arm-v6-hf-${VER}.tgz
		endif
	else
		ifeq (${ARC}, $(filter %64, ${ARC}))
			TAR := libftd3xx-linux-x86_64-${VER}.tgz
		else ifeq (${ARC}, $(filter %32 %86, ${ARC}))
			TAR := libftd3xx-linux-x86_32-${VER}.tgz
		endif
	endif
	ZIP := tar -xzf temp/${TAR} --strip-components 1 -C temp
endif

xx3dsfml: xx3dsfml.o
	${CXX} xx3dsfml.o -o xx3dsfml ${LDFLAGS} -pthread -lftd3xx -lsfml-audio -lsfml-graphics -lsfml-system -lsfml-window

xx3dsfml.o: xx3dsfml.cpp
	${CXX} -std=c++17 -c xx3dsfml.cpp -o xx3dsfml.o ${CXXFLAGS}

clean:
	rm -rf xx3dsfml *.o temp

ftd3xx:
	curl --create-dirs https://ftdichip.com/wp-content/uploads/2023/03/${TAR} -o temp/${TAR}
	${ZIP}
	${USB}
	install -m 755 -d ${INCLUDEDIR}
	install -m 644 temp/*.h ${INCLUDEDIR}
	install -m 755 -d ${LIBDIR}
	install -m 755 temp/${LIB} ${LIBDIR}
	ln -sf ${LIBDIR}/${LIB} ${LIBDIR}/libftd3xx.${EXT}
	${UPD}
	rm -rf temp

install: ftd3xx xx3dsfml
	install -m 755 -d ${BINDIR}
	install -m 755 xx3dsfml ${BINDIR}

uninstall:
	rm -rf ${BINDIR}/xx3dsfml ${INCLUDEDIR} ${LIBDIR}/libftd3xx*

update:
	curl --create-dirs https://raw.githubusercontent.com/ChrisMalnick/xx3dsfml/main/{LICENSE,Makefile,README.md,xx3dsfml.cpp} -o "#1"

