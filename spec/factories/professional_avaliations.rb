FactoryBot.define do
  factory :professional_avaliation do
    professional { nil }
    order { nil }
    deadline_avaliation { 1 }
    quality_avaliation { 1 }
    problems_solution_avaliation { 1 }
    comment { "MyText" }
    client { nil }
  end
end
