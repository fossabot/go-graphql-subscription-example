.EXPORT_ALL_VARIABLES:

GO111MODULE=on

default: build

install-tools:
	@if [ ! -f $(GOPATH)/bin/esc ]; then \
		echo "installing esc..."; \
		go get -u github.com/mjibson/esc; \
	fi
	@if [ ! -f $(GOPATH)/bin/golangci-lint ]; then \
		echo "installing golangci-lint..."; \
		curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b $(GOPATH)/bin v1.17.1; \
	fi

gen-static: install-tools
	go generate main.go

check: install-tools
	golangci-lint run ./...

build: gen-static
	go build .

build-linux-amd64: gen-static
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build .

dockerize:
	docker build -t ccamel/go-graphql-subscription-example .
