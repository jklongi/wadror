FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :user2, class: User do
    username "Jussi"
    password "Foobar1"
    password_confirmation "Foobar1"
  end
  factory :user3, class: User do
    username "Matti"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end

  factory :rating3, class: Rating do
    score 30
  end

  factory :rating4, class: Rating do
    score 40
  end

  factory :brewery do
    name "anonymous"
    year 1900
  end

  factory :beer do
    name "anonymous"
    brewery
    style
  end

  factory :style do
    name "Lager"
    description "Jotain"
  end
end