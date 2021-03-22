# umd-handle

REST-based Handle back-end service with administrative user interface.

## Introduction

This application provides:

* a REST backend for resolving Handle.Net Registry handles to URLs.
* an HTTP-based user interface for administering handle to URL mappings
* a REST-based API interface for administring handle to URL mappings

## Quick Start

Requires:

* Ruby 2.7.2

```
> git clone git@github.com:umd-lib/umd-handle
> cd umd-handle
> bundle install --without production
> rails server
```

<http://localhost:3000/>

## Docker.ci and Jenkinsfile

The "Dockerfile.ci" file is used to encapsulate the environment needed by the
continuous integration (ci) server for building and testing the application.

The "Jenkinsfile" provides the Jenkins pipeline steps for building and testing
the application.
