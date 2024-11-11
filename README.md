# symfony-docker-init

## Description

This is a simple project to start a Symfony project with Docker.

## Requirements

- Docker
- Docker Compose
- Make

## Installation

In the root of the project, run the following command:

```bash
wget -O - https://raw.githubusercontent.com/samuelferri/symfony-docker-init/refs/heads/main/install.bash | bash
```

When the container is up, run the following command to install the requirements and restart the container:

```bash
make install-packages
make down
make build
make up
```

## Installed Packages

- **symfony/orm-pack**: Provides a set of commonly used Doctrine ORM packages for Symfony.
- **symfony/uid**: A library for generating unique identifiers.
- **nelmio/cors-bundle**: Adds support for Cross-Origin Resource Sharing (CORS) in Symfony applications.
- **symfony/maker-bundle (dev)**: A bundle to generate code for Symfony applications.
- **zenstruck/foundry (dev)**: A library for creating and managing test data.
- **friendsofphp/php-cs-fixer (dev)**: A tool to automatically fix PHP coding standards issues.
- **phpstan/phpstan (dev)**: A static analysis tool for finding bugs in PHP code.
- **phpstan/phpstan-doctrine (dev)**: PHPStan extension for Doctrine ORM.
- **phpstan/phpstan-phpunit (dev)**: PHPStan extension for PHPUnit.
- **phpstan/phpstan-strict-rules (dev)**: A set of strict rules for PHPStan.
- **phpstan/phpstan-symfony (dev)**: PHPStan extension for Symfony.
