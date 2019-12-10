module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = nil)
    base_title = "DriverGroups"
    [page_title, base_title].compact.reject(&:empty?).join(" | ")
  end
end
