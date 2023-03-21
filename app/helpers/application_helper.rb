# frozen_string_literal: true
module ApplicationHelper

  def line_count(items)
    items.sum { |item| item[:lines].length }
  end

end
