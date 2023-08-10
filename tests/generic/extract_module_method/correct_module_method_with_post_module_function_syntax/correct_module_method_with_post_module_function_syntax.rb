module TestModule
  def bad_method
  end

  def good_method
  end

  def naughty_method
  end

  module_function :bad_method, :good_method, :naughty_method
end
