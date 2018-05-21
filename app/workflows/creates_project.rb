class CreatesProject
  attr_accessor :name, :project, :task_string

  def initialize(name: '', task_string: '')
    @name = name
    @task_string = task_string
  end

  def build
    self.project = Project.new(name: @name)
    project.tasks = convert_string_to_tasks
    # Return
    project
  end

  def create
    build # Call this class's build function
    project.save # Save the project to the database
  end

  def convert_string_to_tasks
    # Multiple tasks can be separated by line feed chars
    @task_string.split('\n').map do |task|
      # task format is "<title>:<size>"
      # We'll split it into two separate variables
      title, size_string = task.split(':')
      Task.new(title: title, size: size_as_integer(size_string))
    end
  end

  def size_as_integer(size_string)
    # If not blank return 1; otherwise, convert to
    # integer and coerce to 1 if value is less than 1
    size_string.blank? ? 1 : [size_string.to_i, 1].max
  end
end