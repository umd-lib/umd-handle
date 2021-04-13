# umd-handle

REST-based Handle back-end service with administrative user interface.

## Introduction

This application provides:

* a REST backend for resolving Handle.Net Registry handles to URLs.
* an HTTP-based user interface for administering handle to URL mappings
* a REST-based API interface for administring handle to URL mappings

## Quick Start

Prerequisites:

* Ruby 2.7.2
* Node.js v8.16.0 or greater
* Yarn v1.22.0 or greater
* Edit the "/etc/hosts" file and add

    ```
    127.0.0.1 handle-local
    ```

1) Checkout the application:

```
> git clone git@github.com:umd-lib/umd-handle
```

2) Install the dependencies:

```
> cd umd-handle
> bundle config set without 'production'
> bundle install
> yarn
```

3) Copy the "env_example" file to ".env":

```
> cp env_example .env
```

Determine the values for the "SAML_SP_PRIVATE_KEY" and "SAML_SP_CERTIFICATE"
variables:

```
> kubectl -n test get secret umd-handle-common-env-secret -o jsonpath='{.data.SAML_SP_PRIVATE_KEY}' | base64 --decode
> kubectl -n test get secret umd-handle-common-env-secret -o jsonpath='{.data.SAML_SP_CERTIFICATE}' | base64 --decode
```

Edit the '.env" file:

```
> vi .env
```

and set the parameters:

| Parameter           | Value                                |
| ------------------- | ------------------------------------ |
| HOST                | handle-host                          |
| SAML_SP_PRIVATE_KEY | (Output from first kubectl command)  |
| SAML_SP_CERTIFICATE | (Output from second kubectl command) |

4) Migrate the database and run the application:

```
> rails db:migrate
> rails server
```

5) In a web browser, go to:

<http://handle-local:3000/>

## Docker Image

This application provides a "Dockerfile" for generating a Docker image for use
in production. The Dockerfile provides a sample build command.

The "docker_config" directory contains files copied into the Docker image.

In order to generate "clean" Docker images, the Docker images should be built
from a fresh clone of the GitHub repository.

## Docker.ci and Jenkinsfile

The "Dockerfile.ci" file is used to encapsulate the environment needed by the
continuous integration (ci) server for building and testing the application.

The "Jenkinsfile" provides the Jenkins pipeline steps for building and testing
the application.

## umd_lib_style gem

This application uses the "umd_lib_style" gem to provide a UI look-and-feel
similar to other UMD Rails applications.

The "umd_lib_style" gem is not currently configured to support the use of
webpacker, and it is currently unclear how to incorporate the JavaScript
dependencies from the Rails engine gem into a Rails application that uses
that gem.

Therefore, this application has been configured to load the necessary
JavaScript dependencies required by Bootstrap v3 in its own "package.json" file,
and is using a custom "app/views/layouts/_umd_lib.html.erb" file, replacing
the `javascript_include_tag` directive with `javascript_pack_tag`.

## Rake Tasks

Populates the database with sample data

```
> rails db:populate_sample_data
```

Drop, create, migrate, seed and populate sample data

```
> rails db:reset_with_sample_data
```

## License

See the [LICENSE.md](LICENSE.md) file for license rights and limitations
(Apache 2.0).
