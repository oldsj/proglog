deps:
	brew install e2fsprogs

install-gokrazy:
	diskutil unmountDisk /dev/$(DISK)
	gokr-packer -overwrite=tmp/full.img -target_storage_bytes=1258299392 github.com/oldsj/proglog
	sudo dd if=tmp/full.img of=/dev/$(DISK) bs=4m
	sync /dev/$(DISK)
	diskutil eject /dev/$(DISK)

fs:
	sudo $$(brew --prefix e2fsprogs)/sbin/mkfs.ext4 /dev/$(DISK)s4
	sync /dev/$(DISK)
	diskutil eject /dev/$(DISK)

test:
	curl -X POST localhost:8080 -d \
		'{"record": {"value": "TGV0J3MgR28gIzEK"}}'
	curl -X POST localhost:8080 -d \
		'{"record": {"value": "TGV0J3MgR28gIzIK"}}'
	curl -X POST localhost:8080 -d \
		'{"record": {"value": "TGV0J3MgR28gIzMK"}}'

	curl -X GET localhost:8080 -d '{"offset": 0}'
	curl -X GET localhost:8080 -d '{"offset": 1}'
	curl -X GET localhost:8080 -d '{"offset": 2}'

test-gokrazy:
	curl -X POST gokrazy:8080 -d \
		'{"record": {"value": "TGV0J3MgR28gIzEK"}}'
	curl -X POST gokrazy:8080 -d \
		'{"record": {"value": "TGV0J3MgR28gIzIK"}}'
	curl -X POST gokrazy:8080 -d \
		'{"record": {"value": "TGV0J3MgR28gIzMK"}}'

	curl -X GET gokrazy:8080 -d '{"offset": 0}'
	curl -X GET gokrazy:8080 -d '{"offset": 1}'
	curl -X GET gokrazy:8080 -d '{"offset": 2}'