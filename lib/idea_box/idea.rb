require 'idea_box'

class Idea
  attr_reader :title, :description, :rank, :id, :tags, :created_at
  include Comparable

  def initialize(attributes)
    @title = attributes["title"]
    @description = attributes["description"]
    @rank = attributes["rank"] || 0
    @id = attributes["id"]
    @tags = attributes["tags"] || []
    @created_at = Time.new.strftime('%A %l:%M %p')
  end

  def save
    IdeaStore.create(to_h)
  end


  def to_h
    {
      "title" => title,
      "description" => description,
      "rank" => rank,
      "tags" => tags,
      "created_at" => created_at
    }
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end

end
