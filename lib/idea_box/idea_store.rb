require 'yaml/store'
require 'idea_box'

class IdeaStore


  def self.all
    raw_ideas.map.with_index do |data, i|
      Idea.new(data.merge("id" => i))
    end
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.find_raw_ideas(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end


  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.find(id)
    raw_idea = find_raw_ideas(id)
    Idea.new(raw_idea.merge("id" => id))
  end

  def self.find_all_by_tag(tag)
    all.select { |idea| idea.tags.include?(tag)}
  end

  def self.update(id, data)
    database.transaction do
      database['ideas'][id] = data
    end
  end

  def self.database
    return @database if @database
    @database = YAML::Store.new("db/ideabox")
    @database.transaction do
      @database['ideas'] ||= []
    end
    @database
  end

  def self.create(attributes)
    database.transaction do
      database['ideas'] << attributes
    end
  end
end
