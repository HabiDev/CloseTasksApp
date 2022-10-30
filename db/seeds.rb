# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Department.create(name: 'Офис') unless Department.any?
department = Department.first
department.sub_departments.create(name: 'Администрация') unless SubDepartment.any?

sub_department = SubDepartment.first

Position.create(name: 'Администратор') unless Position.any?
position = Position.first

Category.create(name: 'Монтажные работы') unless Category.any?
category = Category.first

category.sub_categories.create(name: 'Сборка и монтаж кассового блока') unless SubCategory.any?

Division.create(name: 'Офис', department: department, address: 'г.Казань', email: 'office@mail.ru') unless Division.any?

User.create(email: 'fd@mail.ru', type_role: 'admin', password: 'Kzn2021$') unless User.any?

user = User.first

user.build_profile(full_name: 'Администратор', mobile: '+79274000000', 
                   sub_department_id: sub_department.id, 
                   position_id: position.id)
user.save

