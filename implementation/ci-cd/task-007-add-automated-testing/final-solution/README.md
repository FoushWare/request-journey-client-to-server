# Code Quality Configuration Files

This directory contains example configuration files for code quality tools.

## Frontend Configuration

- `.eslintrc.json`: ESLint configuration for Next.js/React/TypeScript
- `.prettierrc`: Prettier formatting configuration
- `.prettierignore`: Files to exclude from Prettier formatting

## Backend Configuration

- `.eslintrc.json`: ESLint configuration for Node.js/Express
- `.prettierrc`: Prettier formatting configuration
- `.prettierignore`: Files to exclude from Prettier formatting

## Usage

1. Copy these files to your project directories
2. Install required dependencies:
   ```bash
   # Frontend
   npm install --save-dev eslint eslint-config-next prettier
   
   # Backend
   npm install --save-dev eslint eslint-config-standard prettier
   ```
3. Customize rules as needed for your project

## Notes

- ESLint and Prettier can work together
- Run `npm run lint` and `npm run format:check` to verify
- Adjust rules based on your team's preferences

