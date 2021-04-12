# 0002 - Use of Rails

Date: April 12, 2021

## Context

An application has to written in some programming languge.

## Decision

Rails was chosen because SSDR has experience building web applications in
Rails 5.x, and this project seems similar to other Rails projects such as
"Autonumber".

The application is being written using Rails 6.1, as that is the current stable
version of Rails, and Rails 5.x is approaching end-of-life.

## Consequences

Choosing a programming language is obviously foundational to a project.
Fortunately, this project is straightforward enough that it could be
implemented fairly easily in any modern programming language.

The use of Rails 6.1 is a small risk, in that it is unfamiliar, and may not mesh
completely with some of our existing libraries. However, this is offset by the
fact that we will likely have to migrate our existing Rails applications to
v6.x at some point, and so using Rails 6.1 for this project may provide
additional insight into the migration process.
