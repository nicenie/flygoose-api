ProjectName = flygoose

GitVersion = $(shell git log -1 --pretty=format:%h)
GitCommit = $(shell git rev-parse HEAD)

Output = bin

ARCH = $(shell go env GOARCH)
OS = $(shell go env GOOS)
BuildDate = $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')

VersionPath = $(shell find . -type d -name version | head -n 1 | sed 's/..//')
VersionPkg = ${ProjectName}/${VersionPath}

BuildArgs = -ldflags "\
-X ${VersionPkg}.gitVersion=${GitVersion} \
-X ${VersionPkg}.gitCommit=${GitCommit} \
-X ${VersionPkg}.buildDate=${BuildDate}"

BuildPackage = ./cmd/...

BuildOutput = ${Output}/${OS}-${ARCH}

.PHONY: all
all: build

.PHONY: build
build:
	mkdir -p ${BuildOutput}
	go build ${BuildArgs} -o ${BuildOutput} ${BuildPackage}

.PHONY: docker
docker:
	sudo docker build -t flygoose-api:1.0.1 .