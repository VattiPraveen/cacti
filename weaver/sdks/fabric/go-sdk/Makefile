run-vendor:
	go mod edit -replace github.com/hyperledger/cacti/weaver/common/protos-go/v2=../../../common/protos-go/
	go mod vendor

undo-vendor:
	rm -rf vendor
	go mod edit -dropreplace github.com/hyperledger/cacti/weaver/common/protos-go/v2

build-local: run-vendor build undo-vendor

build:
	go build -v .

clean:
	rm -rf vendor