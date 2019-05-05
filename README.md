# ActiveAdminRole

*CAUTION: Sorry, this gem is not maintained now. I'm looking for maintainer has motivation for apps using ActiveAdmin. Please somebody help me. [See more](https://github.com/yhirano55/active_admin_role/issues/19)*

Role based authorization with CanCanCan for Active Admin

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_admin_role'
```

And run `bundle`

## Dependencies

- rails (>= 5.0.0)
- activeadmin (>= 1.2.0)
- cancancan (>= 1.15.0)

## Sample application

https://github.com/yhirano55-playground/active_admin_role_sample

## Usage

1. Run this command after `rails generate active_admin:install`:

```sh
$ bin/rails generate active_admin_role:install
  create  config/initializers/active_admin_role.rb
  insert  app/models/admin_user.rb
  create  db/migrate/20161128090641_add_role_to_admin_users.rb
  create  db/migrate/20161128090642_create_active_admin_managed_resources.rb
  create  db/migrate/20161128090643_create_active_admin_permissions.rb
  create  app/models/ability.rb
    gsub  config/initializers/active_admin.rb
  create  app/admin/permissions.rb
  insert  app/admin/admin_users.rb

$ bin/rails db:migrate
```

2. You have to login as **admin** after migration.

3. You have to **Reload** permissions.

![](https://cloud.githubusercontent.com/assets/15371677/20662507/015c877c-b597-11e6-82dc-bf80dac8c6e9.png)

4. Edit permissions however you like.

![](https://cloud.githubusercontent.com/assets/15371677/20662765/2a8be9c0-b598-11e6-88c5-b9b7c018c876.png)

5. Of course, you can edit AdminUser's roles.

![](https://cloud.githubusercontent.com/assets/15371677/20662882/ba2f9f18-b598-11e6-8a4b-ed7c6d5b1246.png)

## Configuration

```ruby
ActiveAdminRole.configure do |config|
  # [Required:Hash]
  # == Role | default: { guest: 0, support: 1, staff: 2, manager: 3, admin: 99 }
  config.roles = { guest: 0, support: 1, staff: 2, manager: 3, admin: 99 }

  # [Optional:Array]
  # == Special roles which don't need to manage on database
  config.super_user_roles = [:admin]
  config.guest_user_roles = [:guest]

  # [Optional:String]
  # == User class name | default: 'AdminUser'
  config.user_class_name = "AdminUser"

  # [Optional:Symbol]
  # == Default permission | default: :cannot
  config.default_state = :cannot
end
```

## License

[MIT License](http://opensource.org/licenses/MIT)
