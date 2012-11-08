# coding = utf-8
class TagsController < ApplicationController
  def new
  end

  def create
    puts "-----get tag content:" + params[:content]
    @t = Tag.new()
    @t.content = params[:content]
    if @t.save!
      puts "--------saved successful"
    else
      puts "--------failed"
    end
  end

  def destroy
  end
end
