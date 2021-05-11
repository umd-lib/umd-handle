# 0005 - "exists" and "info" API endpoints

Date: May 11, 2021

## Context

The application needs to support the handle operations needed by Fedora 2.

The existing Fedora 2 functionality requires the ability to determine if a
handle currently exists, using the following combination of parameters:

* "repo" and "repo_id"
* "prefix" and "suffix"

If a handle exists, the following information needs to be provided to
Fedora 2:

* repo
* repo_id
* prefix
* suffix
* handle_url
* url

The "repo"/"repo_id" lookup is definitely used by Fedora 2 when minting
handles. It is unclear whether the "prefix"/"suffix" lookup is actually used,
but is present in the "umfedora/handle" webapp code.

## Decision

It was decided to implement the functionality needed by Fedora 2 using two
different API endpoints -- "exists" and "info".

The main reasons for this are simplicity and practicality.

In the initial implementation of the Fedora 2 functionality, the need for
both a "repo"/"repo_id" and "prefix"/"suffix" lookup was not realized, so
the "exists" endpoint (which was clearly needed by Fedora 2 to perform
handle minting) was implemented first, and set up to use the "repo"/"repo_id"
pair as inputs.

When it was later determined that a "prefix"/"suffix" lookup would also be
required, there were several options:

1) Extend the "exists" endpoint to take a "prefix"/"suffix" input pair,
as well as a "repo"/"repo_id" input pair.

2) Create a separate "info" endpoint to take a "prefix"/"suffix" input pair,
leaving the "exists" endpoint unchanged.

3) Not provide "prefix"/"suffix" lookup functionality.

While it is not clear that "prefix"/"suffix" lookup functionality is actually
used, it could not be definitively ruled out, so simply not providing the
functionality did not seem reasonable.

Extending the "exists" endpoint is reasonably straightforward, but would
complicate the validation logic needed to determine if all the proper
input parameters had been provided. More importantly, there was no clear
way to provide information about the input parameter interdependencies
(i.e., that either a "repo"/"repo_id" pair or a "prefix"/"suffix" pair
was required) in the OpenAPI specification of the REST API.

Therefore, it was decided that the simplest and most pragmatic course was to
add an additional "info" endpoint that would provide the necessary information.

## Consequences

The "exists" and "info" endpoints are very similar, mainly differing in the
input parameters that they take. This seems less than ideal, and may become
a mainteance issue at some point.

On the other hand, these endpoints were implemented soley to support Fedora 2,
which is not under active development, and which we hope to eventually migrate
away from. Therefore it is unlikely that the endpoints would ever need to
change significantly, and investing in a more perfect solution does not seem
to be worthwhile.
