class Student
  attr_accessor :id, :name, :grade

  def initialize

  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_kid = self.new
    new_kid.id = row[0]
    new_kid.name = row[1]
    new_kid.grade = row[2]
    new_kid
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students;
    SQL
    array = DB[:conn].execute(sql)
    array.map do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      WHERE name LIKE ?;
    SQL
    array = DB[:conn].execute(sql, name).first
    self.new_from_db(array)
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
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade LIKE 9;
    SQL
    array = DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    student_array = []
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12;
    SQL
    array = DB[:conn].execute(sql).first
    student_array << self.new_from_db(array)
  end

  def self.first_X_students_in_grade_10(num)
    student_array = []
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?;
    SQL
    array = DB[:conn].execute(sql, num)
    array.each do |row|
      student_array << self.new_from_db(row)
    end
    student_array
  end

  def self.first_student_in_grade_10
    student_array = []
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT 1;
    SQL
    array = DB[:conn].execute(sql)
    array.each do |row|
      student_array << self.new_from_db(row)
    end
    # binding.pry
    student_array[0]
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade LIKE ?;
    SQL
    array = DB[:conn].execute(sql, grade)

  end
end
