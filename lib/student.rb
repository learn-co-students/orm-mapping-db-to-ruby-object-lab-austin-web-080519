require "pry"
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    return student
  end

  def self.all
    sql = "SELECT * FROM students"
    allstudents = DB[:conn].execute(sql)
    allstudents.map{|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE NAME = ?"
    studentrow = DB[:conn].execute(sql, name).flatten
    self.new_from_db(studentrow)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9;"
    grade9students = DB[:conn].execute(sql)
    grade9students.map{|row| self.new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12;"
    smallstudents = DB[:conn].execute(sql)
    smallstudents.map{|row| self.new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(num)
    sql = "SELECT * FROM students WHERE grade = 10 ORDER BY id LIMIT ?;"
    students = DB[:conn].execute(sql, num)
    students.map{|row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 ORDER BY id LIMIT 1;"
    student = DB[:conn].execute(sql).flatten
    self.new_from_db(student)
  end

  def self.all_students_in_grade_X(num)
    sql = "SELECT * FROM students WHERE grade = ?"
    students = DB[:conn].execute(sql, num)
    students.map{|row| self.new_from_db(row)}
  end




end
