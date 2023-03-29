# GOV.UK API Linting Web Service

## Overview

This repository contains the source code for the GOV.UK API Linting Web Service.

It is a Ruby on Rails web application that provides a simple and easy-to-use web interface that allows API developers to upload the OpenAPI specification for their API implementation and have it checked against various different linting rulesets.

Behind the scene, it uses the open-source tool Spectral to perform the actual linting, supplemented with GOV.UK specific rules.

An experimental code path also exists for testing the API specification against the commercial 42crunch service, which checks specifically for security issues.

The application can easily be installed and run on any machine that can run Ruby on Rails. (Windows, Linux or Mac OS X are all supported).

## Setup

### Prerequisites

This project depends on:

- [Ruby](https://www.ruby-lang.org/)
- [Ruby on Rails](https://rubyonrails.org/)
- [NodeJS](https://nodejs.org/)
- [Yarn](https://yarnpkg.com/)
- [Postgres](https://www.postgresql.org/)
- [npx](https://www.npmjs.com/package/npx)

### asdf

This project uses `asdf`. Use the following to install the required tools:

```sh
# The first time
brew install asdf # Mac-specific
asdf plugin add ruby
asdf plugin add nodejs
asdf plugin add yarn
asdf plugin add postgres

# To install (or update, following a change to .tool-versions)
asdf install
```

When installing the `pg` gem, bundle changes directory outside of this
project directory, causing it lose track of which version of postgres has
been selected in the project's `.tool-versions` file. To ensure the `pg` gem
installs correctly, you'll want to set the version of postgres that `asdf`
will use:

```sh
# Temporarily set the version of postgres to use to build the pg gem
ASDF_POSTGRES_VERSION=13.5 bundle install
```

### Rails Server Setup
```bash
bundle install
rake db:create db:migrate
bin/dev
```

To reset the database you can use:
```bash
rake db:reset db:migrate
```

To completely drop and recreate your database
```bash
rake db:drop db:create db:migrate
```

### Linting

To run the linters:

```bash
bin/lint
```

### Testing
To run the tests:

```bash
bundle exec rspec
```

### Intellisense

[solargraph](https://github.com/castwide/solargraph) is bundled as part of the
development dependencies. You need to [set it up for your
editor](https://github.com/castwide/solargraph#using-solargraph), and then run
this command to index your local bundle (re-run if/when we install new
dependencies and you want completion):

```sh
bin/bundle exec yard gems
```

You'll also need to configure your editor's `solargraph` plugin to
`useBundler`:

```diff
+  "solargraph.useBundler": true,
```
