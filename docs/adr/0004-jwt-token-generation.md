# 0004 - JWT Token Generation

Date: April 12, 2021

## Context

The application's REST API uses JWT tokens for authentication.

An important consideration is how these JWT tokens are generated and distributed
to the servers (ArchiveSpace, Fedora 2, etc.) that need to communicate with
this application. Also important is the need to identify which applications
may be using a token, in case it becomes necessary to replace them.

## Decision

Create a Rake task for generating a JWT token, where the generated token
is recorded in a "token log" table within the application. The "token log"
table should contain:

* the generated token
* a user-provided description
* the date the token was created

It is expected that the JWT tokens will either never expire or have extremely
long expiration times.

The "token log" table will _not_ be used in the authentication/authorization
process, nor will it be available via the Admin GUI.

A Rake task for listing the existing tokens should also be created.

This decision was largely driven by the simplicity of implementation,
and the expectation that JWT tokens used by servers utilizing the REST API
would be changed very infrequently.

## Consequences

Creating JWT tokens manually and applying them to the relevant servers is
simple, but may break down in unexpected ways. For example, a single token
may be propagated to additional servers outside of the description for the
token, leading to issues if the token is invalidated.

Having an unexpiring token is a possible security issue, as the only way to
invalidate it is to change the JWT secret used to create the token, which
also invalidates all other tokens. In this scenario, multiple tokens would
have to be generated and deployed quickly, leading to possible downtime for
some services.

Each of the above issues is currently considered to be manageable.
