LDFLAGS=-X 'main.buildDate=$(shell date)' -X 'main.gitHash=$(shell git rev-parse HEAD)' -X 'main.buildOn=$(shell go version)' -w -s

GO_BUILD=go build -trimpath -ldflags "$(LDFLAGS)"

.PHONY: all fmt mod lint test deadcode syso origin-unwrapper-linux origin-unwrapper-linux-arm origin-unwrapper-darwin origin-unwrapper-darwin-arm origin-unwrapper-windows clean

all: origin-unwrapper-linux origin-unwrapper-linux-arm origin-unwrapper-darwin origin-unwrapper-darwin-arm origin-unwrapper-windows 

fmt:
	gofumpt -l -w .

mod:
	go get -u
	go mod tidy

lint:
	golangci-lint run

test:
	go test ./...

deadcode:
	deadcode ./...

syso:
	windres origin-unwrapper-cli.rc -O coff -o origin-unwrapper-cli.syso

origin-unwrapper-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GO_BUILD) -o origin-unwrapper-linux

origin-unwrapper-linux-arm:
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 $(GO_BUILD) -o origin-unwrapper-linux-arm

origin-unwrapper-darwin:
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 $(GO_BUILD) -o origin-unwrapper-darwin

origin-unwrapper-darwin-arm:
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 $(GO_BUILD) -o origin-unwrapper-darwin-arm

origin-unwrapper-windows:
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 $(GO_BUILD) -o origin-unwrapper-windows.exe

clean:
	rm -f origin-unwrapper-linux origin-unwrapper-linux-arm origin-unwrapper-darwin origin-unwrapper-darwin-arm origin-unwrapper-windows.exe