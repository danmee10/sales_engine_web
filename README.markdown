### Setup for Development

Clone, run `bundle`, then from the terminal:

```
bundle exec rake db:migrate
bundle exec rake db:test_prepare
```

The first line runs the migrations against your development database, the second sets up your test database.