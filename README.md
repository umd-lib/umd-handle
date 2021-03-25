# umd-handle

REST-based Handle back-end service with administrative user interface.

## Introduction

This application provides:

* a REST backend for resolving Handle.Net Registry handles to URLs.
* an HTTP-based user interface for administering handle to URL mappings
* a REST-based API interface for administring handle to URL mappings

## Quick Start

Prerequisites:

Due to the use of the "mimemagic" gem, install the "shared-mime-info" database:

```
> brew install shared-mime-info
```

See:

* <https://github.com/mimemagicrb/mimemagic/issues/98>
* <https://github.com/rails/rails/issues/41750>

Requires:

* Ruby 2.7.2
* Node.js v8.16.0 or greater
* Yarn v1.22.0 or greater

```
> git clone git@github.com:umd-lib/umd-handle
> cd umd-handle
> bundle config set without 'production'
> bundle install
> yarn
> rails db:migrate
> rails server
```

<http://localhost:3000/>

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
