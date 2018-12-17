class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  def initialize(student_hash)
    student_hash.each do |k,v|
      # binding.pry
      # if there is a setter method with the same name as a key, use it
      if Student.instance_methods(false).include?("#{k}=".to_sym)
        self.send("#{k}=", v)
      end
    end
    @@all << self
  end

  def self.create_from_collection(students_array)
    students_array.each { |s| Student.new(s) }
  end

  def add_student_attributes(attributes_hash)
    attributes_hash.each do |k,v|
      if Student.instance_methods(false).include?("#{k}=".to_sym)
        self.send("#{k}=", v)
      end
    end
    self
  end

  def self.all
    @@all
  end
end

