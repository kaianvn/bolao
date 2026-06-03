FactoryGirl.define do
  
  factory :match do
    datetime Time.now
    team_a
    team_b
    group

    factory :future_match do
      datetime Time.now + 2.week.to_i
    end

    factory :past_match do
      datetime Time.now - 2.week.to_i
    end

    factory :knockout_match do
      phase 'knockout'
      group nil
      round 'round_of_16'
    end

  end
  
end