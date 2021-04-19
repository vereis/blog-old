# Blog

This application is responsible for providing core functions which are to be
used by higher level applications in the umbrella (such as `Blog.Web`) to build
higher order business logic.

## Responsibilities

This application does 3 main things:

1) Uses Ecto and Etso (ETS driver for Ecto, rather than PSQL) to provide schemas
for structuring data and as a persistence layer
2) Provides a poller which polls GitHub's GraphQL API regularly to get any
updated GitHub Issues. These issues are parsed and are turned into posts for the
blog.
3) Provide some functions such as `Blog.Posts.list_posts_with_tag/1` which can
be used by another application to build pages.


## Structure

- Modules like `Blog.Posts` are contexts. These are high level modules which
    some functionality revolving around posts. Ideally modules nested within
    this namespace are used and exposed by `Blog.Posts` but not used externally.
- Modules like `Blog.Posts.Post` or `Blog.Posts.InternalLink` defines operations
    which are smaller in scope, for example, defining an Ecto Schema and
    providing composable database lookup fuctions versus containing domain
    specific logic for replacing internal links in posts respectively.
