all:atlas
	cd ${<};./configure
	make -C ${<}
atlas:
	dynamo -o atlas create-project -l mit --ado atlas email@domain.com
	
clean:
	git clean . -xdf

