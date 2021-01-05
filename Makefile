
export PREFIX=${CURDIR}/target
export ADA_PROJECT_PATH=${PREFIX}/share/gpr:${PREFIX}/lib/gnat
export PATH:=${PREFIX}/bin:/usr/lib/jvm/java-15/bin:${PATH}
CLONE=gh repo clone 

all: ada-awa

ada-awaVersion=0.0.0
ada-adoVersion=0.0.0
ada-utilVersion=0.0.0
ada-asfVersion=0.0.0
ada-elVersion=0.0.0
ada-securityVersion=0.0.0
ada-servletVersion=0.0.0
swagger-adaVersion=0.0.0
ada-wikiVersion=0.0.0
ada-keystoreVersion=0.0.0
ada-fuseVersion=0.0.0
ada-lzmaVersion=0.0.0
dynamoVersion=0.0.0


ada-awa.src:
	${CLONE}stcarrez/${@:.src=} ${@}

ada-awa:ada-awa.src ada-ado ada-asf ada-el ada-keystore ada-lzma ada-security ada-servlet ada-util ada-wiki dynamo openapi-ada
	cd ${<};./configure --prefix=${PREFIX}
	sed "s-M99-M127-" `find ${<} -name config.gpr` -i
	${MAKE} -C ${<}
	${MAKE} -C ${<} install DESTDIR=_
	touch ${@}

ada-ado.src:
	${CLONE}stcarrez/${@:.src=} ${@}
ada-ado:ada-ado.src ada-util
	cd ${<};./configure --prefix=${PREFIX}
	sed "s-M99-M127-" `find ${<} -name config.gpr` -i
	${MAKE} -C ${<}
	${MAKE} -C ${<} install
	touch ${@}

ada-util.src:
	${CLONE}stcarrez/${@:.src=} ${@}
ada-util:ada-util.src
	cd ${<};./configure --prefix=${PREFIX}
	sed "s-M99-M127-" `find ${<} -name config.gpr` -i
	${MAKE} -C ${<}
	${MAKE} -C ${<} install
	touch ${@}
	

ada-asf.src:
	${CLONE}stcarrez/${@:.src=} ${@}
ada-asf:ada-asf.src ada-util ada-el ada-security ada-servlet
	cd ${<};./configure --prefix=${PREFIX}
	sed "s-M99-M127-" `find ${<} -name config.gpr` -i
	${MAKE} -C ${<}
	${MAKE} -C ${<} install
	touch ${@}
	

ada-el.src:
	${CLONE}stcarrez/${@:.src=} ${@}
ada-el:ada-el.src
	cd ${<};./configure --prefix=${PREFIX}
	sed "s-M99-M127-" `find ${<} -name config.gpr` -i
	${MAKE} -C ${<}
	${MAKE} -C ${<} install
	touch ${@}

ada-security.src:
	${CLONE}stcarrez/${@:.src=} ${@}
ada-security:ada-security.src
	cd ${<};./configure --prefix=${PREFIX}
	sed "s-M99-M127-" `find ${<} -name config.gpr` -i
	${MAKE} -C ${<}
	${MAKE} -C ${<} install
	touch ${@}

ada-servlet.src:
	${CLONE}stcarrez/${@:.src=} ${@}
ada-servlet:ada-servlet.src
	cd ${<};./configure --prefix=${PREFIX}
	sed "s-M99-M127-" `find ${<} -name config.gpr` -i
	${MAKE} -C ${<}
	${MAKE} -C ${<} install
	touch ${@}

swagger-ada.src:
	${CLONE}stcarrez/${@:.src=} ${@}
swagger-ada:swagger-ada.src ada-util ada-security ada-el ada-servlet
	cd ${<};./configure --prefix=${PREFIX}
	sed "s-M99-M127-" `find ${<} -name config.gpr` -i
	${MAKE} -C ${<}
	${MAKE} -C ${<} install
	touch ${@}

ada-wiki.src:
	${CLONE}stcarrez/${@:.src=} ${@}
	git -C ${@} checkout tags/${${@:.src=}}Version
	
ada-wiki:ada-wiki.src ada-util
	cd ${<};./configure --prefix=${PREFIX}
	sed "s-M99-M127-" `find ${<} -name config.gpr` -i
	${MAKE} -C ${<}
	${MAKE} -C ${<} install
	touch ${@}

ada-keystore.src:
	${CLONE}stcarrez/${@:.src=} ${@}
ada-keystore:ada-keystore.src ada-util ada-fuse
	cd ${<};./configure --prefix=${PREFIX} --with-ada-util=${PREFIX}/share/gpr/
	sed "s!${PREFIX}/share/gpr/!!" -i ${<}/*.gpr
	sed "s-M99-M127-" `find ${<} -name config.gpr` -i
	${MAKE} -C ${<}
	${MAKE} -C ${<} install
	touch ${@}

ada-fuse.src:
	${CLONE}medsec/${@:.src=} ${@}
ada-fuse:ada-fuse.src
	gprbuild   -p -j0 -P ${<}/ada_fuse.gpr "-XADA_FUSE_SYSTEM=Linux_x86_64"
	gprinstall -p -P ${<}/ada_fuse.gpr --prefix=${PREFIX} "-XADA_FUSE_SYSTEM=Linux_x86_64"
	touch ${@}

ada-lzma.src:
	${CLONE}stcarrez/${@:.src=} ${@}
ada-lzma:ada-lzma.src
	cd ${<};./configure --prefix=${PREFIX}
	${MAKE} -C ${<}
	${MAKE} -C ${<} install
	touch ${@}


dynamo.src:
	${CLONE}stcarrez/${@:.src=} ${@}
dynamo:dynamo.src ada-util ada-el ada-security ada-servlet ada-asf ada-ado 
	cd ${<};./configure --prefix=${PREFIX}
	sed "s-M99-M127-" `find ${<} -name config.gpr` -i
	${MAKE} -C ${<}
	${MAKE} -C ${<} install
	touch ${@}


openapi-ada:swagger-ada
	touch ${@}

install:
	tar -C target -c . | sudo tar -C ${XPREFIX}  -x

uninstall:
	cd target; find -type f | while read i ; do sudo rm ${XPREFIX}/$$i; done
clean:
	@for i in */.git ; do\
		git -C `dirname $$i` clean -xdf;\
	done
	git clean . -xdf
bash:
	bash
