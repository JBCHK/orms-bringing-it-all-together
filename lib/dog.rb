class Dog
attr_accessor :name, :breed
attr_reader :id 

def initialize (name: , breed:, id: nil)
    @name = name,
    @breed = breed,
    @id = id 
end

def self.create_table
    sql = <<-SQL
            CREATE TABLE IF NOT EXISTS dogs (
             id INTEGER PRIMARY KEY,
             name TEXT,
             breed TEXT   
            )
        SQL

    DB[:conn].execute(sql)
end

def self.drop_table
    sql = <<-SQL
            DROP TABLE dogs
          SQL

    DB[:conn].execute(sql)
end

def save
  if self.id
      self.update
  else
  insert = <<-SQL
           INSERT INTO dogs (name, breed) VALUES (?, ?)
        SQL

  DB[:conn].execute(insert, self.name, self.breed)
  row = DB[:conn].execute("SELECT * FROM dogs WHERE name = ?", self.name)[0]
  @id = row[0]
  self
  end
end

def self.create(name:, breed:)
dog = self.new(name, breed)
dog.save
dog
end

def self.new_from_db(row)
id = row[0]
name = row[1]
breed = row[2]

self.new(id, name, breed)
self
end

def self.find_by_id(id)
sql = <<-SQL
SELECT * FROM dogs WHERE id = ? 
SQL

arr = DB[:conn].execute(sql, id).first

dog = self.new(arr[0], arr[1], arr[2])

dog
end

def self.find_by_name(name)
sql = <<-SQL
        SELECT * FROM dogs WHERE name = ? 
        SQL

arr = DB[:conn].execute(sql, name).first

dog = self.new(arr[0], arr[1], arr[2])
dog
end

def self.find_or_create_by_name(name)
   hypot = DB[:conn].execute("SELECT * FROM dogs WHERE name = ?", name)[0]
   id = hypot[0]

   if !!hypot.name || !!hypot.breed
     self.find_by_id(id)
   else
     self.create(name, breed)
   end
end

def update
    maintain = <<-SQL
                UPDATE TABLE gods SET name = ? WHERE id = ?
                SQL

    DB[:conn].execute(maintain, self.name, self.id)
end


end
