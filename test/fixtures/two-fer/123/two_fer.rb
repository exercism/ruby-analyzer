class Test2
    def twofer(name="you")
        p "One for #{name}, one for me."
    end
end
two=Test2.new
two.twofer("Alice")