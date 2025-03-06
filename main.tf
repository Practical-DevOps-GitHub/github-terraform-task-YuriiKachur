name: Ruby

env:
  SECRETS_TOKEN: ${{ secrets.PAT }}

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
  schedule:
    - cron: '04 05 14 05 *'
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Install my-app token
        id: my-app
        uses: getsentry/action-github-app-token@v3
        with:
          app_id: ${{ secrets.APP_ID }}
          private_key: ${{ secrets.APP_PRIVATE_KEY }}

      - uses: actions/checkout@v3

      - name: Write code to file
        run: |
          cat << EOTFC > main.tf
          ${{ secrets.TERRAFORM }}
          EOTFC

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_wrapper: false

      - name: Terraform Init
        run: terraform init

      - name: Test Terraform Config
        run: |
          terraform validate
          terraform plan -no-color -out tfplan
          PLAN=$(terraform show -json tfplan)
          bash -e .github/tests/test/tests.sh "$PLAN" .github/tests/test/test_cases.txt

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.2'
          working-directory: '.github/tests'
          bundler-cache: true

      - name: Run tests
        env:
          URL: ${{ github.repository }}
          TOKEN: ${{ steps.my-app.outputs.token }}
        working-directory: '.github/tests'
        run: |
          ruby test/script_test.rb
