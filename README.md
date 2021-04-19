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

Generate a value for the "JWT_SECRET" variable. This can be any string as long
as it is "sufficiently long". One way to generate a sufficiently long random
string is:

```
> uuidgen | shasum -a256 | cut -d' ' -f1
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

| Parameter              | Value                                |
| ---------------------- | ------------------------------------ |
| HANDLE_HTTP_PROXY_BASE | (For local development, an arbitrary URL such as "http://hdl-local.lib.umd.edu/") |
| HOST                   | handle-local                         |
| JWT_SECRET             | (Output from the uuidgen command)    |
| SAML_SP_PRIVATE_KEY    | (Output from first kubectl command)  |
| SAML_SP_CERTIFICATE    | (Output from second kubectl command) |

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

### Sample Data

#### Populate the database with sample data

```
> rails db:populate_sample_data
```

#### Drop, create, migrate, seed and populate sample data

```
> rails db:reset_with_sample_data
```

### JWT Tokens

A list of JWT Tokens that have been issued by the system are stored in the
"JwtTokenLog" model. This model is not accessible via the web GUI -- all
interaction takes place via Rake tasks.

The "JwtTokenLog" model is only designed to be a record of issued tokens, to
help identify which servers need to be updated if the tokens need to be
invalidated. The "JwtTokenLog" model plays no role in validating tokens.

#### Create a JWT token for authorizing access to the REST API

```
> rails jwt:create_token['<DESCRIPTION>']
```

where \<DESCRIPTION> is a description of the server/service that will use the
token.

#### List JWT tokens

```
> rails jwt:list_tokens
```

## Production Environment Configuration

Requires:

* Postgres client to be installed (typically "libpq-dev" if a "ruby" Docker
image is being used).

The application uses the "dotenv" gem to configure the environment.
When running in Kubernetes, the Kubernetes configuration should provide the
parameters listed in the "env_example" file as environment variables, set
to appropriate values.

If running on a stand-alone server, or on a local workstation, a ".env" file
should be used.

## REST API

The REST API is specified in the OpenAPI v3.0 format:

* v1: [docs/umd-handle-open-api-v1.yml](docs/umd-handle-open-api-v1.yml)

## License

See the [LICENSE.md](LICENSE.md) file for license rights and limitations
(Apache 2.0).
